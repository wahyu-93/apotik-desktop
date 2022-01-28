unit uMenuKasir;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ExtCtrls, ComCtrls, jpeg;

type
  TfMenuKasir = class(TForm)
    img1: TImage;
    stat1: TStatusBar;
    tmr1: TTimer;
    mm1: TMainMenu;
    ransaksi1: TMenuItem;
    Penjualan1: TMenuItem;
    Keluar1: TMenuItem;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure Penjualan1Click(Sender: TObject);
    procedure Keluar1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMenuKasir: TfMenuKasir;

implementation

uses
  dataModule, uPenjualan;

{$R *.dfm}

procedure TfMenuKasir.FormShow(Sender: TObject);
begin
  lbl1.Caption := 'Selamat Datang '+ dm.qryUser.fieldbyname('nama').AsString+' Di Aplikasi Kasir Apotek V.1.5';
  lbl2.Caption := 'Anda Login Sebagai '+ dm.qryUser.fieldbyname('role').AsString;

  stat1.Panels[0].Text := 'Pengguna : ' + dm.qryUser.FieldByName('nama').AsString;
  stat1.Panels[1].Text := 'Role : ' + dm.qryUser.fieldByname('role').AsString;
end;

procedure TfMenuKasir.tmr1Timer(Sender: TObject);
begin
  lbl3.Caption := 'Tanggal '+ FormatDateTime('dd-mm-yyyy',now)+ ' : ' +TimeToStr(Now)
end;

procedure TfMenuKasir.Penjualan1Click(Sender: TObject);
begin
  Fpenjualan.ShowModal;
end;

procedure TfMenuKasir.Keluar1Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
