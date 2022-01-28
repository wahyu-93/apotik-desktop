unit uDetailPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfDetailPembelian = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    edtFaktur: TEdit;
    dbgrd1: TDBGrid;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDetailPembelian: TfDetailPembelian;

implementation

uses
  dataModule;

{$R *.dfm}

procedure TfDetailPembelian.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfDetailPembelian.FormShow(Sender: TObject);
begin
  with dm.qryRelasiPembelian do
    begin
      close;
      sql.Clear;
      sql.Text := 'select a.id as id_pembelian, a.no_faktur, a.no_faktur_supplier, a.tgl_pembelian, a.jumlah_item, a.total, b.id as id_detail_pembelian, '+
                  'b.obat_id, b.jumlah_beli, b.harga_beli, c.kode, c.barcode, c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, e.satuan '+
                  'from tbl_pembelian a left join tbl_detail_pembelian b on b.pembelian_id = a.id left join tbl_obat c on c.id = b.obat_id left join '+
                  'tbl_jenis d on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan where a.no_faktur='+QuotedStr(edtFaktur.Text)+'';
      Open;
    end;
end;

end.
