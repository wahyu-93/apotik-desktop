unit u_dashboardExp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, jpeg;

type
  TfDashboardExp = class(TForm)
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
  fDashboardExp: TfDashboardExp;

implementation

uses
  dataModule;

{$R *.dfm}

procedure konek;
begin
  with dm.qryDashListExp do
    begin
      close;
      sql.Clear;
      sql.Text := 'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id = b.id where (DATEDIFF(b.tgl_exp,now())) < 100 order by b.tgl_exp asc';
      Open;
    end;
end;

procedure TfDashboardExp.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfDashboardExp.FormShow(Sender: TObject);
begin
  konek;
  lblJumlah.Caption := 'Jumlah Obat : '+IntToStr(dm.qryDashListExp.RecordCount);

  edtPencarian.Clear;
  edtPencarian.SetFocus;
end;

procedure TfDashboardExp.edtPencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with dm.qryDashListExp do
    begin
      close;
      sql.Clear;
      sql.Text := 'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id = b.id where (DATEDIFF(b.tgl_exp,now())) < 100 and b.nama_obat like ''%'+edtPencarian.Text+'%'' order by b.tgl_exp asc';
      Open;
    end;
end;

end.
