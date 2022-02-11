unit u_labaPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, jpeg, ComCtrls;

type
  TfLabaPenjualan = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    pnl1: TPanel;
    lblJumlah: TLabel;
    rbTanggal: TRadioButton;
    rbBulan: TRadioButton;
    dtp1: TDateTimePicker;
    cbbBulan: TComboBox;
    cbbTahun: TComboBox;
    btnLap: TBitBtn;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    dbgrd1: TDBGrid;
    dbgrd2: TDBGrid;
    procedure btnKeluarClick(Sender: TObject);
    procedure btnLapClick(Sender: TObject);
    procedure cbbBulanKeyPress(Sender: TObject; var Key: Char);
    procedure rbBulanClick(Sender: TObject);
    procedure rbTanggalClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLabaPenjualan: TfLabaPenjualan;
  total : real;
  a : Integer;
  
implementation

uses
  dataModule;

{$R *.dfm}

procedure konek;
begin
  with dm.qryLabaPenjualan do
    begin
      Close;
      sql.Clear;
      SQL.Text := 'select b.kode, b.nama_obat, c.harga_beli_terakhir, a.harga_jual, sum(a.jumlah_jual) as jmlItemJual, sum(a.jumlah_jual * a.harga_jual) as total_jual, '+
               '(sum(a.harga_jual - c.harga_beli_terakhir) * a.jumlah_jual) as laba, a.jenis_harga '+
               'from tbl_penjualan z left join tbl_detail_penjualan a ON z.id = a.penjualan_id '+
               'left join tbl_obat b on a.obat_id = b.id left join tbl_satuan d on d.id = b.kode_satuan '+
               'left join tbl_harga_jual c ON c.obat_id = b.id '+
               'where date(z.tgl_penjualan)='+QuotedStr('kosong')+' AND a.jenis_harga = '+QuotedStr('eceran')+' AND COALESCE(a.status, '+QuotedStr('')+') <> '+QuotedStr('retur')+' group by a.obat_id';
      Open;
    end;
end;

procedure konekGrosir;
begin
  with dm.qryLabaPenjualanGrosir do
    begin
      Close;
      sql.Clear;
      SQL.Text := 'select b.kode, b.nama_obat, c.harga_beli_terakhir, a.harga_jual, sum(a.jumlah_jual) as jmlItemJual, sum(a.jumlah_jual * a.harga_jual) as total_jual, '+
               '(sum(a.harga_jual - c.harga_beli_terakhir) * a.jumlah_jual) as laba, a.jenis_harga '+
               'from tbl_penjualan z left join tbl_detail_penjualan a ON z.id = a.penjualan_id '+
               'left join tbl_obat b on a.obat_id = b.id left join tbl_satuan d on d.id = b.kode_satuan '+
               'left join tbl_harga_jual c ON c.obat_id = b.id '+
               'where date(z.tgl_penjualan)='+QuotedStr('kosong')+' AND a.jenis_harga = '+QuotedStr('grosir')+' AND COALESCE(a.status, '+QuotedStr('')+') <> '+QuotedStr('retur')+' group by a.obat_id';
      Open;
    end;
end;

procedure TfLabaPenjualan.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfLabaPenjualan.btnLapClick(Sender: TObject);
var query, queryGrosir : string;
    labaEceran, labaGrosir, totalLaba : Real;
