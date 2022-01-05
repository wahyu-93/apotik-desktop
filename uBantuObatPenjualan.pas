unit uBantuObatPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids;

type
  TfBantuObatPenjualan = class(TForm)
    grp2: TGroupBox;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnPilih: TBitBtn;
    btnKeluar: TBitBtn;
    grp1: TGroupBox;
    lbl1: TLabel;
    procedure konek;
    procedure FormShow(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure btnPilihClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure dbgrd1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fBantuObatPenjualan: TfBantuObatPenjualan;

implementation

uses
  dataModule, uPenjualan;

{$R *.dfm}

procedure TfBantuObatPenjualan.konek;
begin
  with dm.qryRelasiSetHarga do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id = b.id';
      Open;
    end;
end;

procedure TfBantuObatPenjualan.FormShow(Sender: TObject);
begin
  konek;
  edtpencarian.Clear;
end;

procedure TfBantuObatPenjualan.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfBantuObatPenjualan.btnPilihClick(Sender: TObject);
begin
  if dbgrd1.Fields[2].AsString = '' then
    Fpenjualan.edtKode.Text := dbgrd1.Fields[12].AsString
  else
    Fpenjualan.edtKode.Text := dbgrd1.Fields[2].AsString;

  Fpenjualan.edtIdObat.Text := dbgrd1.Fields[1].AsString;
  Fpenjualan.edtHarga.Text := dbgrd1.Fields[4].AsString;
  Fpenjualan.btnHapus.Enabled := false;
  Fpenjualan.btnSimpan.Click;

  Close;
end;

procedure TfBantuObatPenjualan.dbgrd1DblClick(Sender: TObject);
begin
  btnPilih.Click;
end;

procedure TfBantuObatPenjualan.dbgrd1KeyPress(Sender: TObject;
  var Key: Char);
begin
  btnPilih.Click;
end;

end.
