unit u_returAllPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfReturAllPembelian = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    edtFaktur: TEdit;
    edtKodeRetur: TEdit;
    edtIdPembelian: TEdit;
    grp2: TGroupBox;
    lbl9: TLabel;
    mmoAlasan: TMemo;
    btnTambah: TBitBtn;
    btnKeluar: TBitBtn;
    procedure btnKeluarClick(Sender: TObject);
    procedure mmoAlasanChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fReturAllPembelian: TfReturAllPembelian;

implementation

uses dataModule, uReturn, u_returPembelian;

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

procedure TfReturAllPembelian.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfReturAllPembelian.mmoAlasanChange(Sender: TObject);
begin
  upperCase(Sender);
end;

procedure TfReturAllPembelian.FormShow(Sender: TObject);
begin
  mmoAlasan.Clear;
  mmoAlasan.SetFocus;
end;

procedure TfReturAllPembelian.btnTambahClick(Sender: TObject);
var kode, sqll, sql2, idRetur : string;
    a : Integer;
begin
  // simpan tbl_retur dan tbl_stok
  // simpan tbl_retur
  with dm.qryRetur do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'update tbl_retur set faktur_penjualan = '+QuotedStr(edtFaktur.Text)+' where kode = '+QuotedStr(edtKodeRetur.Text)+'';
      ExecSQL;

      close;
      SQL.Clear;
      SQL.Text := 'select * from tbl_retur where kode = '+QuotedStr(edtKodeRetur.Text)+'';
      Open;

      idRetur := fieldbyname('id').AsString;
    end;

  with dm.qryDetailPembelian do
    begin
      close;
      sql.Clear;
      sql.Text := 'select * from tbl_detail_pembelian where pembelian_id = '+QuotedStr(edtIdPembelian.Text)+'';
      Open;

      if IsEmpty then
        begin
          MessageDlg('Item Tidak Ada',mtInformation,[mbOK],0);
          Exit;
        end
      else
        begin
          sqll := '';
          sql2 := '';

          for a:=1 to RecordCount do
            begin
              RecNo := a;

              sqll := sqll + '('+QuotedStr(edtFaktur.Text)+', '+QuotedStr(fieldbyname('obat_id').AsString)+', '+QuotedStr(fieldbyname('jumlah_beli').AsString)+', '+QuotedStr(fieldbyname('harga_beli').AsString)+
                     ', '+QuotedStr('retur-pembelian')+', '+QuotedStr(mmoAlasan.Text)+'),';

              sql2 := sql2 + '('+QuotedStr(idRetur)+', '+QuotedStr(fieldbyname('obat_id').AsString)+', '+QuotedStr(fieldbyname('harga_beli').AsString)+', '+QuotedStr(fieldbyname('jumlah_beli').AsString)+
                     ', '+QuotedStr(fieldbyname('jumlah_beli').AsString)+', '+QuotedStr('retur-pembelian')+', '+QuotedStr(mmoAlasan.Text)+'),';
            end;

          System.Delete(sqll,Length(sqll),1);
          System.Delete(sql2,Length(sql2),1);

          with dm.qryStok do
            begin
              close;
              sql.Clear;
              SQL.Text := 'insert into tbl_stok (no_faktur, obat_id, jumlah, harga, keterangan, alasan) values '+sqll;
              ExecSQL;
            end;

          with dm.qryDetailReturTable do
            begin
              close;
              sql.Clear;
              SQL.Text := 'insert into tbl_detail_retur (retur_id, obat_id, harga_retur, jumlah_retur, jumlah_item, status, catatan) values '+sql2;
              ExecSQL;
            end;
        end;

        with dm.qryDtlRetur do
          begin
            Close;
            SQL.Clear;
            SQL.Text := 'select * from tbl_retur a left join tbl_detail_retur b on b.retur_id = a.id inner join tbl_obat c on c.id = b.obat_id where a.faktur_penjualan = '+QuotedStr(edtFaktur.Text)+'';
            Open;
          end;

        MessageDlg('Item Berhasil Diretur',mtInformation,[mbOK],0);
        fReturPembelian.btnRetualAll.Enabled := false;
        fReturPembelian.btnSelesai.Enabled := True;
        fReturPembelian.edtFaktur.Enabled := False;
        
        Self.Close;
    end;
end;
end.
