unit uBantuObatPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  TfBantuObatPenjualan = class(TForm)
    grp2: TGroupBox;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnPilih: TBitBtn;
    btnKeluar: TBitBtn;
    grp1: TGroupBox;
    lbl1: TLabel;
    img1: TImage;
    procedure konek;
    procedure FormShow(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure btnPilihClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure dbgrd1KeyPress(Sender: TObject; var Key: Char);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
  if dbgrd1.Fields[1].AsString = '' then Exit;

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

procedure TfBantuObatPenjualan.edtpencarianKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  with dm.qryRelasiSetHarga do
    begin
      close;
      SQL.Clear;
      SQL.Text := 'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id = b.id where b.nama_obat like ''%'+edtpencarian.Text+'%''';
      Open;
    end;
end;

end.
