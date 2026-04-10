unit uLaporanItemTerjual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ComCtrls, Buttons, jpeg, ExtCtrls;

type
  TfLaporanJumlahItemTerjual = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    rbTanggal: TRadioButton;
    rbBulan: TRadioButton;
    dtp1: TDateTimePicker;
    cbbBulan: TComboBox;
    cbbTahun: TComboBox;
    btnLap: TBitBtn;
    dbgrdItemLaris: TDBGrid;
    btnPreview: TBitBtn;
    procedure btnKeluarClick(Sender: TObject);
    procedure rbBulanClick(Sender: TObject);
    procedure rbTanggalClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLapClick(Sender: TObject);
    procedure cbbBulanKeyPress(Sender: TObject; var Key: Char);
    procedure cbbTahunKeyPress(Sender: TObject; var Key: Char);
    procedure btnPreviewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLaporanJumlahItemTerjual: TfLaporanJumlahItemTerjual;

implementation

uses
  dataModule, UReportItemTerlaris;

{$R *.dfm}

procedure konek;
begin
  with dm.qryLaporanItemLaris do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'select *, sum(a.jumlah_jual) as jmlItemJual from tbl_penjualan z left join tbl_detail_penjualan a on z.id = a.penjualan_id left join '+
                  'tbl_obat b on a.obat_id = b.id left join tbl_satuan d on d.id = b.kode_satuan where date(z.tgl_penjualan) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+' group by a.obat_id order by jmlItemJual desc';
      Open;
    end;
end;

procedure TfLaporanJumlahItemTerjual.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfLaporanJumlahItemTerjual.rbBulanClick(Sender: TObject);
begin
  dtp1.Enabled := false;

  cbbTahun.Text := ''; cbbTahun.Enabled := True;
  cbbBulan.Text := ''; cbbBulan.Enabled := True;
end;

procedure TfLaporanJumlahItemTerjual.rbTanggalClick(Sender: TObject);
begin
  dtp1.Enabled := True;

  cbbTahun.Text := ''; cbbTahun.Enabled := false;
  cbbBulan.Text := ''; cbbBulan.Enabled := false;
end;

procedure TfLaporanJumlahItemTerjual.FormShow(Sender: TObject);
var thnSekarang, i : Integer;
begin
  rbTanggal.Checked := false;
  rbBulan.Checked := false;

  dtp1.Date := Now;
  cbbBulan.Text := '';

  cbbTahun.Clear;
  thnSekarang := StrToInt(FormatDateTime('yyyy', now));
  for i := 0 to 9 do
    begin
       cbbTahun.Items.Add(IntToStr(thnSekarang - i));
    end;
  cbbTahun.Text := '';

  dtp1.Enabled := false;
  cbbTahun.Enabled := False;
  cbbBulan.Enabled := False;
  
  konek;
end;

{procedure TfLaporanJumlahItemTerjual.btnLapClick(Sender: TObject);
var
  query       : string;
  whereClause : string;
begin
  if (not rbTanggal.Checked) and (not rbBulan.Checked) then
  begin
    MessageDlg('Jenis Laporan Belum Dipilih', mtInformation, [mbOK], 0);
    Exit;
  end;

  if rbTanggal.Checked then
  begin
    whereClause :=
      'date(z.tgl_penjualan) = ' +
      QuotedStr(FormatDateTime('yyyy-mm-dd', dtp1.Date));
  end
  else
  begin
    if cbbTahun.Text = '' then
    begin
      MessageDlg('Tahun Wajib Diisi', mtInformation, [mbOK], 0);
      Exit;
    end;

    whereClause := 'year(z.tgl_penjualan) = ' + QuotedStr(cbbTahun.Text);

    // Fix bug: filter bulan pakai dua kondisi terpisah, bukan digabung jadi string
    if cbbBulan.Text <> '-' then
      whereClause :=
        'month(z.tgl_penjualan) = ' + IntToStr(cbbBulan.ItemIndex + 1) +
        ' and ' + whereClause;
  end;

  // Pilih kolom spesifik saja, bukan select *
  query :=
    'select b.kode, b.nama_obat, d.satuan, ' +
    'sum(a.jumlah_jual) as jmlItemJual ' +
    'from tbl_penjualan z ' +
    'left join tbl_detail_penjualan a on z.id = a.penjualan_id ' +
    'left join tbl_obat b on a.obat_id = b.id ' +
    'left join tbl_satuan d on d.id = b.kode_satuan ' +
    'where ' + whereClause +
    ' group by a.obat_id, b.kode, b.nama_obat, d.satuan' +
    ' order by jmlItemJual desc';

  with dm.qryLaporanItemLaris do
  begin
    Close;
    SQL.Clear;
    SQL.Text := query;
    Open;

    if IsEmpty then
      begin
        MessageDlg('Tidak Ada Data Pada Perioder Ini', mtInformation,[mbOK],0);
        btnPreview.Enabled := false;
      end
    else
      begin
        btnPreview.Enabled := True;
      end;
  end;
end;  }

