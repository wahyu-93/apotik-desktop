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
    qryRelasiPembelianid: TAutoIncField;
    qryRelasiPembelianno_faktur: TStringField;
    qryRelasiPembeliantgl_pembelian: TDateField;
    qryRelasiPembelianjumlah_item: TIntegerField;
    qryRelasiPembeliantotal: TFloatField;
    qryRelasiPembelianobat_id: TIntegerField;
    qryRelasiPembelianjumlah_beli: TIntegerField;
    qryRelasiPembelianharga_beli: TFloatField;
    qryRelasiPembeliankode: TStringField;
    qryRelasiPembelianbarcode: TStringField;
    qryRelasiPembeliannama_obat: TStringField;
    qryRelasiPembelianjenis: TStringField;
    qryRelasiPembeliansatuan: TStringField;
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
