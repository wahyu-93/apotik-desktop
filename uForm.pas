unit uForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus;

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
    procedure Keluar1Click(Sender: TObject);
    procedure Barang1Click(Sender: TObject);
    procedure Supplier1Click(Sender: TObject);
    procedure Supplier2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMenu: TFMenu;

implementation

uses
  uJenisObat, uSatuan, uSupplier;

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

end.
