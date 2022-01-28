unit u_bayarPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, jpeg, ExtCtrls;

type
  TfBayarPenjualan = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    edtIdPenjualan: TEdit;
    grp2: TGroupBox;
    lbl4: TLabel;
    lbl2: TLabel;
    btnKeluar: TBitBtn;
    btnBayar: TBitBtn;
    dtpTglBayar: TDateTimePicker;
    rbLunas: TRadioButton;
    rbPending: TRadioButton;
    lbl3: TLabel;
    lblTotalDibayar: TLabel;
    bvl1: TBevel;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnBayarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fBayarPenjualan: TfBayarPenjualan;

implementation

uses
  dataModule, uListPenjualan;

{$R *.dfm}

procedure TfBayarPenjualan.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfBayarPenjualan.FormShow(Sender: TObject);
begin
  rbPending.Checked := True;
  dtpTglBayar.Date := Now;
end;

procedure TfBayarPenjualan.btnBayarClick(Sender: TObject);
begin
if (rbLunas.Checked = False) and (rbPending.Checked = False) then
    begin
      MessageDlg('Status Pembayaran Belum Dipilih',mtInformation,[mbOK],0);
      Exit;
    end;

  // update tgl bayar dan status
  if rbLunas.Checked = True then
    begin
      with dm.qryPenjualan do
        begin
          close;
          sql.Clear;
          SQL.Text := 'update tbl_penjualan set tgl_bayar = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+
                      ', status='+QuotedStr('selesai')+' where id = '+QuotedStr(edtIdPenjualan.Text)+'';
          ExecSQL;
        end;
    end;

    MessageDlg('Status Pembayaran Berhasil Diubah', mtInformation,[mbok],0);
    fListPenjualan.FormShow(Sender);
    close;
end;

end.
