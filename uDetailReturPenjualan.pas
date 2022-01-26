unit uDetailReturPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfDetailReturPenjualan = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    edtKode: TEdit;
    dbgrd1: TDBGrid;
    lbl6: TLabel;
    edtFaktur: TEdit;
    lbl2: TLabel;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDetailReturPenjualan: TfDetailReturPenjualan;

implementation

uses
  dataModule;

{$R *.dfm}

procedure TfDetailReturPenjualan.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfDetailReturPenjualan.FormShow(Sender: TObject);
begin
  with dm.qryDetailRetur do
    begin
      close;
      sql.Clear;
      sql.Text := 'select * from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan INNER JOIN tbl_obat c ON c.id = b.obat_id '+
                  'where b.keterangan = '+QuotedStr('retur-penjualan')+' and a.kode = '+QuotedStr(edtKode.Text)+'';
      Open;
    end;
end;

end.
