unit uObat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, DBCtrls;

type
  TFobat = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    edtKode: TEdit;
    edtBarcode: TEdit;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnTambah: TBitBtn;
    btnSimpan: TBitBtn;
    btnHapus: TBitBtn;
    btnKeluar: TBitBtn;
    lbl6: TLabel;
    edtNama: TEdit;
    dblkcbbJenisObat: TDBLookupComboBox;
    dblkcbbSatuanObat: TDBLookupComboBox;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSimpanClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure dbgrd1CellClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fobat: TFobat;
  kode, status : string;
  oldNama, oldBarcode, oldSatuan, oldJenis : string;

implementation

uses
  dataModule, StrUtils;

{$R *.dfm}

procedure konek;
begin
  with dm.qryObat do
    begin
      DisableControls;
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_obat a left join tbl_jenis b on a.kode_jenis = b.id left join tbl_satuan c on a.kode_satuan = a.id order by a.id';
      Open;
      EnableControls;
    end;
end;

procedure TFobat.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TFobat.FormCreate(Sender: TObject);
begin
  edtKode.Clear; edtKode.Enabled := false;
  edtBarcode.Clear; edtBarcode.Enabled := False;
  edtNama.Clear; edtNama.Enabled := false;
  dblkcbbJenisObat.KeyValue := Null; dblkcbbJenisObat.Enabled := false;
  dblkcbbSatuanObat.KeyValue := Null; dblkcbbSatuanObat.Enabled := false;

  edtpencarian.Clear; edtpencarian.Enabled := True;

  btnTambah.Enabled := True; btnTambah.Caption := 'Tambah';
  btnSimpan.Enabled := false; btnHapus.Enabled := False;
  btnKeluar.Enabled := True;

  dbgrd1.Enabled := True; edtpencarian.Enabled := True;
  konek;
end;

procedure TFobat.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption='Tambah' then
    begin
      edtNama.Enabled := True; edtNama.SetFocus;
      edtBarcode.Enabled := True;
      dblkcbbJenisObat.Enabled := true;
      dblkcbbSatuanObat.Enabled := True;

      btnTambah.Caption := 'Batal';
      btnSimpan.Enabled := True;
      btnKeluar.Enabled := false;

      konek;

      with dm.qryObat do
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

        edtKode.Text := 'OBT'+FormatFloat('0000',StrToInt(kode));
        btnSimpan.Caption := 'Simpan';
        status:='tambah';
    end
  else
    begin
      FormCreate(Sender);
    end;
end;

procedure TFobat.edtpencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with dm.qryObat do
    begin
      DisableControls;
      SQL.Clear;
      SQL.Text := 'select * from tbl_obat where nama_obat like ''%'+edtpencarian.Text+'%''';
      Open;
      EnableControls;
    end;
end;

procedure TFobat.btnSimpanClick(Sender: TObject);
begin
  if btnSimpan.Caption = 'Simpan' then
    begin
      if Trim(edtNama.Text)='' then
        begin
          MessageDlg('Nama Obat Tidak Boleh Kosong',mtInformation,[mbok],0);
          edtNama.SetFocus;
          Exit;
        end;

      if dblkcbbJenisObat.KeyValue = Null then
        begin
          MessageDlg('Jenis Obat Tidak Boleh Kosong',mtInformation,[mbok],0);
          dblkcbbJenisObat.SetFocus;
          Exit;
        end;

      if dblkcbbSatuanObat.KeyValue = null then
        begin
          MessageDlg('Satuan Obat Tidak Boleh Kosong',mtInformation,[mbok],0);
          dblkcbbSatuanObat.SetFocus;
          Exit;
        end;

      if status='tambah' then
        begin
          if dm.qryObat.Locate('nama_obat',edtNama.Text,[]) then
            begin
              MessageDlg('Nama Obat Sudah Ada',mtError,[mbok],0);
              edtNama.Clear; edtNama.SetFocus;
              Exit;
            end;

          with dm.qryObat do
            begin
              Append;
              FieldByName('kode').AsString := edtKode.Text;
              FieldByName('barcode').AsString := edtBarcode.Text;
              FieldByName('nama_obat').AsString := trim(edtNama.Text);
              FieldByName('kode_jenis').AsString := dblkcbbJenisObat.KeyValue;
              FieldByName('kode_satuan').AsString := dblkcbbSatuanObat.KeyValue;
              Post;
            end;
        end

      else
        begin
          // edit perubahan
          if (edtNama.Text <> oldNama) or (edtBarcode.Text <> oldBarcode) or (dblkcbbJenisObat.KeyValue <> oldJenis) or (dblkcbbSatuanObat.KeyValue <> oldSatuan) then
            begin
              if dm.qryObat.Locate('nama_obat',edtNama.Text,[]) then
                begin
                  MessageDlg('Nama Obat Sudah Ada', mtError,[mbok],0);
                  edtNama.SetFocus;
                  Exit;
                end;

              if dm.qryObat.Locate('kode',edtKode.Text,[]) then
                begin
                  with dm.qryObat do
                    begin
                      edit;
                      FieldByName('kode').AsString := edtKode.Text;
                      FieldByName('barcode').AsString := edtBarcode.Text;
                      FieldByName('nama_obat').AsString := trim(edtNama.Text);
                      FieldByName('kode_jenis').AsString := dblkcbbJenisObat.KeyValue;
                      FieldByName('kode_satuan').AsString := dblkcbbSatuanObat.KeyValue;
                      Post;
                    end;
                end;
            end;
        end;
        
      MessageDlg('Data Berhasil Disimpan', mtInformation,[mbOK],0);
      FormCreate(Sender);
    end
  else
    begin
      // edit data
      edtNama.Enabled := True; edtNama.SetFocus;
      edtBarcode.Enabled := True;
      dblkcbbJenisObat.Enabled := True;
      dblkcbbSatuanObat.Enabled := True;

      dbgrd1.Enabled := False; edtpencarian.Enabled := false;

      btnHapus.Enabled := False;
      btnKeluar.Enabled := False;
      btnTambah.Enabled := True; btnTambah.Caption := 'Batal';
      btnSimpan.Caption := 'Simpan'; status := 'edit';
    end;
end;

procedure TFobat.btnHapusClick(Sender: TObject);
begin
  if MessageDlg('Yakin Data Akan Dihapus ?',mtConfirmation,[mbYes,mbNo],0)=mryes then
    begin
      dm.qryObat.Delete;

      MessageDlg('Data Berhasil Dihapus',mtInformation,[mbok],0);
      FormCreate(Sender);
    end;
end;

procedure TFobat.dbgrd1CellClick(Column: TColumn);
begin
  if dm.qryObat.IsEmpty=False then
    begin
      with dbgrd1 do
        begin
          edtKode.Text              := Fields[1].AsString;
          edtBarcode.Text           := Fields[2].AsString;
          edtNama.Text              := Fields[3].AsString;
          dblkcbbJenisObat.KeyValue := Fields[6].AsString;
          dblkcbbSatuanObat.KeyValue:= fields[9].AsString;
        end;

      oldNama   := edtNama.Text;
      oldJenis  := dblkcbbJenisObat.KeyValue;
      oldSatuan := dblkcbbSatuanObat.KeyValue;

      btnTambah.Enabled := False;
      btnSimpan.Caption := 'Edit'; btnSimpan.Enabled := True;
      btnHapus.Enabled := True; btnKeluar.Enabled := True;
    end;
end;

end.
