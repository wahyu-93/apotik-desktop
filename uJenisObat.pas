unit uJenisObat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids;

type
  TfJenisObat = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    edtKode: TEdit;
    edtJenis: TEdit;
    mmoKet: TMemo;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnTambah: TBitBtn;
    btnSimpan: TBitBtn;
    btnHapus: TBitBtn;
    btnKeluar: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure btnHapusClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fJenisObat: TfJenisObat;
  kode, status, oldJenis : string;

implementation

uses
  dataModule, DB, StrUtils, ADODB;

{$R *.dfm}

procedure konek;
begin
  with dm.qryJenis do
    begin
      DisableControls;
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_jenis order by id';
      Open;
      EnableControls;
    end;
end;

procedure TfJenisObat.FormCreate(Sender: TObject);
begin
  edtKode.Clear; edtKode.Enabled := false;
  edtJenis.Clear; edtJenis.Enabled := false;
  mmoKet.Clear; mmoKet.Enabled := False;
  edtpencarian.Clear; edtpencarian.Enabled := True;

  btnTambah.Enabled := True; btnTambah.Caption := 'Tambah';
  btnSimpan.Enabled := false; btnHapus.Enabled := False;
  btnKeluar.Enabled := True;

  dbgrd1.Enabled := True; edtpencarian.Enabled := True;
  konek;
end;

procedure TfJenisObat.btnKeluarClick(Sender: TObject);
begin
  Close;
end;

procedure TfJenisObat.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption='Tambah' then
    begin
      edtJenis.Enabled := True; edtJenis.SetFocus;
      mmoKet.Enabled := True;

      btnTambah.Caption := 'Batal';
      btnSimpan.Enabled := True;
      btnKeluar.Enabled := false;

      konek;

      with dm.qryJenis do
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

        edtKode.Text := 'JNS'+FormatFloat('0000',StrToInt(kode));
        btnSimpan.Caption := 'Simpan';
        status:='tambah';
        oldJenis := '';
    end
  else
    begin
      FormCreate(Sender);
    end;
end;

procedure TfJenisObat.btnSimpanClick(Sender: TObject);
begin
  if btnSimpan.Caption = 'Simpan' then
    begin
      if Trim(edtJenis.Text)='' then
        begin
          MessageDlg('Jenis Obat Tidak Boleh Kosong',mtInformation,[mbok],0);
          edtJenis.SetFocus;
          Exit;
        end;

      if status='tambah' then
        begin
          begin
            if Trim(edtJenis.Text) = dm.qryJenis.FieldByName('jenis').AsString then
              begin
                MessageDlg('Jenis Obat Sudah Ada',mtError,[mbok],0);
                edtJenis.Clear; edtJenis.SetFocus;
                Exit;
              end;

            with dm.qryJenis do
              begin
                Append;
                FieldByName('kode').AsString := edtKode.Text;
                FieldByName('jenis').AsString := trim(edtJenis.Text);
                FieldByName('keterangan').AsString := Trim(mmoKet.Text);
                Post;
              end;

            MessageDlg('Data Berhasil Disimpan', mtInformation,[mbOK],0);
            FormCreate(Sender);
          end;
        end
      else
        begin
          if oldJenis <> edtJenis.Text then
            begin
              if Trim(edtJenis.Text) = dm.qryJenis.FieldByName('jenis').AsString then
                begin
                  MessageDlg('Jenis Obat Sudah Ada',mtError,[mbok],0);
                  edtJenis.Clear; edtJenis.SetFocus;
                  Exit;
                end;

               //simpan perubaan
               with dm.qryJenis do
                begin
                  Edit;
                  FieldByName('jenis').AsString := trim(edtJenis.Text);
                  FieldByName('keterangan').AsString := Trim(mmoKet.Text);
                  Post;
                end;
            end
          else
            begin
              with dm.qryJenis do
                begin
                  close;
                  SQL.Clear;
                  SQL.Text := 'update tbl_jenis set jenis ='+QuotedStr(edtJenis.Text)
                          +', keterangan = '+QuotedStr(mmoKet.Text)+' where kode = '+QuotedStr(edtKode.Text)+'';
                  ExecSQL;
                end;
            end;

          FormCreate(Sender);
          MessageDlg('Data Berhasil Diubah',mtInformation,[mbok],0);
        end;
    end
  else
    begin
      // edit data
      edtJenis.Enabled := True; edtJenis.SetFocus;
      mmoKet.Enabled := True;

      dbgrd1.Enabled := False; edtpencarian.Enabled := false;

      btnHapus.Enabled := False;
      btnKeluar.Enabled := False;
      btnTambah.Enabled := True; btnTambah.Caption := 'Batal';
      btnSimpan.Caption := 'Simpan'; status := 'edit';
    end;
end;

procedure TfJenisObat.edtpencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with dm.qryJenis do
    begin
      DisableControls;
      SQL.Clear;
      SQL.Text := 'select * from tbl_jenis where jenis like ''%'+edtpencarian.Text+'%''';
      Open;
      EnableControls;
    end;
end;

procedure TfJenisObat.dbgrd1CellClick(Column: TColumn);
begin
  if dm.qryJenis.IsEmpty=False then
    begin
      with dbgrd1 do
        begin
          edtKode.Text  := Fields[1].AsString;
          edtJenis.Text := Fields[2].AsString;
          mmoKet.Text   := Fields[3].AsString;
        end;

      oldJenis := edtJenis.Text;
      btnTambah.Enabled := False;
      btnSimpan.Caption := 'Edit'; btnSimpan.Enabled := True;
      btnHapus.Enabled := True; btnKeluar.Enabled := True;
    end;
end;

procedure TfJenisObat.btnHapusClick(Sender: TObject);
begin
  if MessageDlg('Yakin Data Akan Dihapus ?',mtConfirmation,[mbYes,mbNo],0)=mryes then
    begin
      dm.qryJenis.Delete;

      MessageDlg('Data Berhasil Dihapus',mtInformation,[mbok],0);
      FormCreate(Sender);
    end;
end;

end.
