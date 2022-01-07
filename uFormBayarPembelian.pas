unit uFormBayarPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, jpeg, ExtCtrls;

type
  TfBayarPembelian = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    lbl4: TLabel;
    btnKeluar: TBitBtn;
    btnBayar: TBitBtn;
    dtpTglBayar: TDateTimePicker;
    lbl2: TLabel;
    rbLunas: TRadioButton;
    rbPending: TRadioButton;
    edtIdPembelian: TEdit;
    img1: TImage;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnBayarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fBayarPembelian: TfBayarPembelian;

implementation

uses
  dataModule, uPembayaranPembelian;

{$R *.dfm}

procedure TfBayarPembelian.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfBayarPembelian.FormShow(Sender: TObject);
begin
  dtpTglBayar.Date := Now;
  rbLunas.Checked := false;
  rbPending.Checked := True;
end;

procedure TfBayarPembelian.btnBayarClick(Sender: TObject);
begin
  if (rbLunas.Checked = False) and (rbPending.Checked = False) then
    begin
      MessageDlg('Status Pembayaran Belum Dipilih',mtInformation,[mbOK],0);
      Exit;
    end;

  // update tgl bayar dan status
  if rbLunas.Checked = True then
    begin
      with dm.qryPembelian do
        begin
          close;
          sql.Clear;
          SQL.Text := 'update tbl_pembelian set tgl_pembayaran = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+
                      ', status='+QuotedStr('lunas')+' where id = '+QuotedStr(edtIdPembelian.Text)+'';
          ExecSQL;
        end;
    end;

    MessageDlg('Status Pembayaran Berhasil Diubah', mtInformation,[mbok],0);
    fPembayaranPembelian.FormShow(Sender);
    close;
end;

procedure TfBayarPembelian.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
    VK_F9: btnBayar.Click;
    VK_F10 : btnKeluar.Click;
  end;
end;

end.
