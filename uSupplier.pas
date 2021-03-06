unit uSupplier;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  TFsupplier = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnTambah: TBitBtn;
    btnSimpan: TBitBtn;
    btnHapus: TBitBtn;
    btnKeluar: TBitBtn;
    img1: TImage;
    lbl2: TLabel;
    edtKode: TEdit;
    lbl3: TLabel;
    edtName: TEdit;
    lbl4: TLabel;
    mmoAlamat: TMemo;
    lbl5: TLabel;
    edtTelp: TEdit;
    edtId: TEdit;
    procedure btnKeluarClick(Sender: TObject);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnTambahClick(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure edtTelpKeyPress(Sender: TObject; var Key: Char);
    procedure edtNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure mmoAlamatChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fsupplier: TFsupplier;
  kode, status, oldName, oldAlamat, oldTelp : string;
  
implementation

uses
  dataModule, StrUtils, DB;

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
  with dm.qrySupplier do
    begin
      DisableControls;
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_supplier order by id';
      Open;
      EnableControls;
    end;
end;

procedure TFsupplier.btnKeluarClick(Sender: TObject);
begin
 Close;
end;

procedure TFsupplier.dbgrd1CellClick(Column: TColumn);
begin
 if dm.qrySupplier.IsEmpty=False then
    begin
      with dbgrd1 do
        begin
          edtKode.Text    := Fields[1].AsString;
          edtName.Text    := Fields[2].AsString;
          mmoAlamat.Text  := Fields[3].AsString;
          edtTelp.Text    := Fields[4].AsString;
        end;

      oldName := edtName.Text;
      oldAlamat := mmoAlamat.Text;
      oldTelp := edtTelp.Text;

      btnTambah.Enabled := True;
      btnSimpan.Caption := 'Edit'; btnSimpan.Enabled := True;
      btnHapus.Enabled := True; btnKeluar.Enabled := True;
    end;
end;

procedure TFsupplier.edtpencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with dm.qrySupplier do
    begin
      DisableControls;
      SQL.Clear;
      SQL.Text := 'select * from tbl_supplier where nama_supplier like ''%'+edtpencarian.Text+'%''';
      Open;
      EnableControls;
    end;
end;

procedure TFsupplier.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption='Tambah' then
    begin
      edtName.Enabled := True; edtName.SetFocus;
      mmoAlamat.Enabled := True;
      edtTelp.Enabled := True;

      btnTambah.Caption := 'Batal';
      btnSimpan.Enabled := True;
      btnKeluar.Enabled := false;
      btnHapus.Enabled := False;

      dbgrd1.Enabled := false;
      edtName.Clear;
      mmoAlamat.Clear;
      edtTelp.Clear;

      konek;

      with dm.qrySupplier do
        begin
          if IsEmpty then
            begin
              kode := '0001';
            end
          else
            begin
              Last;
              kode := RightStr(fieldbyname('kode').Text,4);
              kode := IntToStr(StrToInt(kode) + 1);
            end;
        end;

        edtKode.Text := 'SUP'+FormatFloat('0000',StrToInt(kode));
        btnSimpan.Caption := 'Simpan';
        status:='tambah';

        with dm.qrySupplier do
          begin
            Append;
            FieldByName('kode').AsString := edtKode.Text;
            Post;

            Locate('kode',edtKode.Text,[]);
            edtId.Text := fieldbyname('id').AsString;
          end;
    end
  else
    begin
      if edtId.Text <> '' then
        begin
          with dm.qrySupplier do
            begin
              Close;
              sql.Clear;
              SQL.Text := 'delete from tbl_supplier where id = '+QuotedStr(edtId.Text)+'';
              ExecSQL;
            end;
        end;
      FormShow(Sender);
    end;
end;

procedure TFsupplier.btnSimpanClick(Sender: TObject);
begin
  if btnSimpan.Caption = 'Simpan' then
    begin
      if Trim(edtName.Text)='' then
        begin
          MessageDlg('Nama Supplier Tidak Boleh Kosong',mtInformation,[mbok],0);
          edtName.SetFocus;
          Exit;
        end;

      if Trim(mmoAlamat.Text)='' then
        begin
          MessageDlg('Alamat Supplier Tidak Boleh Kosong',mtInformation,[mbok],0);
          mmoAlamat.SetFocus;
          Exit;
        end;

      if Trim(edtTelp.Text)='' then
        begin
          MessageDlg('No. Telp Tidak Boleh Kosong',mtInformation,[mbok],0);
          edtTelp.SetFocus;
          Exit;
        end;

      if status='tambah' then
        begin
          if dm.qrySupplier.Locate('nama_supplier',edtName.Text,[]) then
            begin
              MessageDlg('Nama Supplier Sudah Ada',mtError,[mbok],0);
              edtName.Clear; edtName.SetFocus;
              Exit;
            end;

          with dm.qrySupplier do
            begin
              Edit;
              FieldByName('nama_supplier').AsString := trim(edtName.Text);
              FieldByName('alamat_supplier').AsString := Trim(mmoAlamat.Text);
              FieldByName('telp_suplier').AsString := Trim(edtTelp.Text);
              Post;
            end;
        end

      else
        begin
          // edit perubahan
          if (edtName.Text <> oldName) or (mmoAlamat.Text <> oldAlamat) or (edtTelp.Text <> oldTelp) then
            begin
              if dm.qrySupplier.Locate('nama_supplier',edtName.Text,[]) then
                begin
                  MessageDlg('Nama Supplier Sudah Ada', mtError,[mbok],0);
                  edtName.SetFocus;
                  Exit;
                end;


              if dm.qrySupplier.Locate('kode',edtKode.Text,[]) then
                begin
                  with dm.qrySupplier do
                    begin
                      edit;
                      FieldByName('kode').AsString := edtKode.Text;
                      FieldByName('nama_supplier').AsString := trim(edtName.Text);
                      FieldByName('alamat_supplier').AsString := Trim(mmoAlamat.Text);
                      FieldByName('telp_suplier').AsString := Trim(edtTelp.Text);
                      Post;
                    end;
                end;
            end;
        end;
        
      MessageDlg('Data Berhasil Disimpan', mtInformation,[mbOK],0);
      FormShow(Sender);
    end
  else
    begin
      // edit data
      edtName.Enabled := True; edtName.SetFocus;
      mmoAlamat.Enabled := True; edtTelp.Enabled := True;

      dbgrd1.Enabled := False; edtpencarian.Enabled := false;

      btnHapus.Enabled := False;
      btnKeluar.Enabled := False;
      btnTambah.Enabled := True; btnTambah.Caption := 'Batal';
      btnSimpan.Caption := 'Simpan'; status := 'edit';
    end;
end;

procedure TFsupplier.btnHapusClick(Sender: TObject);
begin
  if MessageDlg('Yakin Data Akan Dihapus ?',mtConfirmation,[mbYes,mbNo],0)=mryes then
    begin
      dm.qrySupplier.Delete;

      MessageDlg('Data Berhasil Dihapus',mtInformation,[mbok],0);
      FormShow(Sender);
    end;
end;

procedure TFsupplier.edtTelpKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8, #9]) then Key := #0
end;

procedure TFsupplier.edtNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then mmoAlamat.SetFocus;
end;

procedure TFsupplier.FormShow(Sender: TObject);
begin
  edtKode.Clear; edtKode.Enabled := false;
  edtName.Clear; edtName.Enabled := false;
  mmoAlamat.Clear; mmoAlamat.Enabled := false;
  edtTelp.Clear; edtTelp.Enabled := false;

  edtpencarian.Clear; edtpencarian.Enabled := True;

  btnTambah.Enabled := True; btnTambah.Caption := 'Tambah';
  btnSimpan.Enabled := false; btnHapus.Enabled := False;
  btnKeluar.Enabled := True;

  dbgrd1.Enabled := True; edtpencarian.Enabled := True;
  edtId.Clear;
  konek;
end;

procedure TFsupplier.edtNameChange(Sender: TObject);
begin
  upperCase(Sender);
end;

procedure TFsupplier.mmoAlamatChange(Sender: TObject);
begin
  upperCaseMemo(Sender);
end;

end.
