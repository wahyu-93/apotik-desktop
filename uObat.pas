unit uObat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, DBCtrls, jpeg, ExtCtrls;

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
    img1: TImage;
    lbl7: TLabel;
    edtStok: TEdit;
    edtIdObat: TEdit;
    procedure btnKeluarClick(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSimpanClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure edtStokKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure edtNamaChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fobat: TFobat;
  kode, status : string;
  oldNama, oldBarcode, oldSatuan, oldJenis, oldStok : string;

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

procedure konek;
begin
  with dm.qryObatRelasi do
    begin
      DisableControls;
      Close;
      sql.Clear;
      SQL.Text := 'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_jenis, b.kode_satuan, a.id as id_jenis, b.stok, '+
                  'a.kode as jenisKode, a.jenis, c.id as id_satuan, c.kode as satuanKode, c.satuan from tbl_jenis a left join '+
                  'tbl_obat b on a.id = b.kode_jenis INNER join tbl_satuan c on c.id = b.kode_satuan order by b.id';
      Open;
      EnableControls;
    end;

  with dm.qrySatuan do
    begin
      close;
      SQL.Clear;
      SQL.Text := 'select * from tbl_satuan';
      Open;
    end;

  with dm.qryJenis do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'select * from tbl_jenis';
      Open;
    end;

  with dm.qryObat do
    begin
      close;
      SQL.Clear;
      sql.Text := 'select * from tbl_obat';
      Open;
    end;
end;

procedure TFobat.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TFobat.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption='Tambah' then
    begin
      edtNama.Enabled := True; edtNama.SetFocus;
      edtBarcode.Enabled := True;
      dblkcbbJenisObat.Enabled := true;
      dblkcbbSatuanObat.Enabled := True;
      edtStok.Enabled := True; edtStok.Text := '0';

      btnTambah.Caption := 'Batal';
      btnSimpan.Enabled := True;
      btnKeluar.Enabled := false;

      dbgrd1.Enabled := False;

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

        dm.qryObat.Append;
        dm.qryObat.FieldByName('kode').AsString := edtKode.Text;
        dm.qryObat.Post;

        with dm.qryObat do
          begin
            Locate('kode',edtKode.Text,[]);
            edtIdObat.Text := fieldbyname('id').AsString;
          end;
    end
  else
    begin
      if edtIdObat.Text <> '' then
        begin
          with dm.qryObat do
            begin
              close;
              sql.Clear;
              sql.Text := 'delete from tbl_obat where id = '+QuotedStr(edtIdObat.Text)+'';
              ExecSQL;
            end;
        end;

      FormShow(Sender);
    end;
end;

procedure TFobat.edtpencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   with dm.qryObatRelasi do
    begin
      DisableControls;
      Close;
      sql.Clear;
      SQL.Text := 'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_jenis, b.kode_satuan, a.id as id_jenis, b.stok, '+
                  'a.kode as jenisKode, a.jenis, c.id as id_satuan, c.kode as satuanKode, c.satuan from tbl_jenis a left join '+
                  'tbl_obat b on a.id = b.kode_jenis INNER join tbl_satuan c on c.id = b.kode_satuan where b.nama_obat like ''%'+edtpencarian.Text+'%'' order by b.id';
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

      if edtStok.Text = '' then
        begin
          MessageDlg('Stok Diisi',mtInformation,[mbok],0);
          edtStok.SetFocus;
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
              close;
              sql.Clear;
              sql.Text := 'update tbl_obat set barcode = '+QuotedStr(edtBarcode.Text)+', nama_obat = '+QuotedStr(Trim(edtNama.Text))+
                          ', kode_jenis = '+QuotedStr(dblkcbbJenisObat.KeyValue)+', kode_satuan = '+QuotedStr(dblkcbbSatuanObat.KeyValue)+
                          ', stok = '+QuotedStr(edtStok.Text)+' where kode = '+QuotedStr(edtKode.Text)+'';
              ExecSQL;
            end;
        end

      else
        begin
          // edit perubahan
          if edtNama.Text <> oldNama then
            begin
              if dm.qryObat.Locate('nama_obat',edtNama.Text,[]) then
                begin
                  MessageDlg('Nama Obat Sudah Ada', mtError,[mbok],0);
                  edtNama.SetFocus;
                  Exit;
                end;
            end;

          with dm.qryObat do
            begin
              close;
              sql.Clear;
              sql.Text := 'update tbl_obat set barcode = '+QuotedStr(edtBarcode.Text)+', nama_obat = '+QuotedStr(Trim(edtNama.Text))+
                          ', kode_jenis = '+QuotedStr(dblkcbbJenisObat.KeyValue)+', kode_satuan = '+QuotedStr(dblkcbbSatuanObat.KeyValue)+
                          ', stok = '+QuotedStr(edtStok.Text)+' where kode = '+QuotedStr(edtKode.Text)+'';
              ExecSQL;
            end;
        end;

      MessageDlg('Data Berhasil Disimpan', mtInformation,[mbOK],0);
      FormShow(Sender);
    end
  else
    begin
      // edit data
      edtNama.Enabled := True; edtNama.SetFocus;
      edtBarcode.Enabled := True;
      dblkcbbJenisObat.Enabled := True;
      dblkcbbSatuanObat.Enabled := True;
      edtStok.Enabled := True;

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
      if dm.qryObat.Locate('kode',edtKode.Text,[]) then dm.qryObat.Delete;

      MessageDlg('Data Berhasil Dihapus',mtInformation,[mbok],0);
      FormShow(Sender);
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
          edtStok.Text              := Fields[12].AsString;
        end;

      oldNama   := edtNama.Text;
      oldJenis  := dblkcbbJenisObat.KeyValue;
      oldSatuan := dblkcbbSatuanObat.KeyValue;
      oldStok   := edtStok.Text;

      btnTambah.Enabled := False;
      btnSimpan.Caption := 'Edit'; btnSimpan.Enabled := True;
      btnHapus.Enabled := True; btnKeluar.Enabled := True;
    end;
end;

procedure TFobat.edtStokKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#9,#8,#13]) then key:=#0;
  if Key=#13 then btnSimpan.Click;
end;

procedure TFobat.FormShow(Sender: TObject);
begin
  edtKode.Clear; edtKode.Enabled := false;
  edtBarcode.Clear; edtBarcode.Enabled := False;
  edtNama.Clear; edtNama.Enabled := false;
  dblkcbbJenisObat.KeyValue := Null; dblkcbbJenisObat.Enabled := false;
  dblkcbbSatuanObat.KeyValue := Null; dblkcbbSatuanObat.Enabled := false;
  edtStok.Clear; edtStok.Enabled := False;

  edtpencarian.Clear; edtpencarian.Enabled := True;

  btnTambah.Enabled := True; btnTambah.Caption := 'Tambah';
  btnSimpan.Enabled := false; btnHapus.Enabled := False;
  btnKeluar.Enabled := True;

  dbgrd1.Enabled := True; edtpencarian.Enabled := True;
  edtIdObat.Clear;
  konek;
end;

procedure TFobat.edtNamaChange(Sender: TObject);
begin
  upperCase(Sender);
end;

end.
