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
    procedure FormCreate(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnTampilClick(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure btnCariObatClick(Sender: TObject);
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
  public
    { Public declarations }
  end;

var
  fKartuStok: TfKartuStok;

implementation

uses
  dataModule, uBantuObatPenjualan, uSatuan;

{$R *.dfm}

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
  sisa      : Integer;
  noUrut    : Integer;
  masuk     : Integer;
  keluar    : Integer;
  tglExp    : string;
begin
  // ?? VALIDASI WAJIB
  if not Assigned(FcdsGrid) then
    raise Exception.Create('Data belum ditampilkan (FcdsGrid kosong)');

  if FcdsGrid.IsEmpty then
    raise Exception.Create('Data kosong, tidak bisa print');

  // buat query print kalau belum ada
  if not Assigned(FqryPrint) then
  begin
    FqryPrint := TADOQuery.Create(Self);
    FqryPrint.Connection := dm.con1;
  end;

  // hapus temp table
  FqryPrint.Close;
  FqryPrint.SQL.Text := 'DROP TEMPORARY TABLE IF EXISTS tmp_kartu_stok';
  FqryPrint.ExecSQL;

  // buat temp table
  FqryPrint.SQL.Text :=
    'CREATE TEMPORARY TABLE tmp_kartu_stok (' +
    '  no INT, tgl DATE, no_faktur VARCHAR(50), ' +
    '  no_batch VARCHAR(50), tgl_expired VARCHAR(20), ' +
    '  keterangan VARCHAR(50), masuk INT, keluar INT, sisa INT, ' +
    '  nie VARCHAR(30)' +
    ')';
  FqryPrint.ExecSQL;

  // isi data
  sisa   := FSisaAwal;
  noUrut := 0;

  FcdsGrid.First;
  while not FcdsGrid.Eof do
  begin
    noUrut := FcdsGrid.FieldByName('no').AsInteger;
    masuk  := FcdsGrid.FieldByName('masuk').AsInteger;
    keluar := FcdsGrid.FieldByName('keluar').AsInteger;
    sisa   := FcdsGrid.FieldByName('sisa').AsInteger;

    if FcdsGrid.FieldByName('tgl_expired').AsString = '-' then
      tglExp := '-'
    else
      tglExp := FormatDateTime('dd-mm-yyyy', FcdsGrid.FieldByName('tgl_expired').AsDateTime);

    FqryPrint.SQL.Text :=
      'INSERT INTO tmp_kartu_stok VALUES (' +
      IntToStr(noUrut) + ', ' +
      QuotedStr(FormatDateTime('yyyy-mm-dd', FcdsGrid.FieldByName('tgl').AsDateTime)) + ', ' +
      QuotedStr(FcdsGrid.FieldByName('no_faktur').AsString) + ', ' +
      QuotedStr(FcdsGrid.FieldByName('no_batch').AsString) + ', ' +
      QuotedStr(tglExp) + ', ' +
      QuotedStr(FcdsGrid.FieldByName('keterangan').AsString) + ', ' +
      IntToStr(masuk) + ', ' +
      IntToStr(keluar) + ', ' +
      IntToStr(sisa) + ', '+
      QuotedStr(FcdsGrid.FieldByName('nie').AsString) + ')';
    FqryPrint.ExecSQL;

    FcdsGrid.Next;
  end;

  // buka hasil
  FqryPrint.SQL.Text := 'SELECT * FROM tmp_kartu_stok ORDER BY no';
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
  qckrpQRpt.Page.Orientation := poPortrait; // ? ganti ke landscape supaya muat

  qckrpQRpt.DataSet := FqryPrint;

  // ?? pakai pixel (stabil)
  qckrpQRpt.Width := 780;

  // ================= HEADER =================
  bandHeader := TQRBand.Create(qckrpQRpt);
  bandHeader.Parent   := qckrpQRpt;
  bandHeader.BandType := rbPageHeader;
  bandHeader.Height   := 100; // ? tambah tinggi supaya ada jarak ke tabel

  // Judul
  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent := bandHeader;
  lbl.Caption := 'KARTU STOK';
  lbl.AutoSize := False;
  lbl.Alignment := taCenter;
  lbl.AlignToBand := True;
  lbl.SetBounds(0, 5, qckrpQRpt.Width, 20);
  lbl.Font.Style := [fsBold];

  // Nama Apotek (CENTER FIX)
  lbl := TQRLabel.Create(bandHeader);
  lbl.Parent := bandHeader;
  lbl.Caption := nmToko;
  lbl.AutoSize := False;
  lbl.Alignment := taCenter;
  lbl.AlignToBand := True;
  lbl.SetBounds(0, 25, qckrpQRpt.Width, 20);
  lbl.Font.Size := 12;
  lbl.Font.Style := [fsBold];

  // info obat
  // nama obat
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

  // NIE
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

  // Satuan
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
  colWidth[0] := 65;   // Tanggal
  colWidth[1] := 160;   // Nomer Dokumen
  colWidth[2] := 98;   // Sumber/Tujuan
  colWidth[3] := 105;  // NIE
  colWidth[4] := 50;   // Masuk
  colWidth[5] := 50;   // Keluar
  colWidth[6] := 55;   // Sisa Stok
  colWidth[7] := 80;   // No Batch
  colWidth[8] := 70;   // EXP Date
  colWidth[9] := 40;   // Ket
  // total = 720 + offset 10 = 730

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
    //kotak
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
    lbl.Font.Name := 'Arial';
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
    // ?? kotak tiap cell
    line := TQRShape.Create(bandDetail);
    line.Parent := bandDetail;
    line.Shape := qrsRectangle;
    line.SetBounds(colLeft[i], 0, colWidth[i], 28);
    line.Pen.Width := 1;

    FlblD[i] := TQRLabel.Create(bandDetail);
    FlblD[i].Parent := bandDetail;
    FlblD[i].SetBounds(colLeft[i], 2, colWidth[i], 24);
    FlblD[i].Alignment := taCenter;
    FlblD[i].Font.Size := 8;
    lbl.Font.Name := 'Arial';
  end;

  {FlblD[2].WordWrap := True;
  FlblD[2].AutoSize := False;
  FlblD[2].Width    := colWidth[1] - 4;
  FlblD[2].Height   := bandDetail.Height - 4;

  FlblD[1].Alignment := taLeftJustify;
  FlblD[1].Left := colLeft[2] + 5;
  FlblD[1].Width := colWidth[2] - 10;
  FlblD[1].AutoSize := False;
  FlblD[1].WordWrap := True;  }

  bandDetail.BeforePrint := DetailBeforePrint;
end;

procedure TFKartuStok.DetailBeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
var
  keluar, masuk: Integer;
  fs: TFormatSettings;
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
  FlblD[1].Caption := FqryPrint.FieldByName('no_faktur').AsString + ' / ' +
                      FqryPrint.FieldByName('keterangan').AsString;


  if FqryPrint.FieldByName('keterangan').AsString = 'Stok Awal' then
    FlblD[2].Caption := '-'  // Nomer Dokumen — kosong, tulis tangan
  else
    FlblD[2].Caption := '';  // Nomer Dokumen — kosong, tulis tangan

  FlblD[3].Caption := FqryPrint.FieldByName('nie').AsString;

  if masuk > 0 then
    FlblD[4].Caption := FormatFloat('#,##0', FqryPrint.FieldByName('masuk').AsFloat, fs)
  else
    FlblD[4].Caption := '-';

  if keluar > 0 then
    FlblD[5].Caption := FormatFloat('#,##0', FqryPrint.FieldByName('keluar').AsFloat, fs)
  else
    FlblD[5].Caption := '-';

  FlblD[6].Caption := FormatFloat('#,##0', FqryPrint.FieldByName('sisa').AsFloat, fs);
  FlblD[7].Caption := FqryPrint.FieldByName('no_batch').AsString;
  FlblD[8].Caption := FqryPrint.FieldByName('tgl_expired').AsString;
  FlblD[9].Caption := '';  // Ket — kosong
end;

procedure TfKartuStok.FormCreate(Sender: TObject);
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
      end

    // hitung stok awal sebelum periode
    {qry.Close;
    qry.SQL.Text :=
      'SELECT ' +
      '  COALESCE(SUM(dp.jumlah_beli), 0) - ' +
      '  COALESCE((' +
      '    SELECT SUM(pb.jumlah) FROM tbl_penjualan_batch pb ' +
      '    JOIN tbl_batch b ON b.id = pb.batch_id ' +
      '    JOIN tbl_penjualan pj ON pj.id = pb.penjualan_id ' +
      '    WHERE b.obat_id = ' + IntToStr(FObatID) +
      '      AND DATE(pj.tgl_penjualan) < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtpAwal.DateTime)) +
      '  ), 0) AS stok_awal ' +
      'FROM tbl_detail_pembelian dp ' +
      'JOIN tbl_pembelian p ON p.id = dp.pembelian_id ' +
      'WHERE dp.obat_id = ' + IntToStr(FObatID) +
      '  AND DATE(p.tgl_pembelian) < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtpAwal.DateTime));
    qry.Open;

    FSisaAwal              := qry.FieldByName('stok_awal').AsInteger;
    lblStokAwalVal.Caption := IntToStr(FSisaAwal);   }
  finally
    qry.Free;
  end;
end;

procedure TFKartuStok.HitungSummary;
var
  cds         : TClientDataSet;
  ds          : TDataSource;
  totalMasuk  : Integer;
  totalKeluar : Integer;
  sisa        : Integer;
  noUrut      : Integer;
begin
  totalMasuk  := 0;
  totalKeluar := 0;
  sisa        := FSisaAwal;
  noUrut      := 0;

  cds := TClientDataSet.Create(Self);
  ds  := TDataSource.Create(Self);
  try
    cds.FieldDefs.Add('no',          ftInteger,  0, False);
    cds.FieldDefs.Add('tgl',         ftDate,     0, False);
    cds.FieldDefs.Add('no_faktur',   ftString,  50, False);
    cds.FieldDefs.Add('nie',         ftString,  30, False);
    cds.FieldDefs.Add('no_batch',    ftString,  50, False);
    cds.FieldDefs.Add('tgl_expired', ftString,  20, False);
    cds.FieldDefs.Add('keterangan',  ftString,  20, False);
    cds.FieldDefs.Add('masuk',       ftInteger,  0, False);
    cds.FieldDefs.Add('keluar',      ftInteger,  0, False);
    cds.FieldDefs.Add('sisa',        ftInteger,  0, False);
    cds.FieldDefs.Add('paraf',       ftString,  30, False);
    cds.CreateDataSet;

    // baris pertama: stok awal
    Inc(noUrut);
    cds.Append;
    cds.FieldByName('no').AsInteger         := noUrut;
    cds.FieldByName('tgl').AsDateTime       := dtpAwal.DateTime;
    cds.FieldByName('no_faktur').AsString   := '-';
    cds.FieldByName('nie').AsString         := '-';
    cds.FieldByName('no_batch').AsString    := '-';
    cds.FieldByName('tgl_expired').AsString := '-';
    cds.FieldByName('keterangan').AsString  := 'Stok Awal';
    cds.FieldByName('masuk').AsInteger      := FSisaAwal;
    cds.FieldByName('keluar').AsInteger     := 0;
    cds.FieldByName('sisa').AsInteger       := FSisaAwal;
    cds.FieldByName('paraf').AsString       := '';
    cds.Post;

    // baris transaksi
    qryKartu.First;
    while not qryKartu.Eof do
    begin
      sisa := sisa
              + qryKartu.FieldByName('masuk').AsInteger
              - qryKartu.FieldByName('keluar').AsInteger;

      totalMasuk  := totalMasuk  + qryKartu.FieldByName('masuk').AsInteger;
      totalKeluar := totalKeluar + qryKartu.FieldByName('keluar').AsInteger;

      Inc(noUrut);
      cds.Append;
      cds.FieldByName('no').AsInteger          := noUrut;
      cds.FieldByName('tgl').AsDateTime        := qryKartu.FieldByName('tgl').AsDateTime;
      cds.FieldByName('no_faktur').AsString    := qryKartu.FieldByName('no_faktur').AsString;
      cds.FieldByName('nie').AsString          := qryKartu.FieldByName('nie').AsString;
      cds.FieldByName('no_batch').AsString     := qryKartu.FieldByName('no_batch').AsString;
      cds.FieldByName('tgl_expired').AsString  := FormatDateTime('dd/mm/yyyy', qryKartu.FieldByName('tgl_expired').AsDateTime);
      cds.FieldByName('keterangan').AsString   := qryKartu.FieldByName('keterangan').AsString;
      cds.FieldByName('masuk').AsInteger       := qryKartu.FieldByName('masuk').AsInteger;
      cds.FieldByName('keluar').AsInteger      := qryKartu.FieldByName('keluar').AsInteger;
      cds.FieldByName('sisa').AsInteger        := sisa;
      cds.FieldByName('paraf').AsString        := '';
      cds.Post;

      qryKartu.Next;
    end;

    ds.DataSet         := cds;
    dbgrd1.DataSource  := ds;

    FcdsGrid := cds;
    FdsGrid  := ds;

    lblMasukVal.Caption  := IntToStr(totalMasuk);
    lblKeluarVal.Caption := IntToStr(totalKeluar);
    lblSisaVal.Caption   := IntToStr(sisa);
    lblStatus.Caption    := IntToStr(noUrut - 1) + ' transaksi ditemukan  |  Periode: ' +
                            FormatDateTime('dd/mm/yyyy', dtpAwal.DateTime) + ' — ' +
                            FormatDateTime('dd/mm/yyyy', dtpAkhir.DateTime);
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
begin
  if edtObatId.Text = '' then FObatID := 0 else FObatID := StrToInt(edtObatId.Text);

  if FObatID = 0 then
    begin
      ShowMessage('Pilih obat terlebih dahulu.');
      Exit;
    end;

  //tampil stok
  FSisaAwal := StrToIntDef(edtStokAwal.Text, 0);
  lblStokAwalVal.Caption := IntToStr(FSisaAwal);

  TampilInfoObat;

  qryKartu.Close;
  qryKartu.SQL.Clear;
  qryKartu.SQL.Text :=
    'SELECT DATE(tgl) AS tgl, no_faktur, no_batch, tgl_expired, keterangan, masuk, keluar, nie ' +
    'FROM ( ' +
    '  SELECT DATE(p.tgl_pembelian) AS tgl, p.no_faktur, b.no_batch, b.tgl_expired, ' +
    '    ''Pembelian'' AS keterangan, dp.jumlah_beli AS masuk, 0 AS keluar, ' +
    '    b.nie_number AS nie ' +
    '  FROM tbl_detail_pembelian dp ' +
    '  JOIN tbl_pembelian p ON p.id = dp.pembelian_id ' +
    '  JOIN tbl_batch b ON b.obat_id = dp.obat_id AND b.pembelian_id = dp.pembelian_id ' +
    '  WHERE dp.obat_id = ' + IntToStr(FObatID) +
    '    AND DATE(p.tgl_pembelian) BETWEEN ' +
    QuotedStr(FormatDateTime('yyyy-mm-dd', dtpAwal.DateTime)) +
    '    AND ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtpAkhir.DateTime)) +
    '  UNION ALL ' +
    '  SELECT DATE(pj.tgl_penjualan) AS tgl, pj.no_faktur, b.no_batch, b.tgl_expired, ' +
    '    ''Penjualan'' AS keterangan, 0 AS masuk, pb.jumlah AS keluar, ' +
    '    b.nie_number AS nie ' +
    '  FROM tbl_penjualan_batch pb ' +
    '  JOIN tbl_batch b ON b.id = pb.batch_id ' +
    '  JOIN tbl_penjualan pj ON pj.id = pb.penjualan_id ' +
    '  WHERE b.obat_id = ' + IntToStr(FObatID) +
    '    AND DATE(pj.tgl_penjualan) BETWEEN ' +
    QuotedStr(FormatDateTime('yyyy-mm-dd', dtpAwal.DateTime)) +
    '    AND ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtpAkhir.DateTime)) +
    ') AS kartu ' +
    'ORDER BY tgl ASC, keterangan DESC';
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

end.
