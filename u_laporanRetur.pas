unit u_laporanRetur;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, ComCtrls, Buttons, jpeg;

type
  TfLaporanRetur = class(TForm)
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
    pnl1: TPanel;
    lblJumlah: TLabel;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    dbgrd1: TDBGrid;
    dbgrd2: TDBGrid;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLapClick(Sender: TObject);
    procedure cbbBulanKeyPress(Sender: TObject; var Key: Char);
    procedure rbTanggalClick(Sender: TObject);
    procedure rbBulanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLaporanRetur: TfLaporanRetur;
  jmlReturPembelian, jmlReturPenjualan : Integer;

implementation

uses
  dataModule;

{$R *.dfm}

procedure konekPembelian;
begin
   with dm.qryDashReturPembelian do
    begin
      Close;
      SQL.Clear;
      sql.Text := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keterangan='+QuotedStr('retur-pembelian')+
                  ' and date(a.tgl_retur)='+QuotedStr('kosong')+' GROUP BY a.kode order by a.id desc';
      Open;
    end;
end;

procedure konekPenjualan;
begin
  with dm.qryDashReturPenjualan do
    begin
      Close;
      SQL.Clear;
      sql.Text := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keterangan='+QuotedStr('retur-penjualan')+
                  ' and date(a.tgl_retur)='+QuotedStr('kosong')+' GROUP BY a.kode order by a.id desc';
      Open;
    end;
end;

procedure TfLaporanRetur.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfLaporanRetur.FormShow(Sender: TObject);
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
  
  konekPembelian;
  konekPenjualan;

  pgc1.Pages[0].Caption := 'Pembelian';
  pgc1.Pages[1].Caption := 'Penjualan';

  lblJumlah.Caption := '-';
end;

procedure TfLaporanRetur.btnLapClick(Sender: TObject);
var query, queryPenjualan : string;
begin
  if (rbTanggal.Checked = false) and (rbBulan.Checked = False) then
    begin
      MessageDlg('Jenis Laporan Belum Dipilih',mtInformation, [mbOK], 0);
      Exit;
    end;

  if rbTanggal.Checked = True then
    begin
      query := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keterangan='+QuotedStr('retur-pembelian')+
               ' and date(a.tgl_retur)='+QuotedStr(FormatDateTime('yyyy-mm-dd',dtp1.Date))+' GROUP BY a.kode order by a.id desc';

      queryPenjualan := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keterangan='+QuotedStr('retur-penjualan')+
                        ' and date(a.tgl_retur)='+QuotedStr(FormatDateTime('yyyy-mm-dd',dtp1.Date))+' GROUP BY a.kode order by a.id desc';
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
              query := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keterangan='+QuotedStr('retur-pembelian')+
                       ' and month(a.tgl_retur)='+QuotedStr(IntToStr(cbbBulan.ItemIndex)+'-'+cbbTahun.Text)+' GROUP BY a.kode order by a.id desc';

              queryPenjualan := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keterangan='+QuotedStr('retur-penjualan')+
                                ' and month(a.tgl_retur)='+QuotedStr(IntToStr(cbbBulan.ItemIndex)+'-'+cbbTahun.Text)+' GROUP BY a.kode order by a.id desc';
            end
          else
            begin
              query := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keterangan='+QuotedStr('retur-pembelian')+
                       ' and year(a.tgl_retur)='+QuotedStr(cbbTahun.Text)+' GROUP BY a.kode order by a.id desc';

              queryPenjualan := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keterangan='+QuotedStr('retur-penjualan')+
                                ' and year(a.tgl_retur)='+QuotedStr(cbbTahun.Text)+' GROUP BY a.kode order by a.id desc';

            end;
        end;
    end;

  with dm.qryDashReturPembelian do
    begin
      close;
      sql.Clear;
      SQL.Text := query;
      Open;

      if IsEmpty then jmlReturPembelian := 0 else jmlReturPembelian := RecordCount;
    end;

  with dm.qryDashReturPenjualan do
    begin
      close;
      SQL.Clear;
      SQL.Text := queryPenjualan;
      Open;

      if IsEmpty then jmlReturPenjualan := 0 else jmlReturPenjualan := RecordCount;
    end;

  if (jmlReturPembelian = 0) and (jmlReturPenjualan = 0) then
    begin
      MessageDlg('Data Tidak Ditemukan',mtInformation,[mbOK],0);
      FormShow(Sender);
      Exit;
    end;

  pgc1.Pages[0].Caption := 'Pembelian ('+IntToStr(dm.qryDashReturPembelian.RecordCount)+')';
  pgc1.Pages[1].Caption := 'Penjualan ('+IntToStr(dm.qryDashReturPenjualan.RecordCount)+')';

  lblJumlah.Caption := 'Jumlah Retur Pembelian : '+IntToStr(dm.qryDashReturPembelian.RecordCount)+', Jumlah Retur Penjualan : '+IntToStr(dm.qryDashReturPenjualan.RecordCount)+'';
end;

procedure TfLaporanRetur.cbbBulanKeyPress(Sender: TObject; var Key: Char);
begin
  Key:=#0;
end;

procedure TfLaporanRetur.rbTanggalClick(Sender: TObject);
begin
  dtp1.Enabled := True;

  cbbTahun.Text := ''; cbbTahun.Enabled := false;
  cbbBulan.Text := ''; cbbBulan.Enabled := false;
end;

procedure TfLaporanRetur.rbBulanClick(Sender: TObject);
begin
  dtp1.Enabled := false;

  cbbTahun.Text := ''; cbbTahun.Enabled := True;
  cbbBulan.Text := ''; cbbBulan.Enabled := True;
end;

end.
