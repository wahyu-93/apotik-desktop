unit uSatuan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  TFSatuan = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    lbl2: TLabel;
    lbl3: TLabel;
    edtKode: TEdit;
    edtSatuan: TEdit;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnTambah: TBitBtn;
    btnSimpan: TBitBtn;
    btnHapus: TBitBtn;
    btnKeluar: TBitBtn;
    img1: TImage;
    procedure dbgrd1CellClick(Column: TColumn);
    procedure btnTambahClick(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSimpanClick(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSatuan: TFSatuan;
  kode, status, oldSatuan : string;

implementation

uses dataModule, StrUtils;

{$R *.dfm}

procedure konek;
begin
  with dm.qrySatuan do
    begin
      DisableControls;
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_satuan order by id';
      Open;
      EnableControls;
    end;
end;


procedure TFSatuan.dbgrd1CellClick(Column: TColumn);
begin
  if dm.qrySatuan.IsEmpty=False then
    begin
      with dbgrd1 do
        begin
          edtKode.Text  := Fields[1].AsString;
          edtSatuan.Text := Fields[2].AsString;
        end;

      oldSatuan := edtSatuan.Text;
      btnTambah.Enabled := False;
      btnSimpan.Caption := 'Edit'; btnSimpan.Enabled := True;
      btnHapus.Enabled := True; btnKeluar.Enabled := True;
    end;
end;

procedure TFSatuan.btnTambahClick(Sender: TObject);
begin
 if btnTambah.Caption='Tambah' then
    begin
      edtSatuan.Enabled := True; edtSatuan.SetFocus;

      btnTambah.Caption := 'Batal';
      btnSimpan.Enabled := True;
      btnKeluar.Enabled := false;

      dbgrd1.Enabled := false;

      konek;

      with dm.qrySatuan do
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

        edtKode.Text := 'STN'+FormatFloat('0000',StrToInt(kode));
        btnSimpan.Caption := 'Simpan';
        status:='tambah';
        oldSatuan := '';
    end
 else
  begin
    FormShow(Sender);
  end;
end;

procedure TFSatuan.edtpencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with dm.qrySatuan do
    begin
      DisableControls;
      SQL.Clear;
      SQL.Text := 'select * from tbl_satuan where satuan like ''%'+edtpencarian.Text+'%''';
      Open;
      EnableControls;
    end;
end;

procedure TFSatuan.btnSimpanClick(Sender: TObject);
begin
  if btnSimpan.Caption = 'Simpan' then
    begin
      if Trim(edtSatuan.Text)='' then
        begin
          MessageDlg('Jenis Satuan Tidak Boleh Kosong',mtInformation,[mbok],0);
          edtSatuan.SetFocus;
          Exit;
        end;

      if status='tambah' then
        begin
          if dm.qrySatuan.Locate('satuan',edtSatuan.Text,[]) then
            begin
              MessageDlg('Jenis Satuan Sudah Ada',mtError,[mbok],0);
              edtSatuan.Clear; edtSatuan.SetFocus;
              Exit;
            end;

          with dm.qrySatuan do
            begin
              Append;
              FieldByName('kode').AsString := edtKode.Text;
              FieldByName('satuan').AsString := trim(edtSatuan.Text);
              Post;
            end;

          MessageDlg('Data Berhasil Disimpan', mtInformation,[mbOK],0);
          FormShow(Sender);
        end
      else
        begin
          if oldSatuan <> edtSatuan.Text then
            begin
              if dm.qrySatuan.Locate('satuan',edtSatuan.Text,[]) then
                begin
                  MessageDlg('Satuan Sudah Ada',mtError,[mbok],0);
                  edtSatuan.Clear; edtSatuan.SetFocus;
                  Exit;
                end;

               //simpan perubaan
              if dm.qrySatuan.Locate('kode',edtKode.Text,[]) then
                begin
                  with dm.qrySatuan do
                    begin
                      Edit;
                      FieldByName('satuan').AsString := trim(edtSatuan.Text);
                      Post;
                    end;
                end;
            end
          else
            begin
              with dm.qrySatuan do
                begin
                  close;
                  SQL.Clear;
                  SQL.Text := 'update tbl_satuan set satuan ='+QuotedStr(edtSatuan.Text)
                          +' where kode = '+QuotedStr(edtKode.Text)+'';
                  ExecSQL;
                end;
            end;

          FormShow(Sender);
          MessageDlg('Data Berhasil Diubah',mtInformation,[mbok],0);
        end;
    end
  else
    begin
      // edit data
      edtSatuan.Enabled := True; edtSatuan.SetFocus;
      dbgrd1.Enabled := False; edtpencarian.Enabled := false;

      btnHapus.Enabled := False;
      btnKeluar.Enabled := False;
      btnTambah.Enabled := True; btnTambah.Caption := 'Batal';
      btnSimpan.Caption := 'Simpan'; status := 'edit';
    end;
end;

procedure TFSatuan.btnKeluarClick(Sender: TObject);
begin
  Close;
end;

procedure TFSatuan.btnHapusClick(Sender: TObject);
begin
 if MessageDlg('Yakin Data Akan Dihapus ?',mtConfirmation,[mbYes,mbNo],0)=mryes then
    begin
      dm.qrySatuan.Delete;

      MessageDlg('Data Berhasil Dihapus',mtInformation,[mbok],0);
      FormShow(Sender);
    end;
end;

procedure TFSatuan.FormShow(Sender: TObject);
begin
  edtKode.Clear; edtKode.Enabled := false;
  edtSatuan.Clear; edtSatuan.Enabled := false;
  edtpencarian.Clear; edtpencarian.Enabled := True;

  btnTambah.Enabled := True; btnTambah.Caption := 'Tambah';
  btnSimpan.Enabled := false; btnHapus.Enabled := False;
  btnKeluar.Enabled := True;

  dbgrd1.Enabled := True; edtpencarian.Enabled := True;
  konek;
end;

end.
