unit uLaporanPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls, ComCtrls;

type
  TfLaporanPembelian = class(TForm)
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
    dbgrdPembelian: TDBGrid;
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
  fLaporanPembelian: TfLaporanPembelian;

implementation

uses
  dataModule;

{$R *.dfm}

procedure konek;
begin
  with dm.qryLaporanPembelian do
    begin
      close;
      SQL.Clear;
      sql.Text := 'select * from tbl_pembelian left join tbl_supplier on tbl_pembelian.supplier_id = tbl_supplier.id '+
                  'where date(tbl_pembelian.tgl_pembelian) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+' order by tbl_pembelian.id asc';
      Open;
    end;
end;

procedure TfLaporanPembelian.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfLaporanPembelian.FormShow(Sender: TObject);
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

procedure TfLaporanPembelian.btnLapClick(Sender: TObject);
var query : string;
begin
  if (rbTanggal.Checked = false) and (rbBulan.Checked = False) then
    begin
      MessageDlg('Jenis Laporan Belum Dipilih',mtInformation, [mbOK], 0);
      Exit;
    end;

  if rbTanggal.Checked = True then
    begin
      query := 'select * from tbl_pembelian left join tbl_supplier on tbl_pembelian.supplier_id = tbl_supplier.id '+
             'where date(tbl_pembelian.tgl_pembelian) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',dtp1.Date))+' order by tbl_pembelian.id asc';
    end
  else if rbBulan.Checked = True then
    begin
      if cbbTahun.Text = '' then
        begin
          MessageDlg('Tahun Wajib Diisi',mtInformation,[mbOK],0);
          Exit;
        end
      else
        begin
          if cbbBulan.Text <> '-' then
            begin
              query := 'select * from tbl_pembelian left join tbl_supplier on tbl_pembelian.supplier_id = tbl_supplier.id '+
                 'where month(tbl_pembelian.tgl_pembelian) = '+QuotedStr(IntToStr(cbbBulan.ItemIndex)+'-'+cbbTahun.Text)+' order by tbl_pembelian.id asc';

            end
          else
            begin
             query := 'select * from tbl_pembelian left join tbl_supplier on tbl_pembelian.supplier_id = tbl_supplier.id '+
                 'where year(tbl_pembelian.tgl_pembelian) = '+QuotedStr(cbbTahun.Text)+' order by tbl_pembelian.id asc';

            end;
        end;
    end;

  with dm.qryLaporanPembelian do
    begin
      close;
      SQL.Clear;
      sql.Text := query;
      Open;
    end;
end;

procedure TfLaporanPembelian.rbTanggalClick(Sender: TObject);
begin
  dtp1.Enabled := True;

  cbbTahun.Text := ''; cbbTahun.Enabled := false;
  cbbBulan.Text := ''; cbbBulan.Enabled := false;
end;

procedure TfLaporanPembelian.rbBulanClick(Sender: TObject);
begin
  dtp1.Enabled := false;

  cbbTahun.Text := ''; cbbTahun.Enabled := True;
  cbbBulan.Text := ''; cbbBulan.Enabled := True;
end;

procedure TfLaporanPembelian.cbbBulanKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;

procedure TfLaporanPembelian.cbbTahunKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;

end.
