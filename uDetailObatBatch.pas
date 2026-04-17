unit uDetailObatBatch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, jpeg;

type
  TFDetailObatBatch = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lblDetailBatch: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    dbgrd1: TDBGrid;
    pnl3: TPanel;
    lbl3: TLabel;
    lblTotalHPP: TLabel;
    pnl2: TPanel;
    lbl2: TLabel;
    lblTotalPendapatan: TLabel;
    pnl4: TPanel;
    lbl4: TLabel;
    lblTotalLaba: TLabel;
    lblKodeObat: TLabel;
    lblHargaJual: TLabel;
    lblJumlahTerjual: TLabel;
    lbl1: TLabel;
    procedure btnKeluarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDetailObatBatch: TFDetailObatBatch;

implementation

uses
  dataModule;

{$R *.dfm}

procedure TFDetailObatBatch.btnKeluarClick(Sender: TObject);
begin
  close;
end;

end.
