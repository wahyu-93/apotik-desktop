unit uListPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  TfListPenjualan = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnKeluar: TBitBtn;
    btnDetail: TBitBtn;
    procedure btnKeluarClick(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnDetailClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fListPenjualan: TfListPenjualan;

implementation

uses
  dataModule, uDetailPenjualan;

{$R *.dfm}

procedure konek;
begin
  with dm.qryListPenjualan do
    begin
      close;
      sql.Clear;
      sql.Text := 'select a.id as id_pelanggan, a.jenis_pelanggan, b.id as id_penjualan, b.no_faktur, b.tgl_penjualan, '+
                  'b.jumlah_item, b.total, b.status, b.tgl_bayar, c.id as id_user, c.nama, c.role from tbl_pelanggan a left join tbl_penjualan b '+
                  'on b.id_pelanggan = a.id inner JOIN tbl_user c on c.id = b.user_id where date(tgl_penjualan) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+' order by b.id asc';
      Open;
    end;
end;

procedure TfListPenjualan.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfListPenjualan.edtpencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with dm.qryListPenjualan do
    begin
      Close;
      SQL.Clear;
      sql.Text := 'select a.id as id_pelanggan, a.jenis_pelanggan, b.id as id_penjualan, b.no_faktur, b.tgl_penjualan, b.jumlah_item, '+
                  'b.total, b.status, b.tgl_bayar, c.id as id_user, c.nama, c.role from tbl_pelanggan a left join tbl_penjualan b '+
                  'on b.id_pelanggan = a.id inner JOIN tbl_user c on c.id = b.user_id where date(tgl_penjualan) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+' and b.no_faktur = '+QuotedStr(edtpencarian.Text)+' order by b.id asc';
      Open;
    end;
end;

procedure TfListPenjualan.FormShow(Sender: TObject);
begin
  konek;
  edtpencarian.Clear;
end;

procedure TfListPenjualan.btnDetailClick(Sender: TObject);
begin
  if dbgrd1.Fields[0].AsString = '' then Exit;

  fDetailPenjualan.edtFaktur.Text := dbgrd1.Fields[1].AsString;
  fDetailPenjualan.ShowModal;
end;

procedure TfListPenjualan.dbgrd1DblClick(Sender: TObject);
begin
  btnDetail.Click;
end;

end.
