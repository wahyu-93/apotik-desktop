unit U_Cetak;
interface
uses
  SysUtils, Printers, WinSpool;

procedure cetakFile(Const sFilename: string);
procedure SendCutCommand; // baru
function RataKanan(const VField, VItem: String; const VLength: Integer;
  const VSpace: Char): string;
function RataTengah(const Teks: string; const LebarBaris: Integer): string;

// Konstanta lebar karakter per ukuran kertas
const
  LEBAR_58MM  = 32;
  LEBAR_80MM  = 42;  // koreksi dari 32 -> 42 karakter
  LEBAR_96MM  = 56;  // ukuran baru

implementation

function RataKanan(const VField, VItem: String; const VLength: Integer;
  const VSpace: Char): string;
var
  __SStart: string;
  __SStop: string;
  __Length: LongInt;
begin
  __SStart := VField;
  __SStop := VItem;
  __Length := Length(__SStart) + Length(__SStop);
  Result := '';
  while __Length + Length(Result) < VLength do
    Result := Result + VSpace;
  Result := __SStart + Result + __SStop;
end;

function RataTengah(const Teks: string; const LebarBaris: Integer): string;
var
  Padding: Integer;
begin
  Padding := (LebarBaris - Length(Teks)) div 2;
  if Padding > 0 then
    Result := StringOfChar(' ', Padding) + Teks
  else
    Result := Teks;
end;

// --- Kirim ESC/POS command langsung ke printer (tanpa file) ---
procedure SendRawToPrinter(const Data: AnsiString);
var
  hPrinter: THandle;
  hDeviceMode: THandle;
  Device: Array [0..255] Of Char;
  Driver: Array [0..255] Of Char;
  Port:   Array [0..255] Of Char;
  DocInfo: record
    pDocname:    PChar;
    pOutputFile: PChar;
    pDataType:   PChar;
  end;
  BytesWritten: Cardinal;
begin
  Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
  if not WinSpool.OpenPrinter(@Device, hPrinter, nil) then Exit;

  DocInfo.pDocname    := 'CutCmd';
  DocInfo.pOutputFile := nil;
  DocInfo.pDataType   := 'RAW';

  if StartDocPrinter(hPrinter, 1, @DocInfo) = 0 then
  begin
    WinSpool.ClosePrinter(hPrinter);
    Exit;
  end;

  if StartPagePrinter(hPrinter) then
  begin
    WritePrinter(hPrinter, PAnsiChar(Data), Length(Data), BytesWritten);
    EndPagePrinter(hPrinter);
  end;

  EndDocPrinter(hPrinter);
  WinSpool.ClosePrinter(hPrinter);
end;

// --- Auto Cut Command ESC/POS ---
procedure SendCutCommand;
var
  CutCmd: AnsiString;
begin
  // Feed 4 baris dulu biar struk tidak kepotong terlalu mepet
  CutCmd := AnsiChar(27) + AnsiChar(100) + AnsiChar(4);  // ESC d 4 (feed 4 lines)
  // Full cut: GS V 0
  CutCmd := CutCmd + AnsiChar(29) + AnsiChar(86) + AnsiChar(0);
  SendRawToPrinter(CutCmd);
end;

// --- Cetak File RAW (tidak berubah dari aslinya) ---
procedure cetakFile(Const sFilename: string);
const
  cBUFSIZE = 16385;
var
  Count: Cardinal;
  BytesWritten: Cardinal;
  hPrinter: THandle;
  hDeviceMode: THandle;
  Device: Array [0..255] Of Char;
  Driver: Array [0..255] Of Char;
  Port:   Array [0..255] Of Char;
  DocInfo: record
    pDocname:    PChar;
    pOutputFile: PChar;
    pDataType:   PChar;
  end;
  f: File;
  Buffer: Pointer;
begin
  Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
  if not WinSpool.OpenPrinter(@Device, hPrinter, nil) then Exit;

  DocInfo.pDocname    := 'Report';
  DocInfo.pOutputFile := nil;
  DocInfo.pDataType   := 'RAW';

  if StartDocPrinter(hPrinter, 1, @DocInfo) = 0 then
  begin
    WinSpool.ClosePrinter(hPrinter);
    Exit;
  end;

  if not StartPagePrinter(hPrinter) then
  begin
    EndDocPrinter(hPrinter);
    WinSpool.ClosePrinter(hPrinter);
    Exit;
  end;

  System.Assign(f, sFilename);
  try
    Reset(f, 1);
    GetMem(Buffer, cBUFSIZE);
    try
      while not Eof(f) do
      begin
        Blockread(f, Buffer^, cBUFSIZE, Count);
        if Count > 0 then
          if not WritePrinter(hPrinter, Buffer, Count, BytesWritten) then Break;
      end;
    finally
      FreeMem(Buffer, cBUFSIZE);
    end;
  finally
    System.CloseFile(f);
  end;

  EndPagePrinter(hPrinter);
  EndDocPrinter(hPrinter);
  WinSpool.ClosePrinter(hPrinter);

  // ? Kirim auto cut setelah file selesai dicetak
  SendCutCommand;
end;

end.
