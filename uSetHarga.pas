unit uSetHarga;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids;

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
    procedure btnBantuObatClick(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnTambahClick(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
    procedure edtHargaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSetHarga: TfSetHarga;

implementation

uses
  dataModule, uBantuObat;

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
          Post;

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

end.
