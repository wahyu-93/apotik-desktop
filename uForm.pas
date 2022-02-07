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
    RefreshDashboard1: TMenuItem;
    N1: TMenuItem;
    LabaPenjualan1: TMenuItem;
    pnl3: TPanel;
    pnl4: TPanel;
    pnl7: TPanel;
    lbl8: TLabel;
    lblTotalReturPembelian: TLabel;
    pnl8: TPanel;
    pnl9: TPanel;
    pnl10: TPanel;
    lbl10: TLabel;
    lblTtlReturPenjualan: TLabel;
    pnl11: TPanel;
    lbl12: TLabel;
    lblTtlObat: TLabel;
    pnl12: TPanel;
    pnl5: TPanel;
    lblTtlSupplier: TLabel;
    lbl7: TLabel;
    pnl6: TPanel;
    pnl17: TPanel;
    pnl18: TPanel;
    lbl18: TLabel;
    lblTtlStok: TLabel;
    pnl19: TPanel;
    lbl20: TLabel;
    lblTtlExp: TLabel;
    pnl20: TPanel;
    ReturPembelian1: TMenuItem;
    ListReturPembelian1: TMenuItem;
    ReturPembelian2: TMenuItem;
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
    procedure RefreshDashboard1Click(Sender: TObject);
    procedure LabaPenjualan1Click(Sender: TObject);
    procedure lblTotalPembelianClick(Sender: TObject);
    procedure lblTotalPenjualanClick(Sender: TObject);
    procedure lblTtlSupplierClick(Sender: TObject);
    procedure lblTtlObatClick(Sender: TObject);
    procedure lblTtlStokClick(Sender: TObject);
    procedure lblTtlExpClick(Sender: TObject);
    procedure lblTtlReturPenjualanClick(Sender: TObject);
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
  uListReturPenjualan, u_labaPenjualan, DB, u_dashboardPembelian, 
  u_dashboardPenjualan, u_dashboardSupplier, u_dashboardObat, 
  u_dashboardObatStok, u_dashboardExp, u_dashboardReturPenjualan;

{$R *.dfm}

function hari (vtgl : TDate):string;
var a : Integer;
const
  nama_hari: array[1..7] of string = ('Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jum''at', 'Sabtu');
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
      sql.Text := 'select count(id) as jml_transaksi from tbl_penjualan where tgl_penjualan like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%''';
      Open;

     if FieldByName('jml_transaksi').AsInteger > 0 then
      begin
          lblTotalPenjualan.Caption := FormatFloat('###,###;(###,###);###,###', dm.qryTotalPenjualan.fieldbyname('jml_transaksi').AsFloat);
      end
     else
      begin
        lblTotalPenjualan.Caption := '0';
      end;
    end;

  //total pembelian
  with dm.qryTotalPembelian do
    begin
      close;
      sql.Clear;
      sql.Text := 'select count(id) as jml_transaksifrom from tbl_pembelian where tgl_pembelian like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%''';
      Open;

      if FieldByName('jml_transaksifrom').AsInteger > 0 then
        begin
          lblTotalPembelian.Caption := FormatFloat('###,###;(###,###);###,###', dm.qryTotalPembelian.fieldbyname('jml_transaksifrom').AsFloat);
        end
      else
        begin
          lblTotalPembelian.Caption := '0';
        end;
    end;

  //alert stok
  with dm.qryDashObat do
    begin
      Close;
      sql.Clear;
      SQL.Text := 'select count(id) as jumlah from tbl_obat where stok < 5';
      Open;

      if FieldByName('jumlah').AsInteger = 0 then
        begin
          lblTtlStok.Caption := '0';
        end
      else
        begin
          lblTtlStok.Caption := fieldbyname('jumlah').AsString;
        end;
    end;

    //alert exp
    with dm.qryDashExp do
      begin
        close;
        sql.Clear;
        sql.Text := 'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id = b.id where (DATEDIFF(b.tgl_exp,now())) < 100 ';
        Open;

        if IsEmpty then
          begin
            lblTtlExp.Caption := '0';
          end
        else
          begin
           lblTtlExp.Caption := IntToStr(RecordCount);
          end;
      end;

    // dashboard ttl obat
    with dm.qryDashhObat do
      begin
        close;
        SQL.Clear;
        SQL.Text := 'select count(id) as jumlah from tbl_obat';
        Open;

        if FieldByName('jumlah').AsInteger > 0 then
          begin
            lblTtlObat.Caption := fieldbyname('jumlah').AsString;
          end
        else
          begin
            lblTtlObat.Caption := '0';
          end;
      end;

    // dashboard supplier
    with dm.qryDashSupplier do
      begin
        Close;
        sql.Clear;
        SQL.Text := 'select count(id) as jumlah from tbl_supplier';
        Open;

        if FieldByName('jumlah').AsInteger > 0 then
          begin
            lblTtlSupplier.Caption := fieldbyname('jumlah').AsString;
          end
        else
          begin
            lblTtlSupplier.Caption := '0';
          end;
      end;

    // dashboard retur penjualan
    with dm.qryDashReturPenjualan do
      begin
        close;
        sql.Clear;
        SQL.Text := 'select count(id) as jumlah from tbl_retur where tgl_retur like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%'' and jenis_retur = '+QuotedStr('penjualan')+'';
        Open;

        if FieldByName('jumlah').AsInteger > 0then
          begin
             lblTtlReturPenjualan.Caption :=  fieldbyname('jumlah').AsString;
          end
        else
          begin
            lblTtlReturPenjualan.Caption := '0';
          end;
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
  lblJam.Caption := hari(Now)+', '+FormatDateTime('dd-mm-yyyy',Now) + ' - ' + TimeToStr(Now);
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

procedure TFMenu.RefreshDashboard1Click(Sender: TObject);
begin
  FormShow(Sender);
end;

procedure TFMenu.LabaPenjualan1Click(Sender: TObject);
begin
  fLabaPenjualan.ShowModal;
end;

procedure TFMenu.lblTotalPembelianClick(Sender: TObject);
begin
  fDashboardPembelian.ShowModal;
end;

procedure TFMenu.lblTotalPenjualanClick(Sender: TObject);
begin
  fDashboardPenjualan.ShowModal;
end;

procedure TFMenu.lblTtlSupplierClick(Sender: TObject);
begin
  fDashboardSupplier.ShowModal;
end;

procedure TFMenu.lblTtlObatClick(Sender: TObject);
begin
  fDashboardObat.ShowModal;
end;

procedure TFMenu.lblTtlStokClick(Sender: TObject);
begin
  fDashboardObatStok.ShowModal;
end;

procedure TFMenu.lblTtlExpClick(Sender: TObject);
begin
  fDashboardExp.ShowModal;
end;

procedure TFMenu.lblTtlReturPenjualanClick(Sender: TObject);
begin
  fDashboardReturPenjualan.ShowModal;
end;

end.
