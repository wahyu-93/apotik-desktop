unit uPembayaranPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls, ComCtrls;

type
  TfPembayaranPembelian = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    img1: TImage;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    edtpencarian2: TEdit;
    dbgrd2: TDBGrid;
    btnDetail: TBitBtn;
    btnKeluar: TBitBtn;
    btnBayar2: TBitBtn;
    btnKeluar2: TBitBtn;
    btnDetail2: TBitBtn;
    btn1: TBitBtn;
    procedure btnKeluarClick(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnDetailClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure edtpencarian2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnKeluar2Click(Sender: TObject);
    procedure btnDetail2Click(Sender: TObject);
    procedure btnBayar2Click(Sender: TObject);
    procedure dbgrd2DblClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
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
                  'where month(tgl_pembelian) = '+QuotedStr(FormatDateTime('mm-yyyy',Now))+' and tbl_pembelian.status = '+QuotedStr('lunas')+' order by tbl_pembelian.id desc';
      Open;
    end;
end;

procedure konekPending;
begin
  with dm.qryListPembelianPending do
    begin
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_supplier left join tbl_pembelian on tbl_pembelian.supplier_id = tbl_supplier.id inner join tbl_user on tbl_user.id = tbl_pembelian.user_id '+
                  'where month(tgl_pembelian) = '+QuotedStr(FormatDateTime('mm-yyyy',Now))+' and tbl_pembelian.status = '+QuotedStr('pending')+' order by tbl_pembelian.id desc';
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
  if edtpencarian.Text='' then konek;

  with dm.qryListPembelian do
    begin
      DisableControls;
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_supplier left join tbl_pembelian on tbl_pembelian.supplier_id = tbl_supplier.id inner join '+
                  'tbl_user on tbl_user.id = tbl_pembelian.user_id where tbl_pembelian.no_faktur like ''%'+edtpencarian.Text+'%'' and tbl_pembelian.status = '+QuotedStr('lunas')+' order by tbl_pembelian.id desc';
      Open;
      EnableControls;
    end;
end;

procedure TfPembayaranPembelian.FormShow(Sender: TObject);
begin
  konek;
  edtpencarian.Clear;

  konekPending;
  edtpencarian2.Clear;
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

procedure TfPembayaranPembelian.edtpencarian2KeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if edtpencarian2.Text='' then konekPending;
  
  with dm.qryListPembelianPending do
    begin
      DisableControls;
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_supplier left join tbl_pembelian on tbl_pembelian.supplier_id = tbl_supplier.id inner join '+
                  'tbl_user on tbl_user.id = tbl_pembelian.user_id where tbl_pembelian.no_faktur like ''%'+edtpencarian.Text+'%'' and tbl_pembelian.status = '+QuotedStr('pending')+' order by tbl_pembelian.id desc';
      Open;
      EnableControls;
    end;
end;

procedure TfPembayaranPembelian.btnKeluar2Click(Sender: TObject);
begin
  close;
end;

procedure TfPembayaranPembelian.btnDetail2Click(Sender: TObject);
begin
  if dbgrd2.Fields[0].AsString = '' then Exit;

  fDetailPembelian.edtFaktur.Text := dbgrd2.Fields[4].AsString;
  fDetailPembelian.ShowModal;
end;

procedure TfPembayaranPembelian.btnBayar2Click(Sender: TObject);
begin
  if dbgrd2.Fields[0].AsString = '' then Exit;

  if dbgrd2.Fields[12].AsString = 'lunas' then
    begin
      MessageDlg('Status Pembelian Sudah Lunas',mtInformation,[mbOK],0);
      Exit;
    end;

  fBayarPembelian.edtIdPembelian.Text := dbgrd2.Fields[3].AsString;
  fBayarPembelian.ShowModal;
end;

procedure TfPembayaranPembelian.dbgrd2DblClick(Sender: TObject);
begin
  btnDetail2.Click;
end;

function hitungItem(id_pembelian : string) : Integer;
begin
  with dm.qryDetailPembelian do
    begin
      close;
      SQL.Clear;
      SQL.Text := 'select * from tbL_detail_pembelian where pembelian_id = '+QuotedStr(id_pembelian)+'';
      Open;

      Result := RecordCount;
    end;
end;

function hitungTotal(id_pembelian : string) : Real;
var
  i : Integer;
  total : Real;
begin
  with dm.qryDetailPembelian do
    begin
      close;
      SQL.Clear;
      SQL.Text := 'select * from tbL_detail_pembelian where pembelian_id = '+QuotedStr(id_pembelian)+'';
      Open;

      total := 0;
      for i:=1 to RecordCount do
        begin
          RecNo := i;
          total := total + (fieldbyname('jumlah_beli').AsInteger * fieldbyname('harga_beli').AsInteger);

          Next;
        end;

      Result := total;
    end;
end;

procedure TfPembayaranPembelian.btn1Click(Sender: TObject);
var
  jumlahItem, total, id_pembelian : string;
  a : integer;
begin
  if MessageDlg('Apakah Total Bayar Akan Di Perbaiki ?',mtConfirmation,[mbYes,mbno],0)=mryes then
    begin
      id_pembelian := dbgrd2.Fields[3].AsString;

      jumlahItem := IntToStr(hitungItem(id_pembelian));
      total := FloatToStr(hitungTotal(id_pembelian));

      with dm.qryPembelian do
        begin
          close;
          sql.Clear;
          sql.Text := 'update tbl_pembelian set jumlah_item = '+QuotedStr(jumlahItem)+', total = '+QuotedStr(total)+' where id = '+QuotedStr(id_pembelian)+'';
          ExecSQL;
        end;

      MessageDlg('Total Bayar Berhasil Diperbaiki', mtInformation,[mbok],0);
      FormShow(Sender);
    end;
end;

end.
