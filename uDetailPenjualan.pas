unit uDetailPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfDetailPenjualan = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    edtFaktur: TEdit;
    dbgrd1: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDetailPenjualan: TfDetailPenjualan;

implementation

uses
  dataModule;

{$R *.dfm}

procedure TfDetailPenjualan.FormShow(Sender: TObject);
begin
  with dm.qryRelasiPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select a.id as id_penjualan, a.no_faktur, a.tgl_penjualan, a.jumlah_item, '+
                  'a.total, b.id as id_detail_penjualan, b.obat_id, b.jumlah_jual, b.harga_jual, c.kode, c.barcode, '+
                  'c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, e.satuan from tbl_penjualan a left join '+
                  'tbl_detail_penjualan b on b.penjualan_id = a.id left join tbl_obat c on c.id = b.obat_id left join tbl_jenis d '+
                  'on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan where a.no_faktur='+QuotedStr(edtFaktur.Text)+'';
      open
    end;
end;

procedure TfDetailPenjualan.btnKeluarClick(Sender: TObject);
begin
  Close;
end;

end.
