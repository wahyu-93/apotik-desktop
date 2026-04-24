unit uListJualObat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ComCtrls, Buttons, jpeg, ExtCtrls;

type
  TfLaporanPenjualan = class(TForm)
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
    dbgrdPenjualan: TDBGrid;
    pnl1: TPanel;
    lblJumlah: TLabel;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLapClick(Sender: TObject);
    procedure rbTanggalClick(Sender: TObject);
    procedure rbBulanClick(Sender: TObject);
    procedure cbbBulanKeyPress(Sender: TObject; var Key: Char);
    procedure cbbTahunKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLaporanPenjualan: TfLaporanPenjualan;
  a : Integer;
  total : real;

implementation

uses
  dataModule;

{$R *.dfm}

procedure konek;
begin
   with dm.qryLaporanPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_penjualan left JOIN tbl_pelanggan on tbl_penjualan.id_pelanggan = tbl_pelanggan.id '+
                  'where tbl_penjualan.tgl_penjualan like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%'' order by tbl_penjualan.id asc';
      Open;
    end;
end;

procedure TfLaporanPenjualan.btnKeluarClick(Sender: TObject);
begin
  Close;
end;

procedure TfLaporanPenjualan.FormShow(Sender: TObject);
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
  
  with dm.qryLaporanPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_penjualan left JOIN tbl_pelanggan on tbl_penjualan.id_pelanggan = tbl_pelanggan.id '+
                  'where tbl_penjualan.tgl_penjualan like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%'' order by tbl_penjualan.id asc';
      Open;

      total := 0;
      for a:= 1 to RecordCount do
        begin
          RecNo := a;
          total := total + (fieldbyname('total').AsFloat);
         
          Next;
        end;

      lblJumlah.Caption := 'Jumlah Transaksi : '+ IntToStr(RecordCount)+ ' - Total Penjualan : ' + FormatFloat('Rp. ###,###,###', total);
    end;
end;

procedure TfLaporanPenjualan.btnLapClick(Sender: TObject);
var
  query      : string;
  queryTotal : string;
  whereClause: string;
begin
  if (not rbTanggal.Checked) and (not rbBulan.Checked) then
  begin
    MessageDlg('Jenis Laporan Belum Dipilih', mtInformation, [mbOK], 0);
    Exit;
  end;

  if rbTanggal.Checked then
  begin
    whereClause :=
      'date(tbl_penjualan.tgl_penjualan) = ' +
      QuotedStr(FormatDateTime('yyyy-mm-dd', dtp1.Date));
  end
  else
  begin
    if cbbTahun.Text = '' then
    begin
      MessageDlg('Tahun Wajib Diisi', mtInformation, [mbOK], 0);
      Exit;
    end;

    whereClause :=
      'year(tbl_penjualan.tgl_penjualan) = ' + QuotedStr(cbbTahun.Text) +
      ' and tbl_penjualan.status = ' + QuotedStr('selesai');

    if cbbBulan.Text <> '-' then
      whereClause :=
        'month(tbl_penjualan.tgl_penjualan) = ' +
        IntToStr(cbbBulan.ItemIndex) +
        ' and ' + whereClause;
  end;

  // Query utama — select * seperti aslinya, tidak ada tambahan field
  query :=
    'select * from tbl_penjualan ' +
    'left join tbl_pelanggan on tbl_penjualan.id_pelanggan = tbl_pelanggan.id ' +
    'where ' + whereClause +
    ' order by tbl_penjualan.id asc';
  
  // Query total — MySQL yang hitung, bukan loop Delphi
  queryTotal :=
    'select count(*) as jumlah, coalesce(sum(total), 0) as grand_total ' +
    'from tbl_penjualan where ' + whereClause;

  with dm.qryLaporanPenjualan do
  begin
    Close;
    SQL.Clear;
    SQL.Text := query;
    Open;
  end;

  with dm.qryTemp do
  begin
    Close;
    SQL.Clear;
    SQL.Text := queryTotal;
    Open;
    lblJumlah.Caption :=
      'Jumlah Transaksi : ' + FieldByName('jumlah').AsString +
      '  —  Total Penjualan : ' +
      FormatFloat('Rp. ###,###,###', FieldByName('grand_total').AsFloat);
    Close;
  end;
end;

procedure TfLaporanPenjualan.rbTanggalClick(Sender: TObject);
begin
  dtp1.Enabled := True;

  cbbTahun.Text := ''; cbbTahun.Enabled := false;
  cbbBulan.Text := ''; cbbBulan.Enabled := false;
end;

procedure TfLaporanPenjualan.rbBulanClick(Sender: TObject);
begin
  dtp1.Enabled := false;

  cbbTahun.Text := ''; cbbTahun.Enabled := True;
  cbbBulan.Text := ''; cbbBulan.Enabled := True;
end;

procedure TfLaporanPenjualan.cbbBulanKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;

procedure TfLaporanPenjualan.cbbTahunKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;

end.
