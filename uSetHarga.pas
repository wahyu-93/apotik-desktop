unit uSetHarga;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, ComCtrls, jpeg, ExtCtrls;

type
  TfSetHarga = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lblNamaObat: TLabel;
    lblJenis: TLabel;
    lblSatuan: TLabel;
    lbl21: TLabel;
    lblHargaBeli: TLabel;
    lblSupplier: TLabel;
    lbl22: TLabel;
    lbl23: TLabel;
    edtKode: TEdit;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnTambah: TBitBtn;
    btnSimpan: TBitBtn;
    btnHapus: TBitBtn;
    btnKeluar: TBitBtn;
    btnBantuObat: TBitBtn;
    edtHarga: TEdit;
    edtIdObat: TEdit;
    edtHargaBeli: TEdit;
    lbl9: TLabel;
    dtpTglExp: TDateTimePicker;
    img1: TImage;
    procedure btnBantuObatClick(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnTambahClick(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
    procedure edtHargaKeyPress(Sender: TObject; var Key: Char);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure konek;
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSetHarga: TfSetHarga;

implementation

uses
  dataModule, uBantuObat, DB;

{$R *.dfm}

procedure TfSetHarga.btnBantuObatClick(Sender: TObject);
begin
  fBantuObat.edt1.Text := 'setHarga';
  fBantuObat.ShowModal;
end;

procedure TfSetHarga.btnKeluarClick(Sender: TObject);
begin
  Close;
end;

procedure TfSetHarga.FormShow(Sender: TObject);
begin
  edtKode.Clear; edtKode.Enabled := false;
  edtHarga.Clear; edtHarga.Enabled := False;
  btnBantuObat.Enabled := false;
  edtpencarian.Enabled := True; edtpencarian.SetFocus; edtpencarian.Clear;

  lblNamaObat.Caption := '-';
  lblJenis.Caption := '-';
  lblSatuan.Caption := '-';
  lblHargaBeli.Caption := '-';
  lblSupplier.Caption := '-';

  btnTambah.Caption := 'Tambah[F1]'; btnTambah.Enabled := True;
  btnSimpan.Enabled := false;
  btnHapus.Enabled := False;
  btnKeluar.Enabled := True;

  dtpTglExp.Enabled := False;
  dtpTglExp.Date := Now;
  
  konek;
end;

procedure TfSetHarga.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F1: btnTambah.Click;
    VK_F2: btnBantuObat.Click;
  end;
end;

procedure TfSetHarga.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption = 'Tambah[F1]' then
    begin
      btnBantuObat.Enabled := True;
      edtHarga.Enabled := True;
      edtHarga.SetFocus;

      edtpencarian.Enabled := false; edtpencarian.Clear;
      dtpTglExp.Enabled := True;

      btnSimpan.Enabled := True;
      btnTambah.Caption := 'Batal[F1]';
      
    end
  else
    begin
      FormShow(Sender);
    end;
end;

procedure TfSetHarga.btnSimpanClick(Sender: TObject);
begin
  if edtKode.Text = '' then
    begin
      MessageDlg('Obat Belum Dipilih', mtInformation,[mbok],0);
      Exit;
    end;

  if edtHarga.Text = '' then
    begin
      MessageDlg('Harga Jual Belum Diisi' ,mtInformation,[mbOK],0);
      edtHarga.SetFocus;
      Exit;
    end;

  with dm.qrySetHarga do
    begin
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_harga_jual where obat_id = '+QuotedStr(edtIdObat.Text)+'';
      Open;

      if IsEmpty then
        begin
          Append;
          FieldByName('obat_id').AsString := edtIdObat.Text;
          FieldByName('harga_jual').AsString := edtHarga.Text;
          FieldByName('harga_beli_terakhir').AsString := edtHargaBeli.Text;
          FieldByName('supplier').AsString := lblSupplier.Caption;
          FieldByName('satuan').AsString := lblSatuan.Caption;
          FieldByName('jenis').AsString := lblJenis.Caption;
          Post;

          with dm.qryObat do
            begin
              close;
              sql.clear;
              SQL.Text := 'update tbl_obat set tgl_exp = '+QuotedStr(FormatDateTime('yyyy-mm-dd',dtpTglExp.Date))+' where id = '+QuotedStr(edtIdObat.Text)+'';
              ExecSQL;
            end;

          MessageDlg('Data Berhasil Disimpan', mtInformation,[mbOK],0);
        end
      else
        begin
          MessageDlg('Obat Sudah Diberi Harga, Hapus Data sebelumnya untuk Memasukkan Harga Baru',mtInformation,[mbok],0);
          Exit;
        end;
    end;

  FormShow(Sender);

end;

procedure TfSetHarga.edtHargaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in(['0'..'9',#13,#9,#8])) then Key:=#0;
  if Key=#13 then btnSimpan.Click;
end;

procedure TfSetHarga.dbgrd1DblClick(Sender: TObject);
begin
  if dm.qryRelasiSetHarga.IsEmpty then Exit;
  
  edtKode.Text := dbgrd1.Fields[11].AsString+'-'+dbgrd1.Fields[1].AsString;
  lblNamaObat.Caption := dbgrd1.Fields[3].AsString;
  lblJenis.Caption := dbgrd1.Fields[17].AsString;
  lblSatuan.Caption := dbgrd1.Fields[16].AsString;
  lblHargaBeli.Caption := 'Rp. ' + FormatFloat('###,###',StrToFloat(dbgrd1.Fields[5].AsString));
  lblSupplier.Caption := dbgrd1.Fields[6].AsString;

  edtHargaBeli.Text := dbgrd1.Fields[4].AsString;
  edtIdObat.Text := dbgrd1.Fields[2].AsString;
  dtpTglExp.Date := dbgrd1.Fields[7].AsDateTime;
  edtHarga.Text := dbgrd1.Fields[4].AsString;

  btnTambah.Caption := 'Batal[F1]';
  btnBantuObat.Enabled := false;
  btnHapus.Enabled := false;
  btnHapus.Enabled := true;
end;

procedure TfSetHarga.btnHapusClick(Sender: TObject);
begin
  if MessageDlg('Yakin Data Akan Dihapus ?',mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      with dm.qrySetHarga do
        begin
          if Locate('obat_id',edtIdObat.Text,[]) then
            begin
              Delete;
            end;
        end;

      MessageDlg('Data Berhasil Dihapus ?',mtInformation,[mbok],0);
      FormShow(Sender);
    end;
end;

procedure TfSetHarga.konek;
begin
  with dm.qryRelasiSetHarga do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id = b.id order by a.id';
      Open;
    end;
end;

procedure TfSetHarga.edtpencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   with dm.qryRelasiSetHarga do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id = b.id where b.nama_obat like ''%'+edtpencarian.Text+'%'' order by a.id';
      Open;
    end;
end;

end.
