unit uPembayaranPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  TfPembayaranPembelian = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnPilih: TBitBtn;
    btnKeluar: TBitBtn;
    img1: TImage;
    btnDetail: TBitBtn;
    procedure btnKeluarClick(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnPilihClick(Sender: TObject);
    procedure btnDetailClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPembayaranPembelian: TfPembayaranPembelian;

implementation

uses
  dataModule, uFormBayarPembelian, uDetailPembelian;

{$R *.dfm}

procedure konek;
begin
  with dm.qryListPembelian do
    begin
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_supplier left join tbl_pembelian on tbl_pembelian.supplier_id = tbl_supplier.id inner join tbl_user on tbl_user.id = tbl_pembelian.user_id '+
                  'where date(tgl_pembelian) = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+' order by tbl_pembelian.id desc';
      Open;
    end;
end;

procedure TfPembayaranPembelian.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfPembayaranPembelian.edtpencarianKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  with dm.qryListPembelian do
    begin
      DisableControls;
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_supplier left join tbl_pembelian on tbl_pembelian.supplier_id = tbl_supplier.id inner join '+
                  'tbl_user on tbl_user.id = tbl_pembelian.user_id where tbl_pembelian.no_faktur like ''%'+edtpencarian.Text+'%'' order by tbl_pembelian.id desc';
      Open;
      EnableControls;
    end;
end;

procedure TfPembayaranPembelian.FormShow(Sender: TObject);
begin
  konek;
  edtpencarian.Clear;
end;

procedure TfPembayaranPembelian.btnPilihClick(Sender: TObject);
begin
  if dbgrd1.Fields[12].AsString = 'lunas' then
    begin
      MessageDlg('Status Pembelian Sudah Lunas',mtInformation,[mbOK],0);
      Exit;
    end;

  fBayarPembelian.edtIdPembelian.Text := dbgrd1.Fields[3].AsString;
  fBayarPembelian.ShowModal;
end;

procedure TfPembayaranPembelian.btnDetailClick(Sender: TObject);
begin
 if dbgrd1.Fields[0].AsString = '' then Exit;

  fDetailPembelian.edtFaktur.Text := dbgrd1.Fields[4].AsString;
  fDetailPembelian.ShowModal;
end;

procedure TfPembayaranPembelian.dbgrd1DblClick(Sender: TObject);
begin
  btnDetail.Click;
end;

end.
