unit uReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ComCtrls;

type
  TfReturn = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    edtFaktur: TEdit;
    lbl3: TLabel;
    lbl2: TLabel;
    btnCari: TBitBtn;
    dbgrd1: TDBGrid;
    edtTanggalJual: TEdit;
    btnRetualAll: TBitBtn;
    btnRetur: TBitBtn;
    btnKeluar: TBitBtn;
    lbl4: TLabel;
    dtpTanggalRetur: TDateTimePicker;
    procedure btnKeluarClick(Sender: TObject);
    procedure edtFakturKeyPress(Sender: TObject; var Key: Char);
    procedure btnCariClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fReturn: TfReturn;

implementation

uses
  dataModule;

{$R *.dfm}

procedure konek;
begin
 with dm.qryRelasiPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select a.id as id_penjualan, a.no_faktur, a.tgl_penjualan, a.jumlah_item, a.total, b.id as id_detail_penjualan, '+
                  'b.obat_id, b.jumlah_jual, b.harga_jual, c.kode, c.barcode, c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, '+
                  'e.satuan from tbl_penjualan a left join tbl_detail_penjualan b on b.penjualan_id = a.id left join tbl_obat c '+
                  'on c.id = b.obat_id left join tbl_jenis d on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan '+
                  'where a.no_faktur= '+QuotedStr('kosong')+'';
      Open;
    end;

end;

procedure TfReturn.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfReturn.edtFakturKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then btnCari.Click;
end;

procedure TfReturn.btnCariClick(Sender: TObject);
begin
  if edtFaktur.Text = '' then
    begin
      MessageDlg('No. Faktur Belum Dimasukkan',mtInformation,[mbOK],0);
      edtFaktur.SetFocus;
      Exit;
    end;

  with dm.qryRelasiPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select a.id as id_penjualan, a.no_faktur, a.tgl_penjualan, a.jumlah_item, a.total, b.id as id_detail_penjualan, '+
                  'b.obat_id, b.jumlah_jual, b.harga_jual, c.kode, c.barcode, c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, '+
                  'e.satuan from tbl_penjualan a left join tbl_detail_penjualan b on b.penjualan_id = a.id left join tbl_obat c '+
                  'on c.id = b.obat_id left join tbl_jenis d on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan '+
                  'where a.no_faktur = '+QuotedStr(edtFaktur.Text)+'';
      Open;

      if IsEmpty then
        begin
          MessageDlg('No. Faktur Tidak Ditemukan',mtInformation,[mbOK],0);
          Exit;
        end
      else
        begin
          edtTanggalJual.Text := fieldbyname('tgl_penjualan').AsString;
        end;

    end;
end;

procedure TfReturn.FormShow(Sender: TObject);
begin
  edtFaktur.Clear; edtFaktur.SetFocus;
  edtTanggalJual.Clear; edtTanggalJual.Enabled := false;
  dtpTanggalRetur.Enabled := True; dtpTanggalRetur.Date := Now;

  konek;
end;

end.