procedure TfLaporanJumlahItemTerjual.btnLapClick(Sender: TObject);
var
  sWhere : string;
  sQuery : string;
  iBulan : Integer;
begin
  { -- Validasi jenis laporan -- }
  if (not rbTanggal.Checked) and (not rbBulan.Checked) then
  begin
    MessageDlg('Jenis Laporan Belum Dipilih', mtInformation, [mbOK], 0);
    Exit;
  end;
 
  { ============================================================
    Bangun WHERE clause
    ============================================================ }
  if rbTanggal.Checked then
  begin
    { Filter per tanggal spesifik }
    sWhere :=
      'DATE(z.tgl_penjualan) = ' +
      QuotedStr(FormatDateTime('yyyy-mm-dd', dtp1.Date));
  end
  else
  begin
    { Filter per bulan/tahun }
    if Trim(cbbTahun.Text) = '' then
    begin
      MessageDlg('Tahun Wajib Diisi', mtInformation, [mbOK], 0);
      Exit;
    end;
 
    { Tahun selalu wajib }
    sWhere := 'YEAR(z.tgl_penjualan) = ' + QuotedStr(Trim(cbbTahun.Text));
 
    { Bulan opsional: ItemIndex 0 = '-' (semua bulan) }
    if cbbBulan.ItemIndex > 0 then
    begin
      iBulan := cbbBulan.ItemIndex; { ItemIndex 1=Jan, 2=Feb, dst }
      sWhere :=
        'MONTH(z.tgl_penjualan) = ' + IntToStr(iBulan) +
        ' AND ' + sWhere;
    end;
  end;
 
  { ============================================================
    Query utama: UNION ALL antara tabel aktif + arsip
    Supaya laporan tetap bisa tampil meski data sudah diarsip
    ============================================================ }
  sQuery :=
    'SELECT ' +
    '  ob.kode, ' +
    '  ob.nama_obat, ' +
    '  sat.satuan, ' +
    '  SUM(det.jmlItemJual) AS jmlItemJual ' +
    'FROM ( ' +
 
    { -- Sumber 1: tbl_penjualan (data aktif) -- }
    '  SELECT ' +
    '    a.obat_id, ' +
    '    a.jumlah_jual AS jmlItemJual, ' +
    '    z.tgl_penjualan ' +
    '  FROM tbl_penjualan z ' +
    '  LEFT JOIN tbl_detail_penjualan a ON z.id = a.penjualan_id ' +
    '  WHERE ' + sWhere +
 
    '  UNION ALL ' +
 
    { -- Sumber 2: arsip_penjualan (data > 1 tahun) -- }
    '  SELECT ' +
    '    a.obat_id, ' +
    '    a.jumlah_jual AS jmlItemJual, ' +
    '    z.tgl_penjualan ' +
    '  FROM arsip_penjualan z ' +
    '  LEFT JOIN arsip_detail_penjualan a ON z.id = a.penjualan_id ' +
    '  WHERE ' + sWhere +
 
    ') AS det ' +
    'LEFT JOIN tbl_obat   ob  ON ob.id  = det.obat_id ' +
    'LEFT JOIN tbl_satuan sat ON sat.id = ob.kode_satuan ' +
    'WHERE det.obat_id IS NOT NULL ' +
    'GROUP BY det.obat_id, ob.kode, ob.nama_obat, sat.satuan ' +
    'ORDER BY jmlItemJual DESC';
 
  { ============================================================
    Jalankan query
    ============================================================ }
  with dm.qryLaporanItemLaris do
  begin
    Close;
    SQL.Clear;
    SQL.Text := sQuery;
    Open;
 
    if IsEmpty then
    begin
      MessageDlg(
        'Tidak Ada Data Pada Periode Ini',
        mtInformation, [mbOK], 0
      );
      btnPreview.Enabled := False;
    end
    else
      btnPreview.Enabled := True;
  end;
end;

procedure TfLaporanJumlahItemTerjual.cbbBulanKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;

procedure TfLaporanJumlahItemTerjual.cbbTahunKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;

procedure TfLaporanJumlahItemTerjual.btnPreviewClick(Sender: TObject);
begin
if (not rbTanggal.Checked) and (not rbBulan.Checked) then
  begin
    MessageDlg('Jenis Laporan Belum Dipilih', mtInformation, [mbOK], 0);
    Exit;
  end;

  with dm.qrySetting do
    begin
      Close;
      sql.Clear;
      sql.Text := 'select nama_toko, alamat, telp from tbl_setting';
      Open;
    end;

  with QuickReportJumlahItemTerjual do
    begin
      qrlblNamaApotek.Caption := dm.qrySetting.fieldbyname('nama_toko').AsString;

      if rbTanggal.Checked then
        begin
          qrlblLaporanBulanTanggal.Caption := 'Laporan Pertanggal : ' + FormatDateTime('dd-MM-yyyy', dtp1.Date);
        end
      else
        begin
          qrlblLaporanBulanTanggal.Caption := 'Laporan Bulan : ' +cbbBulan.Text+' Tahun ' +cbbTahun.Text;
        end;

      Prepare;
      Preview;
    end;
end;

end.
