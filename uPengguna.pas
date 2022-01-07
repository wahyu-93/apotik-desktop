unit uPengguna;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  TfPengguna = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    edtNama: TEdit;
    edtUsername: TEdit;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnTambah: TBitBtn;
    btnSimpan: TBitBtn;
    btnHapus: TBitBtn;
    btnKeluar: TBitBtn;
    edtPassword: TEdit;
    cbbRole: TComboBox;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnTambahClick(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
    procedure edtNamaKeyPress(Sender: TObject; var Key: Char);
    procedure edtUsernameKeyPress(Sender: TObject; var Key: Char);
    procedure edtPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure btnHapusClick(Sender: TObject);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure cbbRoleKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPengguna: TfPengguna;
  status : string;

implementation

uses
  dataModule;

{$R *.dfm}

procedure konek;
begin
  with dm.qryUser do
    begin
      close;
      sql.Clear;
      sql.Text := 'select * from tbl_user order by id';
      Open;
    end;
end;

procedure TfPengguna.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfPengguna.FormShow(Sender: TObject);
begin
  edtNama.Clear; edtNama.Enabled := false;
  edtUsername.Clear; edtUsername.Enabled := false;
  edtPassword.Clear; edtPassword.Enabled := False;
  cbbRole.Text := ''; cbbRole.Enabled := False;

  edtpencarian.Enabled := True; edtpencarian.Clear;

  btnTambah.Enabled := true; btnTambah.Caption := 'Tambah[F1]';
  btnSimpan.Enabled := false;
  btnHapus.Enabled := false;
  btnKeluar.Enabled := True;

  konek;
end;

procedure TfPengguna.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F1: btnTambah.Click;
    VK_F5: btnSimpan.Click;
    VK_F6: btnHapus.Click;
    VK_F10: btnKeluar.Click;
  end;
end;

procedure TfPengguna.edtpencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   with dm.qryUser do
    begin
      close;
      sql.Clear;
      sql.Text := 'select * from tbl_user where nama like ''%'+edtpencarian.Text+'%'' or username like ''%'+edtpencarian.Text+'%'' order by id';
      Open;
    end;
end;

procedure TfPengguna.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption = 'Tambah[F1]' then
    begin
      edtNama.Enabled := True; edtNama.SetFocus;
      edtUsername.Enabled := True;
      edtPassword.Enabled := True;
      cbbRole.Enabled := True;

      edtNama.Clear;
      edtUsername.Clear;
      edtPassword.Clear;
      cbbRole.Text := '';

      btnTambah.Caption := 'Batal[F1]';
      btnSimpan.Enabled := True; btnSimpan.Caption := 'Simpan[F5]';
      btnHapus.Enabled := False;
      btnKeluar.Enabled := True;

      edtpencarian.Enabled := False; edtpencarian.Clear;

      status := 'tambah';
    end
  else
    begin
      FormShow(Sender);
    end;
end;

procedure TfPengguna.btnSimpanClick(Sender: TObject);
begin
  if btnSimpan.Caption = 'Simpan[F5]' then
    begin
      if edtNama.Text='' then
        begin
          MessageDlg('Nama Pengguna Tidak Boleh Kosong',mtInformation,[mbOK],0);
          edtNama.SetFocus;
          Exit;
        end;

        
      if edtUsername.Text='' then
        begin
          MessageDlg('Username Tidak Boleh Kosong',mtInformation,[mbOK],0);
          edtUsername.SetFocus;
          Exit;
        end;

      
      if edtPassword.Text='' then
        begin
          MessageDlg('Password Tidak Boleh Kosong',mtInformation,[mbOK],0);
          edtPassword.SetFocus;
          Exit;
        end;

      if cbbRole.Text = '' then
        begin
          MessageDlg('Role Belum Diisi',mtInformation,[mbok],0);
          cbbRole.SetFocus;
          Exit;
        end;

      if status='tambah' then
        begin
          with dm.qryUser do
            begin
              Close;
              sql.Clear;
              sql.Text := 'select * from tbl_user where username = '+QuotedStr(edtUsername.Text)+'';
              Open;

              if IsEmpty then
                begin
                  Append;
                  FieldByName('nama').AsString := edtNama.Text;
                  FieldByName('username').AsString := edtUsername.Text;
                  FieldByName('password').AsString := edtPassword.Text;
                  FieldByName('role').AsString := cbbRole.Text;
                  Post
                end
              else
                begin
                  MessageDlg('Username Sudah Ada', mtError,[mbOK],0);
                  Exit;
                end;
            end;
        end
      else
        begin
          with dm.qryUser do
            begin
              close;
              sql.Clear;
              SQL.Text := 'update tbl_user set password = '+QuotedStr(edtPassword.Text)+', role = '+QuotedStr(cbbRole.Text)+
                          ' where username = '+QuotedStr(edtUsername.Text)+'';
              ExecSQL;
            end;
        end;

      FormShow(Sender);
      MessageDlg('Data Berhasil Disimpan',mtInformation,[mbOK],0);
    end
  else
    begin
      edtPassword.Enabled := True; edtPassword.SetFocus;
      cbbRole.Enabled := True;

      btnSimpan.Caption := 'Simpan[F5]';
      btnTambah.Caption := 'Batal[F1]';
      btnHapus.Enabled := False;

      status := 'edit';
    end;
end;

procedure TfPengguna.edtNamaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then edtUsername.SetFocus;
end;

procedure TfPengguna.edtUsernameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then edtPassword.SetFocus;
end;

procedure TfPengguna.edtPasswordKeyPress(Sender: TObject; var Key: Char);
begin
if Key=#13 then cbbRole.SetFocus;
end;

procedure TfPengguna.btnHapusClick(Sender: TObject);
begin
  if MessageDlg('Yakin User Akan Dihapus',mtConfirmation,[mbyes,mbNo],0) =mryes then
    begin
      with dm.qryUser do
        begin
          close;
          sql.Clear;
          sql.Text := 'delete from tbl_user where username = '+QuotedStr(edtUsername.Text)+'';
          ExecSQL;
        end;

      FormShow(Sender);
      MessageDlg('User Berhhasil Dihapus',mtInformation,[mbOK],0);
    end;
end;

procedure TfPengguna.dbgrd1CellClick(Column: TColumn);
begin
  edtNama.Text := dbgrd1.Fields[1].AsString;
  edtUsername.Text := dbgrd1.Fields[2].AsString;
  edtPassword.Text := dbgrd1.Fields[3].AsString;
  cbbRole.Text := dbgrd1.Fields[4].AsString;

  btnTambah.Enabled := True;
  btnSimpan.Caption := 'Edit[F5]'; btnSimpan.Enabled := True;
  btnHapus.Enabled := True
end;

procedure TfPengguna.cbbRoleKeyPress(Sender: TObject; var Key: Char);
begin
  key := #0;
end;

end.
