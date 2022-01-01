unit dataModule;

interface

uses
  SysUtils, Classes, XPMan, DB, ADODB;

type
  Tdm = class(TDataModule)
    XPManifest1: TXPManifest;
    con1: TADOConnection;
    qryBarang: TADOQuery;
    dsBarang: TDataSource;
    dsJenis: TDataSource;
    qryJenis: TADOQuery;
    qryJenisid: TAutoIncField;
    qryJeniskode: TStringField;
    qryJenisjenis: TStringField;
    qryJenisketerangan: TMemoField;
    dsSatuan: TDataSource;
    qrySatuan: TADOQuery;
    qrySatuanid: TAutoIncField;
    qrySatuankode: TStringField;
    qrySatuansatuan: TStringField;
    qrySupplier: TADOQuery;
    dsSupplier: TDataSource;
    qrySupplierid: TAutoIncField;
    qrySupplierkode: TStringField;
    qrySuppliernama_supplier: TStringField;
    qrySupplieralamat_supplier: TMemoField;
    qrySuppliertelp_suplier: TStringField;
    qryObat: TADOQuery;
    dsObat: TDataSource;
    qryObatRelasi: TADOQuery;
    qryPembelian: TADOQuery;
    qryDetailPembelian: TADOQuery;
    qryRelasiPembelian: TADOQuery;
    dsRelasiPembelian: TDataSource;
    qryRelasiPembelianid_pembelian: TAutoIncField;
    qryRelasiPembelianno_faktur: TStringField;
    qryRelasiPembeliantgl_pembelian: TDateField;
    qryRelasiPembelianjumlah_item: TIntegerField;
    qryRelasiPembeliantotal: TFloatField;
    qryRelasiPembelianid_detail_pembelian: TAutoIncField;
    qryRelasiPembelianobat_id: TIntegerField;
    qryRelasiPembelianjumlah_beli: TIntegerField;
    qryRelasiPembelianharga_beli: TFloatField;
    qryRelasiPembeliankode: TStringField;
    qryRelasiPembelianbarcode: TStringField;
    qryRelasiPembeliannama_obat: TStringField;
    qryRelasiPembeliantgl_obat: TDateField;
    qryRelasiPembeliantgl_exp: TDateField;
    qryRelasiPembelianjenis: TStringField;
    qryRelasiPembeliansatuan: TStringField;
    qryObatid: TAutoIncField;
    qryObatkode: TStringField;
    qryObatbarcode: TStringField;
    qryObatnama_obat: TStringField;
    qryObatkode_jenis: TIntegerField;
    qryObatkode_satuan: TIntegerField;
    qryObattgl_obat: TDateField;
    qryObattgl_exp: TDateField;
    qryObatstatus: TStringField;
    qryObatRelasiid: TIntegerField;
    qryObatRelasikodeObat: TStringField;
    qryObatRelasibarcode: TStringField;
    qryObatRelasinama_obat: TStringField;
    qryObatRelasikode_jenis: TIntegerField;
    qryObatRelasikode_satuan: TIntegerField;
    qryObatRelasiid_jenis: TIntegerField;
    qryObatRelasijenisKode: TStringField;
    qryObatRelasijenis: TStringField;
    qryObatRelasiid_satuan: TIntegerField;
    qryObatRelasisatuanKode: TStringField;
    qryObatRelasisatuan: TStringField;
    qryListPembelian: TADOQuery;
    dsListPembelian: TDataSource;
    qryListPembelianid: TIntegerField;
    qryListPembeliankode: TStringField;
    qryListPembeliannama_supplier: TStringField;
    qryListPembelianalamat_supplier: TMemoField;
    qryListPembeliantelp_suplier: TStringField;
    qryListPembelianid_1: TIntegerField;
    qryListPembelianno_faktur: TStringField;
    qryListPembeliantgl_pembelian: TDateField;
    qryListPembeliansupplier_id: TIntegerField;
    qryListPembelianjumlah_item: TIntegerField;
    qryListPembeliantotal: TFloatField;
    qryListPembelianuser_id: TIntegerField;
    qryListPembelianstatus: TStringField;
    qryListPembeliantgl_pembayaran: TDateField;
    qryListPembelianid_2: TIntegerField;
    qryListPembeliannama: TStringField;
    qryListPembelianusername: TStringField;
    qryListPembelianpassword: TStringField;
    qryListPembelianrole: TStringField;
    procedure qryJenisketeranganGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure qrySupplieralamat_supplierGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{$R *.dfm}

procedure Tdm.qryJenisketeranganGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  Text:= TField(Sender).AsString;
end;

procedure Tdm.qrySupplieralamat_supplierGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text:= TField(Sender).AsString;
end;

end.
