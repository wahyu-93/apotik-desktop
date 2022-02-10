unit u_listReturPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  TfListReturPembelian = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnKeluar: TBitBtn;
    btnDetail: TBitBtn;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnDetailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fListReturPembelian: TfListReturPembelian;

implementation

uses dataModule, uDetailReturPenjualan, u_detailReturPembelian;

{$R *.dfm}

procedure TfListReturPembelian.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfListReturPembelian.FormShow(Sender: TObject);
begin
  with dm.qryListRetur do
    begin
      Close;
      SQL.Clear;
      sql.Text := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keterangan='+QuotedStr('retur-pembelian')+
                  ' and month(a.tgl_retur)='+QuotedStr(FormatDateTime('mm-yyyy',Now()))+' GROUP BY a.kode order by a.id desc';
      Open;
    end;

  edtpencarian.Clear;
  edtpencarian.SetFocus;
end;

procedure TfListReturPembelian.edtpencarianKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  with dm.qryListRetur do
    begin
      Close;
      SQL.Clear;
      sql.Text := 'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keterangan='+QuotedStr('retur-pembelian')+
                  ' and (a.kode like ''%'+edtpencarian.Text+'%'' or a.faktur_penjualan like ''%'+edtpencarian.Text+'%'') GROUP BY a.kode';
      Open;
    end;
end;

procedure TfListReturPembelian.btnDetailClick(Sender: TObject);
begin
  if dbgrd1.Fields[0].AsString = '' then Exit;
  
  fDetailReturPembelian.edtKode.Text := dbgrd1.Fields[11].AsString;
  fDetailReturPembelian.edtFaktur.Text := dbgrd1.Fields[13].AsString;

  fDetailReturPembelian.ShowModal;
end;

end.
