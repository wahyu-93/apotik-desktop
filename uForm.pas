unit uForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, Grids, DBGrids, ComCtrls;

type
  TFMenu = class(TForm)
    mm1: TMainMenu;
    Master1: TMenuItem;
    Barang1: TMenuItem;
    Supplier1: TMenuItem;
    ransaksi1: TMenuItem;
    Laporan1: TMenuItem;
    Setting1: TMenuItem;
    Keluar1: TMenuItem;
    Pembelian1: TMenuItem;
    Penjualan1: TMenuItem;
    Obat1: TMenuItem;
    Supplier2: TMenuItem;
    dbgrd1: TDBGrid;
    dbgrd2: TDBGrid;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    SettingHargaJual1: TMenuItem;
    ListPembelian1: TMenuItem;
    stat1: TStatusBar;
    tmr1: TTimer;
    procedure Keluar1Click(Sender: TObject);
    procedure Barang1Click(Sender: TObject);
    procedure Supplier1Click(Sender: TObject);
    procedure Supplier2Click(Sender: TObject);
    procedure Obat1Click(Sender: TObject);
    procedure Pembelian1Click(Sender: TObject);
    procedure ListPembelian1Click(Sender: TObject);
    procedure Penjualan1Click(Sender: TObject);
    procedure SettingHargaJual1Click(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
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
  uPenjualan, uSetHarga, dataModule;

{$R *.dfm}

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

procedure TFMenu.Pembelian1Click(Sender: TObject);
begin
  fPembelian.ShowModal;
end;

procedure TFMenu.ListPembelian1Click(Sender: TObject);
begin
  fPembayaranPembelian.ShowModal;
end;

procedure TFMenu.Penjualan1Click(Sender: TObject);
begin
  Fpenjualan.ShowModal;
end;

procedure TFMenu.SettingHargaJual1Click(Sender: TObject);
begin
  fSetHarga.ShowModal;
end;

procedure TFMenu.tmr1Timer(Sender: TObject);
begin
  stat1.Panels[2].Text := 'Tanggal ' + FormatDateTime('dd-mm-yyyy',Now);
end;

end.