begin
  if (rbTanggal.Checked = false) and (rbBulan.Checked = False) then
    begin
      MessageDlg('Jenis Laporan Belum Dipilih',mtInformation, [mbOK], 0);
      Exit;
    end;

  if rbTanggal.Checked = True then
    begin
      query := 'select b.kode, b.nama_obat, c.harga_beli_terakhir, a.harga_jual, sum(a.jumlah_jual) as jmlItemJual, sum(a.jumlah_jual * a.harga_jual) as total_jual, '+
               '(sum(a.harga_jual - c.harga_beli_terakhir) * a.jumlah_jual) as laba, a.jenis_harga '+
               'from tbl_penjualan z left join tbl_detail_penjualan a ON z.id = a.penjualan_id '+
               'left join tbl_obat b on a.obat_id = b.id left join tbl_satuan d on d.id = b.kode_satuan '+
               'left join tbl_harga_jual c ON c.obat_id = b.id '+
               'where date(z.tgl_penjualan)='+QuotedStr(FormatDateTime('yyyy-mm-dd',dtp1.Date))+' AND a.jenis_harga='+QuotedStr('eceran')+' group by a.obat_id';

      queryGrosir := 'select b.kode, b.nama_obat, c.harga_beli_terakhir, a.harga_jual, sum(a.jumlah_jual) as jmlItemJual, sum(a.jumlah_jual * a.harga_jual) as total_jual, '+
               '(sum(a.harga_jual - c.harga_beli_terakhir) * a.jumlah_jual) as laba, a.jenis_harga '+
               'from tbl_penjualan z left join tbl_detail_penjualan a ON z.id = a.penjualan_id '+
               'left join tbl_obat b on a.obat_id = b.id left join tbl_satuan d on d.id = b.kode_satuan '+
               'left join tbl_harga_jual c ON c.obat_id = b.id '+
               'where date(z.tgl_penjualan)='+QuotedStr(FormatDateTime('yyyy-mm-dd',dtp1.Date))+' AND a.jenis_harga='+QuotedStr('grosir')+' group by a.obat_id';
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
              query := 'select b.kode, b.nama_obat, c.harga_beli_terakhir, a.harga_jual, sum(a.jumlah_jual) as jmlItemJual, sum(a.jumlah_jual * a.harga_jual) as total_jual, '+
                       '(sum(a.harga_jual - c.harga_beli_terakhir) * a.jumlah_jual) as laba, a.jenis_harga '+
                       'from tbl_penjualan z left join tbl_detail_penjualan a ON z.id = a.penjualan_id '+
                       'left join tbl_obat b on a.obat_id = b.id left join tbl_satuan d on d.id = b.kode_satuan '+
                       'left join tbl_harga_jual c ON c.obat_id = b.id '+
                       'where month(z.tgl_penjualan)='+QuotedStr(IntToStr(cbbBulan.ItemIndex)+'-'+cbbTahun.Text)+' AND a.jenis_harga='+QuotedStr('eceran')+' group by a.obat_id';

             queryGrosir := 'select b.kode, b.nama_obat, c.harga_beli_terakhir, a.harga_jual, sum(a.jumlah_jual) as jmlItemJual, sum(a.jumlah_jual * a.harga_jual) as total_jual, '+
                       '(sum(a.harga_jual - c.harga_beli_terakhir) * a.jumlah_jual) as laba, a.jenis_harga '+
                       'from tbl_penjualan z left join tbl_detail_penjualan a ON z.id = a.penjualan_id '+
                       'left join tbl_obat b on a.obat_id = b.id left join tbl_satuan d on d.id = b.kode_satuan '+
                       'left join tbl_harga_jual c ON c.obat_id = b.id '+
                       'where month(z.tgl_penjualan)='+QuotedStr(IntToStr(cbbBulan.ItemIndex)+'-'+cbbTahun.Text)+' AND a.jenis_harga='+QuotedStr('grosir')+' group by a.obat_id';

            end
          else
            begin
             query := 'select b.kode, b.nama_obat, c.harga_beli_terakhir, a.harga_jual, sum(a.jumlah_jual) as jmlItemJual, sum(a.jumlah_jual * a.harga_jual) as total_jual, '+
                       '(sum(a.harga_jual - c.harga_beli_terakhir) * a.jumlah_jual) as laba, a.jenis_harga '+
                       'from tbl_penjualan z left join tbl_detail_penjualan a ON z.id = a.penjualan_id '+
                       'left join tbl_obat b on a.obat_id = b.id left join tbl_satuan d on d.id = b.kode_satuan '+
                       'left join tbl_harga_jual c ON c.obat_id = b.id '+
                       'where year(z.tgl_penjualan)='+QuotedStr(cbbTahun.Text)+' AND a.jenis_harga='+QuotedStr('eceran')+' group by a.obat_id';

             queryGrosir := 'select b.kode, b.nama_obat, c.harga_beli_terakhir, a.harga_jual, sum(a.jumlah_jual) as jmlItemJual, sum(a.jumlah_jual * a.harga_jual) as total_jual, '+
                       '(sum(a.harga_jual - c.harga_beli_terakhir) * a.jumlah_jual) as laba, a.jenis_harga '+
                       'from tbl_penjualan z left join tbl_detail_penjualan a ON z.id = a.penjualan_id '+
                       'left join tbl_obat b on a.obat_id = b.id left join tbl_satuan d on d.id = b.kode_satuan '+
                       'left join tbl_harga_jual c ON c.obat_id = b.id '+
                       'where year(z.tgl_penjualan)='+QuotedStr(cbbTahun.Text)+' AND a.jenis_harga='+QuotedStr('grosir')+' group by a.obat_id';

            end;
        end;
    end;

  with dm.qryLabaPenjualan do
    begin
      close;
      SQL.Clear;
      sql.Text := query;
      Open;

      if IsEmpty then
        begin
          labaEceran := 0;
        end
      else
        begin
          total := 0;
          for a:= 1 to RecordCount do
            begin
              RecNo := a;
              total := total + (fieldbyname('laba').AsFloat);

              Next;
            end;

          labaEceran := total;
        end;
    end;

  with dm.qryLabaPenjualanGrosir do
    begin
      close;
      SQL.Clear;
      sql.Text := queryGrosir;
      Open;

      if IsEmpty then
        begin
          labaGrosir := 0;
        end
      else
        begin
          total := 0;
          for a:= 1 to RecordCount do
            begin
              RecNo := a;
              total := total + (fieldbyname('laba').AsFloat);

              Next;
            end;

          labaGrosir := total;
        end;
    end;

  totalLaba := labaEceran + labaGrosir;

  if totalLaba <= 0 then
    begin
      MessageDlg('Data Tidak Ditemukan',mtInformation,[mbOK],0);
      Exit;
    end
  else
    begin
      lblJumlah.Caption := 'Jumlah Laba : ' + FormatFloat('Rp. ###,###,###', totalLaba);
    end;
end;

procedure TfLabaPenjualan.cbbBulanKeyPress(Sender: TObject; var Key: Char);
begin
 Key:=#0;
end;

procedure TfLabaPenjualan.rbBulanClick(Sender: TObject);
begin
  dtp1.Enabled := false;

  cbbTahun.Text := ''; cbbTahun.Enabled := True;
  cbbBulan.Text := ''; cbbBulan.Enabled := True;
end;

procedure TfLabaPenjualan.rbTanggalClick(Sender: TObject);
begin
  dtp1.Enabled := True;

  cbbTahun.Text := ''; cbbTahun.Enabled := false;
  cbbBulan.Text := ''; cbbBulan.Enabled := false;
end;

procedure TfLabaPenjualan.FormShow(Sender: TObject);
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
  konekGrosir;

  lblJumlah.Caption := '-';
end;

end.
