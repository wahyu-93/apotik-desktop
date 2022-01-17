unit uSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfSetting = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    btnSimpan: TBitBtn;
    btnKeluar: TBitBtn;
    edtNama: TEdit;
    mmoAlamat: TMemo;
    edtTelp: TEdit;
    chkCetak: TCheckBox;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
    procedure edtNamaChange(Sender: TObject);
    procedure mmoAlamatChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSetting: TfSetting;

implementation

uses
  dataModule;

{$R *.dfm}

procedure upperCase(sender:TObject);  
var
  sebelumUp : TNotifyEvent; //mengeset variabel yang dibutuhkan
  dimulaiUp: Integer;
begin
  with (Sender as TEdit) do
    begin
      sebelumUp := OnChange; //assign var sebelumUp seperti onChange
      OnChange := nil;
      dimulaiUp := SelStart;
      if ((SelStart > 0) and (Text[SelStart - 1] = ' ')) or (SelStart = 1) then
        begin
          SelStart := SelStart - 1;
          SelLength := 1;
          //menjadikan karakter pertama menjadi upperCase
          SelText := AnsiUpperCase (SelText);
        end;
      OnChange := sebelumUp;
      SelStart := dimulaiUp;
    end;
end;

procedure upperCaseMemo(sender:TObject);  
var
  sebelumUp : TNotifyEvent; //mengeset variabel yang dibutuhkan
  dimulaiUp: Integer;
begin
  with (Sender as TMemo) do
    begin
      sebelumUp := OnChange; //assign var sebelumUp seperti onChange
      OnChange := nil;
      dimulaiUp := SelStart;
      if ((SelStart > 0) and (Text[SelStart - 1] = ' ')) or (SelStart = 1) then
        begin
          SelStart := SelStart - 1;
          SelLength := 1;
          //menjadikan karakter pertama menjadi upperCase
          SelText := AnsiUpperCase (SelText);
        end;
      OnChange := sebelumUp;
      SelStart := dimulaiUp;
    end;
end;

procedure konek;
begin
  with dm.qrySetting do
    begin
      close;
      sql.Clear;
      sql.Text := 'select * from tbl_setting';
      Open;
    end;
end;

procedure TfSetting.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfSetting.FormShow(Sender: TObject);
begin
  konek;

  with dm.qrySetting do
    begin
      edtNama.Text := fieldbyname('nama_toko').AsString;
      mmoAlamat.Text := fieldbyname('alamat').AsString;
      edtTelp.Text := fieldbyname('telp').AsString;

      if FieldByName('cetak').AsString = '0' then
        chkCetak.Checked := False
      else
        chkCetak.Checked := True;
    end;

  edtNama.Enabled := false;
  mmoAlamat.Enabled := false;
  edtTelp.Enabled := False;
  chkCetak.Enabled := False;

  btnSimpan.Caption := 'Edit[F5]';
end;

procedure TfSetting.btnSimpanClick(Sender: TObject);
var cetak : string;
begin
  if btnSimpan.Caption = 'Edit[F5]' then
    begin
      btnSimpan.Caption := 'Simpan[F5]';

      edtNama.Enabled := True; edtNama.SetFocus;
      edtTelp.Enabled := True;
      mmoAlamat.Enabled := True;
      chkCetak.Enabled := True;
    end
  else
    begin
      if chkCetak.Checked = True then cetak := '1' else cetak := '0';

      with dm.qrySetting do
        begin
          Edit;
          FieldByName('nama_toko').AsString := edtNama.Text;
          FieldByName('alamat').AsString := mmoAlamat.Text;
          FieldByName('telp').AsString := edtTelp.Text;
          FieldByName('cetak').AsString := cetak;
          Post;
        end;

      FormShow(Sender);
      MessageDlg('Setting Berhasil Diubah',mtInformation,[mbOK],0);

    end;
end;

procedure TfSetting.edtNamaChange(Sender: TObject);
begin
  upperCase(Sender);
end;

procedure TfSetting.mmoAlamatChange(Sender: TObject);
begin
  upperCaseMemo(Sender);
end;

end.
