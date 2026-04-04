unit uKartuStok;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg, Buttons, ComCtrls, Grids, DBGrids, DateUtils,
  DB, ADODB, DBClient, MidasLib;

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
    procedure FormCreate(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnTampilClick(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure btnCariObatClick(Sender: TObject);
  private
    { Private declarations }
    FObatID   : Integer;
    FSisaAwal : Integer;
    procedure SetupGrid;
    procedure TampilInfoObat;
    procedure HitungSummary;
  public
    { Public declarations }
  end;

var
  fKartuStok: TfKartuStok;

implementation

uses
  dataModule, uBantuObatPenjualan;

{$R *.dfm}

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
  dbgrd1.DataSource  := dsKartu;

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
      lblNIEVal.Caption      := qry.FieldByName('nie').AsString;
      lblProdusenVal.Caption := qry.FieldByName('produsen').AsString;
      lblSatuanVal.Caption   := qry.FieldByName('satuan').AsString;
    end;

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
    cds.FieldDefs.Add('no_batch',    ftString,  50, False);
    cds.FieldDefs.Add('tgl_expired', ftString, 20, False);
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
    dbgrd1.DataSource := ds;

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
begin
  // akan diisi setelah QuickReport selesai disusun
  ShowMessage('Fitur print akan segera dibuat.');
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
    'SELECT DATE(tgl) AS tgl, no_faktur, no_batch, tgl_expired, keterangan, masuk, keluar ' +
    'FROM ( ' +
    '  SELECT DATE(p.tgl_pembelian) AS tgl, p.no_faktur, b.no_batch, b.tgl_expired, ' +
    '    ''Pembelian'' AS keterangan, dp.jumlah_beli AS masuk, 0 AS keluar ' +
    '  FROM tbl_detail_pembelian dp ' +
    '  JOIN tbl_pembelian p ON p.id = dp.pembelian_id ' +
    '  JOIN tbl_batch b ON b.obat_id = dp.obat_id AND b.pembelian_id = dp.pembelian_id ' +
    '  WHERE dp.obat_id = ' + IntToStr(FObatID) +
    '    AND DATE(p.tgl_pembelian) BETWEEN ' +
    QuotedStr(FormatDateTime('yyyy-mm-dd', dtpAwal.DateTime)) +
    '    AND ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtpAkhir.DateTime)) +
    '  UNION ALL ' +
    '  SELECT DATE(pj.tgl_penjualan) AS tgl, pj.no_faktur, b.no_batch, b.tgl_expired, ' +
    '    ''Penjualan'' AS keterangan, 0 AS masuk, pb.jumlah AS keluar ' +
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
