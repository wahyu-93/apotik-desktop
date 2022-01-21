unit uProsesRetur;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfProsesRetur = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    btnTambah: TBitBtn;
    btnKeluar: TBitBtn;
    edtFaktur: TEdit;
    edtTglJual: TEdit;
    edtKodeObat: TEdit;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    edtTglRetur: TEdit;
    edtNamaObat: TEdit;
    edtJumlahJual: TEdit;
    edtJumlahRetur: TEdit;
    mmoAlasan: TMemo;
    bvl1: TBevel;
    lbl10: TLabel;
    edtHargaJual: TEdit;
    edtKodeRetur: TEdit;
    edtIdPenjualan: TEdit;
    edtIdObat: TEdit;
    edtHarga: TEdit;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtJumlahReturKeyPress(Sender: TObject; var Key: Char);
    procedure mmoAlasanChange(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fProsesRetur: TfProsesRetur;

implementation

uses
  dataModule, StrUtils, DB, uReturn;

{$R *.dfm}

procedure upperCase(sender:TObject);  
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

procedure TfProsesRetur.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfProsesRetur.FormShow(Sender: TObject);
begin
  mmoAlasan.SetFocus;
end;

procedure TfProsesRetur.edtJumlahReturKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#32,#8,#9,#13]) then Key:=#0;
  if Key=#13 then  mmoAlasan.SetFocus;
end;

procedure TfProsesRetur.mmoAlasanChange(Sender: TObject);
begin
  upperCase(Sender);
end;

procedure TfProsesRetur.btnTambahClick(Sender: TObject);
var kode : string;
begin
  if edtJumlahRetur.Text = '' then
    begin
      MessageDlg('Jumlah Retur Belum DImasukkan',mtInformation,[mbok],0);
      edtJumlahRetur.SetFocus;
      Exit;
    end;

  if (StrToInt(edtJumlahRetur.Text) > StrToInt(edtJumlahJual.Text)) or (StrToInt(edtJumlahRetur.Text) < 1 ) then
    begin
      MessageDlg('Jumlah Barang Retur Tidak boleh 0 ' + #13 + 'dan Tidak Boleh Melebihi Barang Yang Dijual',mtInformation,[mbOK],0);
      edtJumlahRetur.Text := edtJumlahJual.Text;
      edtJumlahRetur.SetFocus;
      Exit;
    end;

    // simpan tbl_retur dan tbl_stok
    // simpan tbl_retur
    with dm.qryRetur do
      begin
        Close;
        SQL.Clear;
        SQL.Text := 'update tbl_retur set faktur_penjualan = '+QuotedStr(edtFaktur.Text)+' where kode = '+QuotedStr(edtKodeRetur.Text)+'';
        ExecSQL;
      end;

    // simpan tbl_stok
    with dm.qryStok do
      begin
        close;
        sql.clear;
        sql.Text := 'select * from tbl_stok where no_faktur = '+QuotedStr(edtFaktur.Text)+' and obat_id = '+QuotedStr(edtIdObat.Text)+' and keterangan = '+QuotedStr('retur-penjualan')+'';
        open;

        if IsEmpty then
          begin
            Append;
            FieldByName('no_faktur').AsString := edtFaktur.Text;
            FieldByName('obat_id').AsString := edtIdObat.Text;
            FieldByName('jumlah').AsString := edtJumlahRetur.Text;
            FieldByName('harga').AsString := edtHarga.Text;
            FieldByName('keterangan').AsString := 'retur-penjualan';
            FieldByName('alasan').AsString := mmoAlasan.Text;
            Post;
          end
        else
          begin
            close;
            sql.Clear;
            SQL.Text := 'update tbl_stok set jumlah = '+QuotedStr(edtJumlahRetur.Text)+' where no_faktur = '+QuotedStr(edtFaktur.Text)+' and keterangan = '+QuotedStr('retur-penjualan')+' ';
            ExecSQL;
          end;
      end;

    //refresh tbl_relasiReturObat
    with dm.qryRelasiReturObat do
      begin
        Close;
        SQL.Clear;
        SQL.Text := 'select * from tbl_stok left join tbl_obat on tbl_obat.id = tbl_stok.obat_id where tbl_stok.no_faktur = '+QuotedStr(edtFaktur.Text)+' and keterangan = '+QuotedStr('retur-penjualan')+'';
        Open;
      end;

    MessageDlg('Item Berhasil Di Retur',mtInformation,[mbok],0);
    fReturn.edtFaktur.Enabled := false;
    fReturn.btnSelesai.Enabled := True;
    fReturn.btnRetualAll.Enabled := false;
    fReturn.btnRetur.Enabled := False;
    Self.Close;
end;

end.
