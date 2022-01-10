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
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLapClick(Sender: TObject);
    procedure rbTanggalClick(Sender: TObject);
    procedure rbBulanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLaporanPenjualan: TfLaporanPenjualan;

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
  
  konek;
end;
procedure TfLaporanPenjualan.btnLapClick(Sender: TObject);
var query : string;
begin
  if (rbTanggal.Checked = false) and (rbBulan.Checked = False) then
    begin
      MessageDlg('Jenis Laporan Belum Dipilih',mtInformation, [mbOK], 0);
      Exit;
    end;

  if rbTanggal.Checked = True then
    begin
      query := 'select * from tbl_penjualan left JOIN tbl_pelanggan on tbl_penjualan.id_pelanggan = tbl_pelanggan.id '+
               'where date(tbl_penjualan.tgl_penjualan) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',dtp1.Date))+' order by tbl_penjualan.id asc';
    end
  else if rbBulan.Checked = True then
    begin
      if (cbbTahun.Text = '') or (cbbBulan.Text = '') then
        begin
          MessageDlg('Bulan dan Tahun Wajib Diisi',mtInformation,[mbOK],0);
          Exit;
        end
      else
        begin
          query := 'select * from tbl_penjualan left JOIN tbl_pelanggan on tbl_penjualan.id_pelanggan = tbl_pelanggan.id '+
               'where month(tbl_penjualan.tgl_penjualan) = '+QuotedStr(IntToStr(cbbBulan.ItemIndex+1)+'-'+cbbTahun.Text)+' order by tbl_penjualan.id asc';
        end;
    end;

  with dm.qryLaporanPenjualan do
    begin
      close;
      SQL.Clear;
      sql.Text := query;
      Open;
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

end.
