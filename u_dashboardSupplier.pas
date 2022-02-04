unit u_dashboardSupplier;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, jpeg;

type
  TfDashboardSupplier = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    pnl1: TPanel;
    lblJumlah: TLabel;
    edtPencarian: TEdit;
    dbgrd1: TDBGrid;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtPencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDashboardSupplier: TfDashboardSupplier;

implementation

uses
  dataModule;

{$R *.dfm}

procedure TfDashboardSupplier.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfDashboardSupplier.FormShow(Sender: TObject);
begin
  with dm.qrySupplier do
    begin
      close;
      SQL.Clear;
      SQL.Text := 'select * from tbl_supplier order by kode';
      Open;
    end;

  lblJumlah.Caption := 'Jumlah Supplier : '+IntToStr(dm.qrySupplier.RecordCount);
  edtPencarian.Clear; edtPencarian.SetFocus;
end;

procedure TfDashboardSupplier.edtPencarianKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  with dm.qrySupplier do
    begin
      close;
      SQL.Clear;
      SQL.Text := 'select * from tbl_supplier where nama_supplier like ''%'+edtPencarian.Text+'%''';
      Open;
    end;
end;

end.
