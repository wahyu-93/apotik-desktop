unit u_dashboardPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ExtCtrls, StdCtrls, ComCtrls, Buttons, jpeg;

type
  TfDashboardPenjualan = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    pgc1: TPageControl;
    ts1: TTabSheet;
    edtpencarian: TEdit;
    ts2: TTabSheet;
    edtPencarian2: TEdit;
    pnl1: TPanel;
    lblJumlah: TLabel;
    dbgrd1: TDBGrid;
    dbgrd2: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure pgc1Change(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPencarian2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnKeluarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDashboardPenjualan: TfDashboardPenjualan;

implementation

uses dataModule;

{$R *.dfm}

procedure konek(status : string = 'selesai');
begin
  with dm.qryListPenjualan do
    begin
      close;
      sql.Clear;
      sql.Text := 'select a.id as id_pelanggan, a.jenis_pelanggan, b.id as id_penjualan, b.no_faktur, b.tgl_penjualan, '+
                  'b.jumlah_item, b.total, b.status, b.tgl_bayar, c.id as id_user, c.nama, c.role from tbl_pelanggan a left join tbl_penjualan b '+
                  'on b.id_pelanggan = a.id inner JOIN tbl_user c on c.id = b.user_id where date(tgl_penjualan) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+
                  ' and b.status like ''%'+status+'%'' order by b.id desc, b.status desc';
      Open;
    end;
end;

procedure TfDashboardPenjualan.FormShow(Sender: TObject);
var lunas, pending : Integer;
begin
  konek('pending');
  pending := dm.qryListPenjualan.RecordCount;

  pgc1.ActivePageIndex := 0;
  konek();
  lunas := dm.qryListPenjualan.RecordCount;

  lblJumlah.Caption := 'Penjualan Selesai : '+IntToStr(lunas) +', Penjualan Pending : '+IntToStr(pending);
  
  edtpencarian.Clear;
  edtPencarian2.Clear;
end;

procedure TfDashboardPenjualan.pgc1Change(Sender: TObject);
begin
  if pgc1.ActivePageIndex = 0 then konek() else konek('pending');
end;

procedure TfDashboardPenjualan.edtpencarianKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 with dm.qryListPenjualan do
    begin
      close;
      sql.Clear;
      sql.Text := 'select a.id as id_pelanggan, a.jenis_pelanggan, b.id as id_penjualan, b.no_faktur, b.tgl_penjualan, '+
                  'b.jumlah_item, b.total, b.status, b.tgl_bayar, c.id as id_user, c.nama, c.role from tbl_pelanggan a left join tbl_penjualan b '+
                  'on b.id_pelanggan = a.id inner JOIN tbl_user c on c.id = b.user_id where date(tgl_penjualan) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+
                  ' and b.status like ''%'+'selesai'+'%'' and b.no_faktur like ''%'+edtpencarian.Text+'%'' order by b.id desc, b.status desc';
      Open;
    end;
end;

procedure TfDashboardPenjualan.edtPencarian2KeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
with dm.qryListPenjualan do
    begin
      close;
      sql.Clear;
      sql.Text := 'select a.id as id_pelanggan, a.jenis_pelanggan, b.id as id_penjualan, b.no_faktur, b.tgl_penjualan, '+
                  'b.jumlah_item, b.total, b.status, b.tgl_bayar, c.id as id_user, c.nama, c.role from tbl_pelanggan a left join tbl_penjualan b '+
                  'on b.id_pelanggan = a.id inner JOIN tbl_user c on c.id = b.user_id where date(tgl_penjualan) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+
                  ' and b.status = '+QuotedStr('pending')+' and b.no_faktur like ''%'+edtpencarian2.Text+'%'' order by b.id desc, b.status desc';
      Open;
    end;
end;

procedure TfDashboardPenjualan.btnKeluarClick(Sender: TObject);
begin
  Close;
end;

end.
