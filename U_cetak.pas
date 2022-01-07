unit U_Cetak;

interface

uses
  SysUtils, Printers, WinSpool;
procedure cetakFile(Const sFilename: string);
function RataKanan(const VField, VItem: String; const VLength: Integer;
  const VSpace: Char): string;

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

procedure cetakFile(Const sFilename: string);
const
  cBUFSIZE = 16385;
type
  TDoc_Info_1 = record
    pDocname: PChar;
    pOutputFile: PChar;
    pDataType: PChar;
  end;
var
  Count: Cardinal;
  BytesWritten: Cardinal;
  hPrinter: THandle;
  hDeviceMode: THandle;
  Device: Array [0 .. 255] Of Char;
  Driver: Array [0 .. 255] Of Char;
  Port: Array [0 .. 255] Of Char;
  DocInfo: TDoc_Info_1;
  f: File;
  Buffer: Pointer;
begin
  Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
  If Not WinSpool.OpenPrinter(@Device, hPrinter, Nil) Then
    Exit;
  DocInfo.pDocname := 'Report';
  DocInfo.pOutputFile := Nil;
  DocInfo.pDataType := 'RAW';

  If StartDocPrinter(hPrinter, 1, @DocInfo) = 0 Then
  begin
    WinSpool.ClosePrinter(hPrinter);
    Exit;
  end;

  If Not StartPagePrinter(hPrinter) Then
  begin
    EndDocPrinter(hPrinter);
    WinSpool.ClosePrinter(hPrinter);
    Exit;
  end;

  System.Assign(f, sFilename);
  try
    Reset(f, 1);
    GetMem(Buffer, cBUFSIZE);
    While Not Eof(f) Do
    begin
      Blockread(f, Buffer^, cBUFSIZE, Count);
      If Count > 0 Then
      begin
        If Not WritePrinter(hPrinter, Buffer, Count, BytesWritten) Then
        begin
          EndPagePrinter(hPrinter);
          EndDocPrinter(hPrinter);
          WinSpool.ClosePrinter(hPrinter);
          FreeMem(Buffer, cBUFSIZE);
          Exit;
        end;
      end;
    end;
    FreeMem(Buffer, cBUFSIZE);
    EndDocPrinter(hPrinter);
    WinSpool.ClosePrinter(hPrinter);
  finally
    System.CloseFile(f);
  end;
end;

end. 