unit uKartuStok;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg, Buttons, ComCtrls, Grids, DBGrids, DateUtils,
  DB, ADODB, DBClient, MidasLib, QuickRpt, QRCtrls, QRPrntr, Printers;

type
  TfKartuStok = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    pnlFilter: TPanel;
    lbl2: TLabel;
    edtNamaObat: TEdit;
    edtObatId: TEdit;
    btnCariObat: TBitBtn;
    bvl1: TBevel;
    lbl3: TLabel;
    dtpAwal: TDateTimePicker;
    lbl4: TLabel;
    dtpAkhir: TDateTimePicker;
    btnTampil: TBitBtn;
    btnPrint: TBitBtn;
    pnlInfo: TPanel;
    lbl5: TLabel;
    lblNamaVal: TLabel;
    lbl6: TLabel;
    lblNIEVal: TLabel;
    lbl7: TLabel;
    lblProdusenVal: TLabel;
    lbl8: TLabel;
    lblSatuanVal: TLabel;
    lbl9: TLabel;
    lblStokAwalVal: TLabel;
    bvl2: TBevel;
    bvl3: TBevel;
    bvl4: TBevel;
    bvl5: TBevel;
    pnlSummary: TPanel;
    pnlPasuk: TPanel;
    lbl10: TLabel;
    lblMasukVal: TLabel;
    pnlKeluar: TPanel;
    lbl11: TLabel;
    lblKeluarVal: TLabel;
    pnlSisa: TPanel;
    lbl13: TLabel;
    lblSisaVal: TLabel;
    pnlFisik: TPanel;
    lbl15: TLabel;
    lblFisik: TLabel;
    pnlStatus: TPanel;
    lblStatus: TLabel;
    dbgrd1: TDBGrid;
    qryKartu: TADOQuery;
    qryInfo: TADOQuery;
    dsKartu: TDataSource;
    btnKeluar: TBitBtn;
    edtStokAwal: TEdit;
    qckrpQRpt: TQuickRep;
    pnl1: TPanel;
    lbl12: TLabel;
    lblReturJualVal: TLabel;
    pnl2: TPanel;
    lbl14: TLabel;
    lblReturBeliVal: TLabel;
    procedure btnPrintClick(Sender: TObject);
    procedure btnTampilClick(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure btnCariObatClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FObatID     : Integer;
    FSisaAwal   : Integer;
    FqryKartu   : TADOQuery;
    FdsKartu    : TDataSource;
    FPrintRow   : Integer;
    FcdsGrid    : TClientDataSet;
    FdsGrid     : TDataSource;
    FlblD       : array[0..9] of TQRLabel;
    FqryPrint   : TADOQuery;
    qryInfoObat : TADOQuery;
    procedure SetupGrid;
    procedure TampilInfoObat;
    procedure HitungSummary;
    procedure SetupQuickReport;
    procedure BuildPrintQuery;
    procedure LoadInfoObat(idObat: Integer);
    procedure DetailBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
    function GetSaldoAwal(AObatID: string; ATglMulai: TDateTime): Integer;
  public
    { Public declarations }
  end;

var
  fKartuStok: TfKartuStok;

implementation

uses
  dataModule, uBantuObatPenjualan, uSatuan;

{$R *.dfm}

function TFKartuStok.GetSaldoAwal(AObatID: string; ATglMulai: TDateTime): Integer;
var
  qry: TADOQuery;
  sTgl: string;
begin
  Result := 0;
  sTgl := FormatDateTime('yyyy-mm-dd', ATglMulai);
  
  qry := TADOQuery.Create(nil);
  try
    qry.Connection := dm.con1;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT SUM(masuk) - SUM(keluar) as saldo_awal');
    qry.SQL.Add('FROM tbl_kartu_stok');
    // Menggunakan QuotedStr untuk keamanan string dan format tanggal
    qry.SQL.Add('WHERE obat_id = ' + QuotedStr(AObatID));
    qry.SQL.Add('AND tgl < ' + QuotedStr(sTgl));
    qry.Open;

    if not qry.FieldByName('saldo_awal').IsNull then
      Result := qry.FieldByName('saldo_awal').AsInteger;
  finally
    qry.Free;
  end;
end;

procedure TFKartuStok.LoadInfoObat(idObat: Integer);
begin
  if not Assigned(qryInfoObat) then
  begin
    qryInfoObat := TADOQuery.Create(Self);
    qryInfoObat.Connection := dm.con1;
  end;

  qryInfoObat.Close;
  qryInfoObat.SQL.Text :=
    'SELECT o.nama_obat, s.satuan, o.produsen ' +
    'FROM tbl_obat o ' +
    'LEFT JOIN tbl_satuan s ON s.id = o.kode_satuan ' +
    'WHERE o.id = ' + IntToStr(idObat);

  qryInfoObat.Open;
end;

procedure TFKartuStok.BuildPrintQuery;
var
  tglExp : string;
begin
  // 1. VALIDASI WAJIB
  if not Assigned(FcdsGrid) then
    raise Exception.Create('Data belum ditampilkan (FcdsGrid kosong)');

  if FcdsGrid.IsEmpty then
    raise Exception.Create('Data kosong, tidak bisa print');

  // Inisialisasi FqryPrint jika belum ada
  if not Assigned(FqryPrint) then
  begin
    FqryPrint := TADOQuery.Create(Self);
    FqryPrint.Connection := dm.con1;
  end;

  // 2. RE-CREATE TEMPORARY TABLE
  FqryPrint.Close;
  FqryPrint.SQL.Clear;
  // Menggunakan semicolon (;) jika MySQL mengizinkan multiple statement, 
  // tapi paling aman satu per satu ExecSQL
  FqryPrint.SQL.Text := 'DROP TEMPORARY TABLE IF EXISTS tmp_kartu_stok';
  FqryPrint.ExecSQL;

  FqryPrint.SQL.Text :=
    'CREATE TEMPORARY TABLE tmp_kartu_stok (' +
    '  no INT, tgl DATE, no_faktur VARCHAR(50), ' +
    '  no_batch VARCHAR(50), tgl_expired VARCHAR(20), ' +
    '  keterangan VARCHAR(50), masuk INT, keluar INT, sisa INT, ' +
    '  nie VARCHAR(30)' +
    ')';
  FqryPrint.ExecSQL;

  // 3. ISI DATA DARI CDS KE TEMP TABLE
  FcdsGrid.DisableControls; // Mempercepat proses loop
  try
    FcdsGrid.First;
    while not FcdsGrid.Eof do
    begin
      // Ambil tgl_expired langsung dari string CDS karena sudah diformat di HitungSummary
      tglExp := FcdsGrid.FieldByName('tgl_expired').AsString;

      FqryPrint.SQL.Clear;
      FqryPrint.SQL.Add('INSERT INTO tmp_kartu_stok VALUES (');
      FqryPrint.SQL.Add(IntToStr(FcdsGrid.FieldByName('no').AsInteger) + ', ');
      FqryPrint.SQL.Add(QuotedStr(FormatDateTime('yyyy-mm-dd', FcdsGrid.FieldByName('tgl').AsDateTime)) + ', ');
      FqryPrint.SQL.Add(QuotedStr(FcdsGrid.FieldByName('no_faktur').AsString) + ', ');
      FqryPrint.SQL.Add(QuotedStr(FcdsGrid.FieldByName('no_batch').AsString) + ', ');
      FqryPrint.SQL.Add(QuotedStr(tglExp) + ', ');
      FqryPrint.SQL.Add(QuotedStr(FcdsGrid.FieldByName('keterangan').AsString) + ', ');
      FqryPrint.SQL.Add(IntToStr(FcdsGrid.FieldByName('masuk').AsInteger) + ', ');
      FqryPrint.SQL.Add(IntToStr(FcdsGrid.FieldByName('keluar').AsInteger) + ', ');
      FqryPrint.SQL.Add(IntToStr(FcdsGrid.FieldByName('sisa').AsInteger) + ', ');
      FqryPrint.SQL.Add(QuotedStr(FcdsGrid.FieldByName('nie').AsString) + ')');
      FqryPrint.ExecSQL;

      FcdsGrid.Next;
    end;
  finally
    FcdsGrid.EnableControls;
  end;

  // 4. BUKA HASIL AKHIR
  FqryPrint.Close;
  FqryPrint.SQL.Text := 'SELECT * FROM tmp_kartu_stok ORDER BY no ASC';
  FqryPrint.Open;
end;

procedure TFKartuStok.SetupQuickReport;
var
  bandHeader, bandColHead, bandDetail, bandSummary: TQRBand;
  lbl: TQRLabel;
  lblH: array[0..9] of TQRLabel;
  colLeft, colWidth: array[0..9] of Integer;
  i, x: Integer;

  line : TQRShape;
  qrySetting: TADOQuery;
  nmToko, alamat, telp: string;
begin
  // ================= AMBIL DATA APOTEK =================
  qrySetting := TADOQuery.Create(nil);
  try
    qrySetting.Connection := dm.con1;
    qrySetting.SQL.Text := 'SELECT * FROM tbl_setting LIMIT 1';
    qrySetting.Open;

    if not qrySetting.IsEmpty then
    begin
      nmToko := qrySetting.FieldByName('nama_toko').AsString;
      alamat := qrySetting.FieldByName('alamat').AsString;
      telp   := qrySetting.FieldByName('telp').AsString;
    end
    else
    begin
      nmToko := 'NAMA APOTEK';
      alamat := '-';
      telp   := '-';
    end;
  finally
    qrySetting.Free;
  end;

  // ================= SET REPORT =================
  qckrpQRpt.DataSet := nil;
  qckrpQRpt.Page.PaperSize := A4;
  qckrpQRpt.Page.Orientation := poPortrait;
  qckrpQRpt.DataSet := FqryPrint;
  qckrpQRpt.Width := 780;

  // ================= HEADER =================
  bandHeader := TQRBand.Create(qckrpQRpt);
  bandHeader.Parent   := qckrpQRpt;
  bandHeader.BandType := rbPageHeader;
  bandHeader.Height   := 100;

  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent := bandHeader;
  lbl.Caption := 'KARTU STOK';
  lbl.AutoSize := False;
  lbl.Alignment := taCenter;
  lbl.AlignToBand := True;
  lbl.SetBounds(0, 5, qckrpQRpt.Width, 20);
  lbl.Font.Style := [fsBold];

  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent := bandHeader;
  lbl.Caption := nmToko;
  lbl.AutoSize := False;
  lbl.Alignment := taCenter;
  lbl.AlignToBand := True;
  lbl.SetBounds(0, 25, qckrpQRpt.Width, 20);
  lbl.Font.Size := 12;
  lbl.Font.Style := [fsBold];

  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent    := bandHeader;
  lbl.Caption   := 'Nama Obat';
  lbl.SetBounds(10, 45, 70, 15);
  lbl.Font.Size := 9;

  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent    := bandHeader;
  lbl.Caption   := ':';
  lbl.SetBounds(82, 45, 10, 15);
  lbl.Font.Size := 9;

  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent    := bandHeader;
  lbl.Caption   := lblNamaVal.Caption;
  lbl.SetBounds(95, 45, 600, 15);
  lbl.Font.Size := 9;

  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent    := bandHeader;
  lbl.Caption   := 'NIE';
  lbl.SetBounds(10, 60, 70, 15);
  lbl.Font.Size := 9;

  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent    := bandHeader;
  lbl.Caption   := ':';
  lbl.SetBounds(82, 60, 10, 15);
  lbl.Font.Size := 9;

  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent    := bandHeader;
  lbl.Caption   := lblNIEVal.Caption;
  lbl.SetBounds(95, 60, 600, 15);
  lbl.Font.Size := 9;

  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent    := bandHeader;
  lbl.Caption   := 'Satuan';
  lbl.SetBounds(10, 75, 70, 15);
  lbl.Font.Size := 9;

  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent    := bandHeader;
  lbl.Caption   := ':';
  lbl.SetBounds(82, 75, 10, 15);
  lbl.Font.Size := 9;

  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent    := bandHeader;
  lbl.Caption   := lblSatuanVal.Caption;
  lbl.SetBounds(95, 75, 600, 15);
  lbl.Font.Size := 9;

  // ================= KOLOM =================
  colWidth[0] := 65;
  colWidth[1] := 160;
  colWidth[2] := 98;
  colWidth[3] := 105;
  colWidth[4] := 50;
  colWidth[5] := 50;
  colWidth[6] := 55;
  colWidth[7] := 90;
  colWidth[8] := 60;
  colWidth[9] := 40;

  x := 0;
  for i := 0 to 9 do
  begin
    colLeft[i] := x;
    x := x + colWidth[i];
  end;

  // ================= HEADER TABEL =================
  bandColHead := TQRBand.Create(qckrpQRpt);
  bandColHead.Parent := qckrpQRpt;
  bandColHead.BandType := rbColumnHeader;
  bandColHead.Height := 28;

  for i := 0 to 9 do
  begin
    line := TQRShape.Create(bandColHead);
    line.Parent := bandColHead;
    line.Shape := qrsRectangle;
    line.SetBounds(colLeft[i], 0, colWidth[i], 29);
    line.Pen.Width := 1;

    lblH[i] := TQRLabel.Create(bandColHead);
    lblH[i].Parent := bandColHead;
    lblH[i].SetBounds(colLeft[i], 5, colWidth[i], 24);
    lblH[i].Alignment := taCenter;
    lblH[i].Font.Style := [fsBold];
    lblH[i].Font.Size := 8;
    lblH[i].Font.Name := 'Arial';  // fix: tadinya lbl.Font.Name (salah variable)
  end;

  lblH[0].Caption := 'Tanggal';
  lblH[1].Caption := 'Nomer Dokumen';
  lblH[2].Caption := 'Sumber / Tujuan';
  lblH[3].Caption := 'NIE';
  lblH[4].Caption := 'Masuk';
  lblH[5].Caption := 'Keluar';
  lblH[6].Caption := 'Sisa Stok';
  lblH[7].Caption := 'No Batch';
  lblH[8].Caption := 'EXP Date';
  lblH[9].Caption := 'Ket';

  // ================= DETAIL =================
  bandDetail := TQRBand.Create(qckrpQRpt);
  bandDetail.Parent := qckrpQRpt;
  bandDetail.BandType := rbDetail;
  bandDetail.Height := 28;

  for i := 0 to 9 do
  begin
    line := TQRShape.Create(bandDetail);
    line.Parent := bandDetail;
    line.Shape := qrsRectangle;
    line.SetBounds(colLeft[i], 0, colWidth[i], 28);
    line.Pen.Width := 1;

    FlblD[i] := TQRLabel.Create(bandDetail);
    FlblD[i].Parent := bandDetail;
    FlblD[i].SetBounds(colLeft[i], 2, colWidth[i], 24);
    FlblD[i].Alignment := taCenter;
    FlblD[i].Font.Size := 7;
    FlblD[i].Font.Name := 'Arial';  // fix: tadinya lbl.Font.Name (salah variable)
  end;

  // kolom 1 - Nomer Dokumen: rata kiri, teks dipotong di DetailBeforePrint
  FlblD[1].Alignment := taLeftJustify;
  FlblD[1].Left      := colLeft[1] + 3;
  FlblD[1].Width     := colWidth[1] - 6;
  FlblD[1].AutoSize  := False;

  // kolom 3 - nie
  FlblD[3].Alignment := taLeftJustify;
  FlblD[3].Left      := colLeft[3] + 3;
  FlblD[3].Width     := colWidth[3] - 6;
  FlblD[3].AutoSize  := False;

  // kolom 7 - batch
  FlblD[7].Alignment := taLeftJustify;
  FlblD[7].Left      := colLeft[7] + 3;
  FlblD[7].Width     := colWidth[7] - 6;
  FlblD[7].AutoSize  := False;

  bandDetail.BeforePrint := DetailBeforePrint;
end;

procedure TFKartuStok.DetailBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
var
  keluar, masuk: Integer;
  fs: TFormatSettings;
  fullText: string;
begin
  PrintBand := True;

  GetLocaleFormatSettings(0, fs);
  fs.ThousandSeparator := '.';
  fs.DecimalSeparator  := ',';

  if not Assigned(FqryPrint) then Exit;
  if not FqryPrint.Active    then Exit;
  if FqryPrint.IsEmpty       then Exit;

  keluar := FqryPrint.FieldByName('keluar').AsInteger;
  masuk  := FqryPrint.FieldByName('masuk').AsInteger;

  FlblD[0].Caption := FormatDateTime('dd-mm-yyyy', FqryPrint.FieldByName('tgl').AsDateTime);
  FlblD[0].Font.Size := 7;

  // potong teks supaya tidak kepotong saat cetak
  fullText := FqryPrint.FieldByName('no_faktur').AsString + '/' +
              FqryPrint.FieldByName('keterangan').AsString;
  FlblD[1].Caption := fullText;
  FlblD[1].Font.Size := 7;       

  if FqryPrint.FieldByName('keterangan').AsString = 'Stok Awal' then
    FlblD[2].Caption := '-'
  else
    FlblD[2].Caption := '';
  FlblD[2].Font.Size := 7;

  FlblD[3].Caption := FqryPrint.FieldByName('nie').AsString;
  FlblD[3].Font.Size := 7;

  if masuk > 0 then
    FlblD[4].Caption := FormatFloat('#,##0', FqryPrint.FieldByName('masuk').AsFloat, fs)
  else
    FlblD[4].Caption := '-';
  FlblD[4].Font.Size := 7;

  if keluar > 0 then
    FlblD[5].Caption := FormatFloat('#,##0', FqryPrint.FieldByName('keluar').AsFloat, fs)
  else
    FlblD[5].Caption := '-';
  FlblD[5].Font.Size := 7;

  FlblD[6].Caption := FormatFloat('#,##0', FqryPrint.FieldByName('sisa').AsFloat, fs);
  FlblD[6].Font.Size := 7;

  FlblD[7].Caption := FqryPrint.FieldByName('no_batch').AsString;
  FlblD[7].Font.Size := 7;

  FlblD[8].Caption := FqryPrint.FieldByName('tgl_expired').AsString;
  FlblD[8].Font.Size := 7;

  FlblD[9].Caption := '';
end;

procedure TFKartuStok.SetupGrid;
begin
  dbgrd1.ReadOnly := True;
  dbgrd1.Options  := dbgrd1.Options + [dgRowLines, dgColLines];

  with dbgrd1.Columns do
  begin
    Clear;
    with Add do begin Title.Caption := 'No';          FieldName := 'no';          Width := 35;  end;
    with Add do begin Title.Caption := 'Tanggal';     FieldName := 'tgl';         Width := 75;  end;
    with Add do begin Title.Caption := 'No. Batch';   FieldName := 'no_batch';    Width := 90;  end;
    with Add do begin Title.Caption := 'Expired';     FieldName := 'tgl_expired'; Width := 70;  end;
    with Add do begin Title.Caption := 'No. Faktur';  FieldName := 'no_faktur';   Width := 110; end;
    with Add do begin Title.Caption := 'Keterangan';  FieldName := 'keterangan';  Width := 80;  end;
    with Add do begin Title.Caption := 'Masuk';       FieldName := 'masuk';       Width := 55;  end;
    with Add do begin Title.Caption := 'Keluar';      FieldName := 'keluar';      Width := 55;  end;
    with Add do begin Title.Caption := 'Sisa';        FieldName := 'sisa';        Width := 55;  end;
    with Add do begin Title.Caption := 'Paraf';       FieldName := 'paraf';       Width := 55;  end;
  end;
end;

procedure TFKartuStok.TampilInfoObat;
var
  qry: TADOQuery;
begin
  qry := TADOQuery.Create(nil);
  try
    qry.Connection := dm.con1;

    // ambil info obat
    qry.SQL.Text :=
      'SELECT o.nama_obat, s.satuan, o.produsen, ' +
      '(SELECT nie_number FROM tbl_batch WHERE obat_id = o.id ' +
      ' ORDER BY id DESC LIMIT 1) AS nie ' +
      'FROM tbl_obat o ' +
      'LEFT JOIN tbl_satuan s ON s.id = o.kode_satuan ' +
      'WHERE o.id = ' + IntToStr(FObatID);
    qry.Open;

    if not qry.IsEmpty then
      begin
        lblNamaVal.Caption     := qry.FieldByName('nama_obat').AsString;

        if qry.FieldByName('nie').AsString = '' then
          begin
            lblNIEVal.Caption      := '-';
          end
        else
          begin
            lblNIEVal.Caption      := qry.FieldByName('nie').AsString;
          end;

        if qry.FieldByName('produsen').AsString = '' then
          begin
            lblProdusenVal.Caption      := '-';
          end
        else
          begin
            lblProdusenVal.Caption      := qry.FieldByName('produsen').AsString;
          end;

        lblSatuanVal.Caption   := qry.FieldByName('satuan').AsString;
      end;

    qry.Close;
    qry.SQL.Text :=
      'SELECT COALESCE(SUM(jumlah_awal),0) AS stok_awal ' + 
      'FROM tbl_batch ' +
      'WHERE obat_id = ' + IntToStr(FObatID) + ' ' +
      'AND is_migrasi = 1';

    qry.Open;

    FSisaAwal := qry.FieldByName('stok_awal').AsInteger;
    lblStokAwalVal.Caption := IntToStr(FSisaAwal);
  finally
    qry.Free;
  end;
end;

procedure TFKartuStok.HitungSummary;
var
  cds             : TClientDataSet;
  ds              : TDataSource;
  tMasuk, tKeluar : Integer;
  tReturJual      : Integer;
  tReturBeli      : Integer;
  runningSisa     : Integer;
  noUrut          : Integer;
  vObatID         : string;
begin
  // 1. Inisialisasi Variabel
  tMasuk := 0; tKeluar := 0;
  tReturJual := 0; tReturBeli := 0;
  noUrut := 0;
  
  // Ambil ID Obat dari input (asumsi ada edit/combo untuk pilih obat)
  vObatID := edtObatID.Text; 

  // 2. Ambil Stok Awal sebelum periode filter
  FSisaAwal := GetSaldoAwal(vObatID, dtpAwal.Date);
  runningSisa := FSisaAwal;

  cds := TClientDataSet.Create(Self);
  ds  := TDataSource.Create(Self);
  try
    // Setup Struktur Kolom Memory Table
    cds.FieldDefs.Add('no',          ftInteger);
    cds.FieldDefs.Add('tgl',         ftDate);
    cds.FieldDefs.Add('no_faktur',   ftString, 50);
    cds.FieldDefs.Add('nie',         ftString, 30);
    cds.FieldDefs.Add('no_batch',    ftString, 50);
    cds.FieldDefs.Add('tgl_expired', ftString, 20);
    cds.FieldDefs.Add('keterangan',  ftString, 50);
    cds.FieldDefs.Add('masuk',       ftInteger);
    cds.FieldDefs.Add('keluar',      ftInteger);
    cds.FieldDefs.Add('sisa',        ftInteger);
    cds.CreateDataSet;

    // 3. Proses Data dari Query Utama (qryKartu)
    qryKartu.First;
    while not qryKartu.Eof do
    begin
      // Identifikasi Tipe Transaksi untuk Label Summary
      // Sesuaikan string 'pembelian', 'penjualan' dsb dengan isi field ref_type Anda
      if qryKartu.FieldByName('ref_type').AsString = 'pembelian' then
        tMasuk := tMasuk + qryKartu.FieldByName('masuk').AsInteger
      else if qryKartu.FieldByName('ref_type').AsString = 'penjualan' then
        tKeluar := tKeluar + qryKartu.FieldByName('keluar').AsInteger
      else if qryKartu.FieldByName('ref_type').AsString = 'retur_jual' then
        tReturJual := tReturJual + qryKartu.FieldByName('masuk').AsInteger
      else if qryKartu.FieldByName('ref_type').AsString = 'retur_beli' then
        tReturBeli := tReturBeli + qryKartu.FieldByName('keluar').AsInteger
      else if qryKartu.FieldByName('ref_type').AsString = 'migrasi' then
        tMasuk := tMasuk + qryKartu.FieldByName('masuk').AsInteger;

      // Hitung Saldo Berjalan (Running Balance)
      runningSisa := runningSisa + qryKartu.FieldByName('masuk').AsInteger - qryKartu.FieldByName('keluar').AsInteger;

      // Tambah Baris ke Grid
      Inc(noUrut);
      cds.Append;
      cds.FieldByName('no').AsInteger        := noUrut;
      cds.FieldByName('tgl').AsDateTime      := qryKartu.FieldByName('tgl').AsDateTime;
      cds.FieldByName('no_faktur').AsString  := qryKartu.FieldByName('no_faktur').AsString;
      cds.FieldByName('nie').AsString        := qryKartu.FieldByName('nie').AsString;
      cds.FieldByName('no_batch').AsString   := qryKartu.FieldByName('no_batch').AsString;
      
      if not qryKartu.FieldByName('tgl_expired').IsNull then
        cds.FieldByName('tgl_expired').AsString := FormatDateTime('dd/mm/yyyy', qryKartu.FieldByName('tgl_expired').AsDateTime)
      else
        cds.FieldByName('tgl_expired').AsString := '-';

      // Gunakan sumber/keterangan dari DB, atau ref_type yang diproses
      cds.FieldByName('keterangan').AsString := qryKartu.FieldByName('sumber').AsString;
      cds.FieldByName('masuk').AsInteger      := qryKartu.FieldByName('masuk').AsInteger;
      cds.FieldByName('keluar').AsInteger     := qryKartu.FieldByName('keluar').AsInteger;
      cds.FieldByName('sisa').AsInteger       := runningSisa; 
      cds.Post;

      qryKartu.Next;
    end;

    // 4. Update UI Grid
    ds.DataSet := cds;
    dbgrd1.DataSource := ds;
    
    // Simpan reference agar bisa diprint atau di-export
    FcdsGrid := cds; 
    FdsGrid  := ds;

    // 5. Update Label Summary
    lblStokAwalVal.Caption  := IntToStr(FSisaAwal);
    lblMasukVal.Caption     := IntToStr(tMasuk);
    lblKeluarVal.Caption    := IntToStr(tKeluar);
    lblReturJualVal.Caption := IntToStr(tReturJual);
    lblReturBeliVal.Caption := IntToStr(tReturBeli);
    lblSisaVal.Caption      := IntToStr(runningSisa); // Sisa akhir periode

    lblStatus.Caption := Format('%d transaksi ditemukan | Periode: %s s/d %s', 
                         [noUrut, FormatDateTime('dd/mm/yyyy', dtpAwal.Date), 
                         FormatDateTime('dd/mm/yyyy', dtpAkhir.Date)]);

  except
    on E: Exception do
      ShowMessage('Error HitungSummary: ' + E.Message);
  end;
end;

procedure TfKartuStok.btnPrintClick(Sender: TObject);
var
  i : Integer;
begin
  if not btnPrint.Enabled then Exit;

  try
    // hapus semua komponen di dalam QRpt
    for i := qckrpQRpt.ComponentCount - 1 downto 0 do
      qckrpQRpt.Components[i].Free;

    BuildPrintQuery;
    SetupQuickReport;

    FqryPrint.First;
    qckrpQRpt.Preview;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

procedure TfKartuStok.btnTampilClick(Sender: TObject);
var
  sTglAwal  : string;
  sTglAkhir : string;
  sObatID   : string;
begin
  { -- Validasi -- }
  if edtObatId.Text = '' then
    FObatID := 0
  else
    FObatID := StrToIntDef(edtObatId.Text, 0);
 
  if FObatID = 0 then
  begin
    MessageDlg('Pilih Obat Terlebih Dahulu.', mtInformation, [mbok],0);
    Exit;
  end;
 
  { -- Siapkan parameter -- }
  sObatID   := IntToStr(FObatID);
  sTglAwal  := QuotedStr(FormatDateTime('yyyy-mm-dd', dtpAwal.DateTime));
  sTglAkhir := QuotedStr(FormatDateTime('yyyy-mm-dd', dtpAkhir.DateTime));
 
  //FSisaAwal := StrToIntDef(edtStokAwal.Text, 0);
  lblStokAwalVal.Caption := IntToStr(FSisaAwal);

  TampilInfoObat;

  qryKartu.Close;
  qryKartu.SQL.Clear;
  qryKartu.SQL.Text := 'SELECT * FROM tbl_kartu_stok WHERE obat_id = '+sObatID
                       +' AND DATE(tgl_full) BETWEEN ' + sTglAwal + ' AND ' + sTglAkhir
                       +' ORDER BY created_at ASC ';
  qryKartu.Open;

  HitungSummary;

  btnPrint.Enabled := True;
end;

procedure TfKartuStok.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfKartuStok.btnCariObatClick(Sender: TObject);
begin
  btnPrint.Enabled := False;
  fBantuObatPenjualan.edtType.Text := 'kartuStok';
  fBantuObatPenjualan.ShowModal;
end;

procedure TfKartuStok.FormShow(Sender: TObject);
begin
  FObatID   := 0;
  FSisaAwal := 0;

  edtObatId.Clear;
  edtObatId.Visible    := False;
  edtNamaObat.ReadOnly := True;
  edtNamaObat.Clear;

  edtStokAwal.Text := '0';

  dtpAwal.DateTime  := EncodeDate(YearOf(Now), MonthOf(Now), 1);
  dtpAkhir.DateTime := Now;

  btnPrint.Enabled := False;

  qryKartu.Connection := dm.con1;
  qryInfo.Connection  := dm.con1;
  dsKartu.DataSet     := qryKartu;
  dbgrd1.DataSource   := dsKartu;

  SetupGrid;

  lblMasukVal.Caption  := '-';
  lblKeluarVal.Caption := '-';
  lblReturJualVal.Caption  := '-';
  lblReturBeliVal.Caption  := '-';
  lblSisaVal.Caption   := '-';
  lblStokAwalVal.Caption := '-';

  lblNamaVal.Caption := '-';
  lblNIEVal.Caption := '-';
  lblProdusenVal.Caption := '-';
  lblSatuanVal.Caption := '-';
  lblStokAwalVal.Caption := '-';

  lblStatus.Caption := '-';

  qryKartu.Close;
end;

procedure TfKartuStok.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F2: btnCariObat.Click;
    VK_F10: btnKeluar.Click;
  end;
end;

end.
