unit uBackup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls, ShellAPI;

type
  Tfbackup = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    lbl3: TLabel;
    edtPath: TEdit;
    dlgSave1: TSaveDialog;
    btnBackup: TBitBtn;
    procedure btnKeluarClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fbackup: Tfbackup;

implementation

{$R *.dfm}

procedure Tfbackup.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure Tfbackup.btnBackupClick(Sender: TObject);
var
   user, pass, database, dir :String;
begin
  dlgSave1.FileName := 'Backup'+FormatDateTime('ddmmyy',now);
  if dlgSave1.Execute then
  begin
    edtPath.Text:=dlgSave1.FileName;
  end;

  //MySQL user & MySQL Dump path
  user :='root';
  pass :='';
  database:='db_apotik';
  dir :='C:\xampp\mysql\bin';

  if pass<>'' then pass:=' -password='+pass;
   SetEnvironmentVariable(PChar('Path'),PChar(Dir));
   ShellExecute(Handle, 'open', PChar('cmd.exe'),
   pchar('/c mysqldump --opt --user='+user+pass+' -B '+database+' >"'+edtPath.Text+'"'),nil,sw_Hide);
   MessageDlg('Database Telah dibackup', mtInformation, [mbOK], 0);
end;

procedure Tfbackup.FormShow(Sender: TObject);
begin
  edtPath.Clear;
end;

end.
