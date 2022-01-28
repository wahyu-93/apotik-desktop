unit uForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, Grids, DBGrids, ComCtrls, StdCtrls, jpeg;

type
  TFMenu = class(TForm)
    mm1: TMainMenu;
    Master1: TMenuItem;
    Barang1: TMenuItem;
    Supplier1: TMenuItem;
    ransaksi1: TMenuItem;
    Setting1: TMenuItem;
    Keluar1: TMenuItem;
    Pembelian1: TMenuItem;
    Penjualan1: TMenuItem;
    Obat1: TMenuItem;
    Supplier2: TMenuItem;
    SettingHargaJual1: TMenuItem;
    stat1: TStatusBar;
    tmr1: TTimer;
    grp5: TGroupBox;
    lbl1: TLabel;
    img1: TImage;
    Pengguna1: TMenuItem;
    Apotik1: TMenuItem;
    tmr2: TTimer;
    Laporan1: TMenuItem;
    LaporanPembelian1: TMenuItem;
    LaporanPenjualan1: TMenuItem;
    LaporanStok1: TMenuItem;
    LaporanItemLaris1: TMenuItem;
    pnl1: TPanel;
    lblTotalPembelian: TLabel;
    lbl2: TLabel;
    pnl2: TPanel;
    lbl4: TLabel;
    lblTotalPenjualan: TLabel;
    lblJam: TLabel;
    lbl6: TLabel;
    lbl3: TLabel;
    ListPembelian2: TMenuItem;
    Pembelian2: TMenuItem;
    ListPenjualan2: TMenuItem;
    Penjualan2: TMenuItem;
    ReturPenjualan1: TMenuItem;
    ListReturPenjualan1: TMenuItem;
    ReturPenjualan2: TMenuItem;
    procedure Keluar1Click(Sender: TObject);
    procedure Barang1Click(Sender: TObject);
    procedure Supplier1Click(Sender: TObject);
    procedure Supplier2Click(Sender: TObject);
    procedure Obat1Click(Sender: TObject);
    procedure SettingHargaJual1Click(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Pengguna1Click(Sender: TObject);
    procedure Apotik1Click(Sender: TObject);
    procedure tmr2Timer(Sender: TObject);
    procedure LaporanPembelian1Click(Sender: TObject);
    procedure LaporanPenjualan1Click(Sender: TObject);
    procedure LaporanStok1Click(Sender: TObject);
    procedure LaporanItemLaris1Click(Sender: TObject);
    procedure ListPembelian2Click(Sender: TObject);
    procedure Pembelian2Click(Sender: TObject);
    procedure ListPenjualan2Click(Sender: TObject);
    procedure Penjualan2Click(Sender: TObject);
    procedure ReturPenjualan2Click(Sender: TObject);
    procedure ListReturPenjualan1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMenu: TFMenu;

implementation

uses
  uJenisObat, uSatuan, uSupplier, uObat, uPembelian, uPembayaranPembelian, 
  uPenjualan, uSetHarga, dataModule, uPengguna, uSetting, uListPenjualan, 
  uLaporanPembelian, uListJualObat, uLaporanStok, uLaporanItemTerjual, uReturn, 
  uListReturPenjualan;

{$R *.dfm}

function hari (vtgl : TDate):string;
var a : Integer;
const
  nama_hari: array[1..7] of string = ('Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'jum''at', 'Sabtu');
begin
  for a:=1 to 7 do
   begin
     LongDayNames[a] := nama_hari[a];
   end;

  Result := FormatDateTime('dddd',vtgl);
end;

procedure TFMenu.Keluar1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFMenu.Barang1Click(Sender: TObject);
begin
  fJenisObat.ShowModal;
end;

procedure TFMenu.Supplier1Click(Sender: TObject);
begin
  FSatuan.ShowModal;
end;

procedure TFMenu.Supplier2Click(Sender: TObject);
begin
  Fsupplier.Show;
end;

procedure TFMenu.Obat1Click(Sender: TObject);
begin
  Fobat.ShowModal;
end;

procedure TFMenu.SettingHargaJual1Click(Sender: TObject);
begin
  fSetHarga.ShowModal;
end;

procedure TFMenu.tmr1Timer(Sender: TObject);
begin
  FormShow(Sender);
end;

procedure TFMenu.FormShow(Sender: TObject);
begin
  stat1.Panels[0].Text := 'Pengguna : ' + dm.qryUser.FieldByName('nama').AsString;
  stat1.Panels[1].Text := 'Role : ' + dm.qryUser.fieldByname('role').AsString;

  lbl6.Caption := 'Selamat Datang '+ dm.qryUser.fieldbyname('nama').AsString+' Di Aplikasi Kasir Apotek V.1.5';
  lbl3.Caption := 'Anda Login Sebagai '+ dm.qryUser.fieldbyname('role').AsString;
  lbl1.Caption := dm.qrySetting.fieldbyname('nama_toko').AsString;


  //total penjualan
  with dm.qryTotalPenjualan do
    begin
      close;
      sql.Clear;
      sql.Text := 'select count(id) as jml_transaksi, sum(total) as total from tbl_penjualan where tgl_penjualan like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%'' and status='+QuotedStr('selesai')+'';
      Open;

      lblTotalPenjualan.Caption := 'Total Penjualan : ' + FormatFloat('Rp. ###,###,###', dm.qryTotalPenjualan.fieldbyname('total').AsFloat);
      lbl4.Caption := 'Total Penjualan (Harian) : '+dm.qryTotalPenjualan.fieldbyname('jml_transaksi').AsString+' Transaksi';
    end;


  //total pembelian
  with dm.qryTotalPembelian do
    begin
      close;
      sql.Clear;
      sql.Text := 'select count(id) as jml_transaksi, sum(total) as total from tbl_pembelian where tgl_pembelian like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%'' and status='+QuotedStr('selesai')+'';
      Open;

      lblTotalPembelian.Caption := 'Total Pembelian : ' + FormatFloat('Rp. ###,###,###', dm.qryTotalPembelian.fieldbyname('total').AsFloat);
      lbl2.Caption := 'Total Pembelian (Harian) : '+dm.qryTotalPembelian.fieldbyname('jml_transaksi').AsString +' Transaksi';
    end;


end;

procedure TFMenu.Pengguna1Click(Sender: TObject);
begin
  fPengguna.ShowModal;
end;

procedure TFMenu.Apotik1Click(Sender: TObject);
begin
  fSetting.ShowModal;
end;

procedure TFMenu.tmr2Timer(Sender: TObject);
begin
  stat1.Panels[2].Text := 'Tanggal ' + FormatDateTime('dd-mm-yyyy',Now) + ' : ' + TimeToStr(Now);
  lblJam.Caption := hari(Now)+', '+FormatDateTime('dd-mm-yyyy',Now) + #13 + TimeToStr(Now);
end;

procedure TFMenu.LaporanPembelian1Click(Sender: TObject);
begin
  fLaporanPembelian.ShowModal;
end;

procedure TFMenu.LaporanPenjualan1Click(Sender: TObject);
begin
  fLaporanPenjualan.ShowModal;
end;

procedure TFMenu.LaporanStok1Click(Sender: TObject);
begin
  fLaporanStok.ShowModal;
end;

procedure TFMenu.LaporanItemLaris1Click(Sender: TObject);
begin
  fLaporanJumlahItemTerjual.ShowModal;
end;

procedure TFMenu.ListPembelian2Click(Sender: TObject);
begin
  fPembayaranPembelian.ShowModal;
end;

procedure TFMenu.Pembelian2Click(Sender: TObject);
begin
  fPembelian.ShowModal;
end;

procedure TFMenu.ListPenjualan2Click(Sender: TObject);
begin
  fListPenjualan.ShowModal;
end;

procedure TFMenu.Penjualan2Click(Sender: TObject);
begin
  Fpenjualan.ShowModal;
end;

procedure TFMenu.ReturPenjualan2Click(Sender: TObject);
begin
  fReturn.ShowModal;  
end;

procedure TFMenu.ListReturPenjualan1Click(Sender: TObject);
begin
  fListReturPenjualan.ShowModal;
end;

end.
