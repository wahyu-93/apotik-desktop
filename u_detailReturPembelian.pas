unit u_detailReturPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfDetailReturPembelian = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    lbl6: TLabel;
    lbl2: TLabel;
    btnKeluar: TBitBtn;
    edtKode: TEdit;
    dbgrd1: TDBGrid;
    edtFaktur: TEdit;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDetailReturPembelian: TfDetailReturPembelian;

implementation

uses dataModule;

{$R *.dfm}

procedure TfDetailReturPembelian.btnKeluarClick(Sender: TObject);
begin
 close;
end;

procedure TfDetailReturPembelian.FormShow(Sender: TObject);
begin
  with dm.qryDetailRetur do
    begin
      close;
      sql.Clear;
      sql.Text := 'select * from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan INNER JOIN tbl_obat c ON c.id = b.obat_id '+
                  'where b.keterangan = '+QuotedStr('retur-pembelian')+' and a.kode = '+QuotedStr(edtKode.Text)+'';
      Open;
    end;
end;

end.
