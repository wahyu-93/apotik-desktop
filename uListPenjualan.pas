unit uListPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls, U_cetak;

type
  TfListPenjualan = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnKeluar: TBitBtn;
    btnDetail: TBitBtn;
    btnCetak: TBitBtn;
    btnProsesCetak: TBitBtn;
    btnBayar: TBitBtn;
    procedure btnKeluarClick(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnDetailClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure btnCetakClick(Sender: TObject);
    procedure btnProsesCetakClick(Sender: TObject);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure btnBayarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fListPenjualan: TfListPenjualan;

implementation

uses
  dataModule, uDetailPenjualan, u_bayarPenjualan;

{$R *.dfm}

function hitungTotal(id_penjualan : string) : Real;
var
  i : Integer;
  total : Real;
begin
  with dm.qryDetailPenjualan do
    begin
      close;
      SQL.Clear;
      SQL.Text := 'select * from tbL_detail_penjualan where penjualan_id = '+QuotedStr(id_penjualan)+'';
      Open;

      total := 0;
      for i:=1 to RecordCount do
        begin
          RecNo := i;
          total := total + (fieldbyname('jumlah_jual').AsInteger * fieldbyname('harga_jual').AsInteger);

          Next;
        end;

      Result := total;
    end;
end;

function hitungItem(id_penjualan : string) : Integer;
begin
  with dm.qryDetailPenjualan do
    begin
      close;
      SQL.Clear;
      SQL.Text := 'select * from tbL_detail_penjualan where penjualan_id = '+QuotedStr(id_penjualan)+'';
      Open;

      Result := RecordCount;
    end;
end;

procedure konek;
begin
  with dm.qryListPenjualan do
    begin
      close;
      sql.Clear;
      sql.Text := 'select a.id as id_pelanggan, a.jenis_pelanggan, b.id as id_penjualan, b.no_faktur, b.tgl_penjualan, '+
                  'b.jumlah_item, b.total, b.status, b.tgl_bayar, c.id as id_user, c.nama, c.role from tbl_pelanggan a left join tbl_penjualan b '+
                  'on b.id_pelanggan = a.id inner JOIN tbl_user c on c.id = b.user_id where month(tgl_penjualan) = '+QuotedStr(FormatDateTime('mm-yyyy',Now))+' order by b.id desc, b.status desc';
      Open;
    end;
end;

procedure TfListPenjualan.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfListPenjualan.edtpencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with dm.qryListPenjualan do
    begin
      Close;
      SQL.Clear;
      sql.Text := 'select a.id as id_pelanggan, a.jenis_pelanggan, b.id as id_penjualan, b.no_faktur, b.tgl_penjualan, b.jumlah_item, '+
                  'b.total, b.status, b.tgl_bayar, c.id as id_user, c.nama, c.role from tbl_pelanggan a left join tbl_penjualan b '+
                  'on b.id_pelanggan = a.id inner JOIN tbl_user c on c.id = b.user_id where b.no_faktur = '+QuotedStr(edtpencarian.Text)+' order by b.id asc';
      Open;
    end;
end;

procedure TfListPenjualan.FormShow(Sender: TObject);
begin
  konek;
  edtpencarian.Clear;
end;

procedure TfListPenjualan.btnDetailClick(Sender: TObject);
begin
  if dbgrd1.Fields[0].AsString = '' then Exit;

  fDetailPenjualan.edtFaktur.Text := dbgrd1.Fields[1].AsString;
  fDetailPenjualan.ShowModal;
end;

procedure TfListPenjualan.dbgrd1DblClick(Sender: TObject);
begin
  btnDetail.Click;
end;

procedure TfListPenjualan.btnCetakClick(Sender: TObject);
begin
  if dbgrd1.Fields[0].AsString = '' then Exit;
  btnProsesCetak.Click;  
end;

procedure TfListPenjualan.btnProsesCetakClick(Sender: TObject);
var
Enter : string;
txtFile: TextFile;
nmfile, status : string;
a, total : Integer;
begin
  Enter := #13 + #10;
  with dm.qrySetting do
    begin
      Close;
      sql.Clear;
      sql.Text := 'select * from tbl_setting';
      Open;
    end;

  with dm.qryPenjualan do
    begin
      Close;
      sql.Clear;
      SQL.Text := 'select * from tbl_penjualan where id = '+QuotedStr(dbgrd1.Fields[0].AsString)+'';
      Open;
    end;

  with dm.qryRelasiPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select a.id as id_penjualan, a.no_faktur, a.tgl_penjualan, a.jumlah_item, '+
                  'a.total, b.id as id_detail_penjualan, b.obat_id, b.jumlah_jual, b.harga_jual, c.kode, c.barcode, '+
                  'c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, e.satuan, b.catatan from tbl_penjualan a left join '+
                  'tbl_detail_penjualan b on b.penjualan_id = a.id left join tbl_obat c on c.id = b.obat_id left join tbl_jenis d '+
                  'on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan where a.no_faktur='+QuotedStr(dbgrd1.Fields[1].AsString)+'';
      open
    end;

  if (dm.qryPenjualan.FieldByName('status').AsString = 'selesai') or (dm.qryPenjualan.FieldByName('status').AsString = 'selesai-retur') then status := 'Lunas' else status := 'Kredit';

  if dm.qrySetting.FieldByName('kertas').AsString = '80' then
   begin
     ShowMessage('80');
      // Buat File dengan Nama Struk.txt
      nmfile := GetCurrentDir + '\struk.txt';
      AssignFile(txtFile, nmfile);
      Rewrite(txtFile);

      WriteLn(txtFile, RataTengah(dm.qrySetting.FieldByName('nama_toko').AsString, 32));
      WriteLn(txtFile, RataTengah(dm.qrySetting.FieldByName('alamat').AsString, 32));
      WriteLn(txtFile, RataTengah('Telp: ' + dm.qrySetting.FieldByName('telp').AsString, 32));
      WriteLn(txtFile, RataTengah('Tersedia Obat-Obatan',32));
      WriteLn(txtFile, RataTengah('Herbal dan Alkes',32));

      WriteLn(txtFile, '---------------------------------');
      WriteLn(txtFile, 'No. Nota:' + dbgrd1.Fields[1].AsString );
      WriteLn(txtFile, 'Tanggal :' + FormatDateTime('dd/mm/yyyy hh:mm:ss', now));
      WriteLn(txtFile, 'Kasir   :' + dm.qryUser.fieldbyname('nama').asString);
      WriteLn(txtFile, 'Status Jual :' + status);
      WriteLn(txtFile, '---------------------------------');
      WriteLn(txtFile, 'Nama Barang');
      WriteLn(txtFile, RataKanan('      QTY   Harga ', 'Sub Total', 32, ' '));
      WriteLn(txtFile, '---------------------------------');

      a := 1;
      with dm.qryRelasiPenjualan do
        begin
          for a:=1 to RecordCount do
            begin
              RecNo := a;
              total := fieldbyname('jumlah_jual').AsInteger * fieldbyname('harga_jual').AsInteger;

              WriteLn(txtFile,' '+fieldbyname('nama_obat').asString);
              WriteLn(txtFile, RataKanan
                  ('      ' + fieldbyname('jumlah_jual').asString +' X '+FormatFloat('###,###,###',fieldbyname('harga_jual').AsInteger)+' ',FormatFloat('###,###,###',total), 32, ' '));

              Next;
            end;
        end;

      WriteLn(txtFile, '---------------------------------');
      WriteLn(txtFile, RataKanan('Total   : ', FormatFloat('Rp. ###,###,###', hitungTotal(dbgrd1.Fields[0].AsString)), 32,
           ' '));
      WriteLn(txtFile, '---------------------------------');
      WriteLn(txtFile, ' Jumlah Item  : ' + IntToStr(hitungItem(dbgrd1.Fields[0].AsString)));
      WriteLn(txtFile, '---------------------------------');
      WriteLn(txtFile, RataTengah('Terima Kasih',32));
      WriteLn(txtFile, RataTengah('Berelaan Jual Seadanya',32));
      WriteLn(txtFile, RataTengah('Semoga Lekas Sembuh',32));
      
      WriteLn(txtFile, Enter + Enter + Enter + Enter + Enter + Enter + Enter + Enter + Enter + Enter );
      CloseFile(txtFile);
   end
  else
    begin
      ShowMessage('58');
      nmfile := GetCurrentDir + '\struk.txt';
      AssignFile(txtFile, nmfile);
      Rewrite(txtFile);

      Write(txtFile, Chr(27) + 'a' + Chr(0));
      WriteLn(txtFile, RataTengah(dm.qrySetting.FieldByName('nama_toko').AsString, 32));
      WriteLn(txtFile, RataTengah(dm.qrySetting.FieldByName('alamat').AsString, 32));
      WriteLn(txtFile, RataTengah('Telp: ' + dm.qrySetting.FieldByName('telp').AsString, 32));
      WriteLn(txtFile, RataTengah('Tersedia Obat-Obatan',32));
      WriteLn(txtFile, RataTengah('Herbal dan Alkes',32));

      WriteLn(txtFile, StringOfChar('-', 32));
      WriteLn(txtFile, 'No. Nota:' + dbgrd1.Fields[1].AsString );
      WriteLn(txtFile, 'Tanggal :' + FormatDateTime('dd/mm/yyyy hh:mm:ss', now));
      WriteLn(txtFile, 'Kasir   :' + dm.qryUser.fieldbyname('nama').asString);
      WriteLn(txtFile, 'Status Jual :' + status);
      WriteLn(txtFile, '---------------------------------');
      WriteLn(txtFile, 'Nama Barang');
      WriteLn(txtFile, RataKanan('      QTY   Harga ', 'Sub Total', 32, ' '));
      WriteLn(txtFile, StringOfChar('-', 32));

      a := 1;
      with dm.qryRelasiPenjualan do
        begin
          for a:=1 to RecordCount do
            begin
              RecNo := a;
              total := fieldbyname('jumlah_jual').AsInteger * fieldbyname('harga_jual').AsInteger;

              WriteLn(txtFile,' '+fieldbyname('nama_obat').asString);
              WriteLn(txtFile, RataKanan
                  ('      ' + fieldbyname('jumlah_jual').asString +' X '+FormatFloat('###,###,###',fieldbyname('harga_jual').AsInteger)+' ',FormatFloat('###,###,###',total), 32, ' '));

              Next;
            end;
        end;

      WriteLn(txtFile, StringOfChar('-', 32));
      WriteLn(txtFile, RataKanan('Total   : ', FormatFloat('Rp. ###,###,###', hitungTotal(dbgrd1.Fields[0].AsString)), 32,
           ' '));
      WriteLn(txtFile, StringOfChar('-', 32));
      WriteLn(txtFile, ' Jumlah Item  : ' + IntToStr(hitungItem(dbgrd1.Fields[0].AsString)));
      WriteLn(txtFile, StringOfChar('-', 32));;
      WriteLn(txtFile, RataTengah('Terima Kasih',32));
      WriteLn(txtFile, RataTengah('Berelaan Jual Seadanya',32));
      WriteLn(txtFile, RataTengah('Semoga Lekas Sembuh',32));

      WriteLn(txtFile, Enter);
      CloseFile(txtFile);
    end;

    // Cetak File Struk.txt
    cetakFile('struk.txt');
    
    MessageDlg('Cetak Struk Sukses',mtInformation,[mbOK],0);
end;

procedure TfListPenjualan.dbgrd1CellClick(Column: TColumn);
begin
  if (dbgrd1.Fields[7].AsString = 'selesai') or (dbgrd1.Fields[7].AsString = 'selesai-retur') then
    btnBayar.Visible := False
  else
    btnBayar.Visible := True;
end;

procedure TfListPenjualan.btnBayarClick(Sender: TObject);
begin
  fBayarPenjualan.edtIdPenjualan.Text := dbgrd1.Fields[0].AsString;
  fBayarPenjualan.lblTotalDibayar.Caption := FormatFloat('Rp. ###,###,###', dbgrd1.Fields[5].AsFloat);

  fBayarPenjualan.ShowModal;
end;

end.
