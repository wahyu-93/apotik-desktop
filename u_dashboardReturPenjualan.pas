unit u_dashboardReturPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, ComCtrls, Buttons, jpeg;

type
  TfDashboardReturPenjualan = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    pnl1: TPanel;
    lblJumlah: TLabel;
    edtPencarian2: TEdit;
    dbgrd1: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure edtPencarian2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnKeluarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDashboardReturPenjualan: TfDashboardReturPenjualan;

implementation

uses
  dataModule;

{$R *.dfm}

procedure TfDashboardReturPenjualan.FormShow(Sender: TObject);
begin
  with dm.qryListDashReturPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE '+
                  'b.keterangan='+QuotedStr('retur-penjualan')+' and a.tgl_retur like ''%'+FormatDateTime('yyyy-mm-dd',Now())+'%'' GROUP BY a.kode';
      Open;

      lblJumlah.Caption := 'Jumlah Retur Penjualan : ' + IntToStr(RecordCount);
    end;

  edtPencarian2.Clear;
  edtPencarian2.SetFocus;
end;

procedure TfDashboardReturPenjualan.edtPencarian2KeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  with dm.qryListDashReturPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE '+
                  'b.keterangan='+QuotedStr('retur-penjualan')+' and a.tgl_retur like ''%'+FormatDateTime('yyyy-mm-dd',Now())+'%'' and (a.kode like ''%'+edtPencarian2.Text+'%'' or a.faktur_penjualan like ''%'+edtPencarian2.Text+'%'') GROUP BY a.kode';
      Open;
    end;
end;

procedure TfDashboardReturPenjualan.btnKeluarClick(Sender: TObject);
begin
  close;
end;

end.
