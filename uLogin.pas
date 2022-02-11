unit uLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfLogin = class(TForm)
    img1: TImage;
    edtUsername: TEdit;
    edtPass: TEdit;
    btnLogin: TBitBtn;
    btnKeluar: TBitBtn;
    lbl2: TLabel;
    lbl3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure edtPassKeyPress(Sender: TObject; var Key: Char);
    procedure edtUsernameKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLogin: TfLogin;

implementation

uses
  dataModule, uForm, uMenuKasir;

{$R *.dfm}

procedure TfLogin.FormShow(Sender: TObject);
begin
  edtUsername.Clear; edtUsername.SetFocus;
  edtPass.Clear;
end;

procedure TfLogin.btnKeluarClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfLogin.btnLoginClick(Sender: TObject);
begin
  if edtUsername.Text = '' then
    begin
      MessageDlg('Username Belum Diisi',mtInformation,[mbok],0);
      edtUsername.SetFocus;
      Exit;
    end;

  if edtPass.Text = '' then
    begin
      MessageDlg('Passwo Belum Dimasukkan',mtInformation,[mbOK],0);
      edtPass.SetFocus;
      Exit;
    end;

  with dm.qryUser do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_user where username = '+QuotedStr(edtUsername.Text)+' and password = '+QuotedStr(edtPass.Text)+'';
      Open;

      if IsEmpty then
        begin
          MessageDlg('Username Atau Password Yang Anda Masukkan Salah',mtError,[mbOK],0);
          Exit;
        end
      else
        begin
          if FieldByName('role').AsString = 'Admin' then
            FMenu.ShowModal
          else
            fMenuKasir.ShowModal;
        end;
    end;
end;

procedure TfLogin.edtPassKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then btnLogin.Click;
end;

procedure TfLogin.edtUsernameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then edtPass.SetFocus;
end;

end.
