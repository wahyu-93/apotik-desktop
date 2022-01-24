unit u_confirmReturAll;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons;

type
  TfReturAll = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    lbl9: TLabel;
    mmoAlasan: TMemo;
    btnTambah: TBitBtn;
    btnKeluar: TBitBtn;
    img1: TImage;
    edtFaktur: TEdit;
    edtKodeRetur: TEdit;
    edtIdPenjualan: TEdit;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mmoAlasanChange(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fReturAll: TfReturAll;

implementation

uses
  dataModule, ADODB, DB, uReturn;

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

procedure TfReturAll.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfReturAll.FormShow(Sender: TObject);
begin
  mmoAlasan.Clear;
  mmoAlasan.SetFocus;
end;

procedure TfReturAll.mmoAlasanChange(Sender: TObject);
begin
  upperCase(Sender);
end;

procedure TfReturAll.btnTambahClick(Sender: TObject);
var kode, sqll, newSql : string;
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
    end;

  with dm.qryDetailPenjualan do
    begin
      close;
      sql.Clear;
      sql.Text := 'select * from tbl_detail_penjualan where penjualan_id = '+QuotedStr(edtIdPenjualan.Text)+'';
      Open;

      if IsEmpty then
        begin
          MessageDlg('Item Tidak Ada',mtInformation,[mbOK],0);
          Exit;
        end
      else
        begin
          sqll := '';

          for a:=1 to RecordCount do
            begin
              RecNo := a;

              sqll := sqll + '('+QuotedStr(edtFaktur.Text)+', '+QuotedStr(fieldbyname('obat_id').AsString)+', '+QuotedStr(fieldbyname('jumlah_jual').AsString)+', '+QuotedStr(fieldbyname('harga_jual').AsString)+
                     ', '+QuotedStr('retur-penjualan')+', '+QuotedStr(mmoAlasan.Text)+'),';
            end;

          System.Delete(sqll,Length(sqll),1);
          with dm.qryStok do
            begin
              close;
              sql.Clear;
              SQL.Text := 'insert into tbl_stok (no_faktur, obat_id, jumlah, harga, keterangan, alasan) values '+sqll;
              ExecSQL;
            end; 
        end;

        with dm.qryRelasiReturObat do
          begin
            Close;
            SQL.Clear;
            SQL.Text := 'select * from tbl_stok left join tbl_obat on tbl_obat.id = tbl_stok.obat_id where tbl_stok.no_faktur = '+QuotedStr(edtFaktur.Text)+' and keterangan = '+QuotedStr('retur-penjualan')+'';
            Open;
          end;

        MessageDlg('Item Berhasil Diretur',mtInformation,[mbOK],0);
        fReturn.btnRetualAll.Enabled := false;
        fReturn.btnSelesai.Enabled := True;
        
        Self.Close;
    end;
end;

end.
