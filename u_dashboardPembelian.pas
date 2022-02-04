unit u_dashboardPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ComCtrls, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfDashboardPembelian = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    dbgrd1: TDBGrid;
    dbgrd2: TDBGrid;
    edtpencarian: TEdit;
    edtPencarian2: TEdit;
    pnl1: TPanel;
    lblJumlah: TLabel;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pgc1Change(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPencarian2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDashboardPembelian: TfDashboardPembelian;

implementation

uses dataModule;

{$R *.dfm}

procedure konek(status:string = 'lunas');
begin
  with dm.qryListPembelian do
    begin
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_supplier left join tbl_pembelian on tbl_pembelian.supplier_id = tbl_supplier.id inner join tbl_user on tbl_user.id = tbl_pembelian.user_id '+
                  'where date(tgl_pembelian) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+' and tbl_pembelian.status = '+QuotedStr(status)+' order by tbl_pembelian.status desc, tbl_pembelian.id desc';
      Open;
    end;
end;

procedure TfDashboardPembelian.btnKeluarClick(Sender: TObject);
begin
  Close;
end;

procedure TfDashboardPembelian.FormShow(Sender: TObject);
var lunas, pending : Integer;
begin
  konek('pending');
  pending := dm.qryListPembelian.RecordCount;

  pgc1.ActivePageIndex := 0;
  konek();
  lunas := dm.qryListPembelian.RecordCount;

  lblJumlah.Caption := 'Pembelian Pending : '+IntToStr(pending) +', Pembelian Lunas : '+IntToStr(lunas);
  
  edtpencarian.Clear;
  edtPencarian2.Clear;
end;

procedure TfDashboardPembelian.pgc1Change(Sender: TObject);
begin
  if pgc1.ActivePageIndex = 0 then konek() else konek('pending');
end;

procedure TfDashboardPembelian.edtpencarianKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   with dm.qryListPembelian do
    begin
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_supplier left join tbl_pembelian on tbl_pembelian.supplier_id = tbl_supplier.id inner join tbl_user on tbl_user.id = tbl_pembelian.user_id '+
                  'where date(tgl_pembelian) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+' and tbl_pembelian.status = '+QuotedStr('lunas')+
                  ' and tbl_pembelian.no_faktur like ''%'+edtpencarian.Text+'%'' order by tbl_pembelian.status desc, tbl_pembelian.id desc';
      Open;
    end;
end;

procedure TfDashboardPembelian.edtPencarian2KeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   with dm.qryListPembelian do
    begin
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_supplier left join tbl_pembelian on tbl_pembelian.supplier_id = tbl_supplier.id inner join tbl_user on tbl_user.id = tbl_pembelian.user_id '+
                  'where date(tgl_pembelian) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+' and tbl_pembelian.status = '+QuotedStr('pending')+
                  ' and tbl_pembelian.no_faktur like ''%'+edtPencarian2.Text+'%'' order by tbl_pembelian.status desc, tbl_pembelian.id desc';
      Open;
    end;
end;

end.
