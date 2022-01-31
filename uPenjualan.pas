unit uPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, Grids, DBGrids, ExtCtrls, DBCtrls,
  jpeg, U_cetak;

type
  TFpenjualan = class(TForm)
    grp2: TGroupBox;
    bvl1: TBevel;
    dbgrd1: TDBGrid;
    btnTambah: TBitBtn;
    btnKeluar: TBitBtn;
    grp1: TGroupBox;
    lbl6: TLabel;
    lbl1: TLabel;
    lbl3: TLabel;
    dtpTanggalBeli: TDateTimePicker;
    edtFaktur: TEdit;
    edtKode: TEdit;
    btnBantuObat: TBitBtn;
    btnSimpan: TBitBtn;
    btnHapus: TBitBtn;
    btnSelesai: TBitBtn;
    edtIdObat: TEdit;
    edtIdPembelian: TEdit;
    lbl8: TLabel;
    grp3: TGroupBox;
    lblItem: TLabel;
    grp4: TGroupBox;
    lblTotalHarga: TLabel;
    lbl2: TLabel;
    dblkcbbPelanggan: TDBLookupComboBox;
    edtHarga: TEdit;
    img1: TImage;
    btnProses: TBitBtn;
    btnCetak: TBitBtn;
    edtKembali: TEdit;
    edtBayar: TEdit;
    lbl4: TLabel;
    chkCetak: TCheckBox;
    edtStatusPenjualan: TEdit;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
    procedure btnBantuObatClick(Sender: TObject);
    procedure konek(status : string = 'kosong');
    procedure btnSimpanClick(Sender: TObject);
    procedure edtKodeKeyPress(Sender: TObject; var Key: Char);
    procedure dbgrd1KeyPress(Sender: TObject; var Key: Char);
    procedure btnHapusClick(Sender: TObject);
    procedure btnSelesaiClick(Sender: TObject);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure btnProsesClick(Sender: TObject);
    procedure btnCetakClick(Sender: TObject);
    procedure btnProsesPendingClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fpenjualan: TFpenjualan;
  kode, status, id_penjualan : string;

implementation

uses
  dataModule, StrUtils, uBantuObatPenjualan, uBayar, DateUtils;

{$R *.dfm}

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

procedure TFpenjualan.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TFpenjualan.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F1: btnTambah.Click;
    VK_F2: btnBantuObat.Click;
    VK_F5: btnSelesai.Click;
    VK_F6: btnHapus.Click;
    VK_F10: btnKeluar.Click;
  end;
end;

procedure TFpenjualan.FormShow(Sender: TObject);
begin
  edtFaktur.Clear; edtFaktur.Enabled := false;
  edtKode.Clear; edtKode.Enabled := false;
  dtpTanggalBeli.Enabled := false; dtpTanggalBeli.Date := Now;
  dblkcbbPelanggan.Enabled := false; dblkcbbPelanggan.KeyValue := 1;

  lblItem.Caption := '';
  lblTotalHarga.Caption := '';

  btnTambah.Enabled := True;
  btnKeluar.Enabled := true;
  btnTambah.Caption := 'Tambah[F1]';

  btnSelesai.Enabled := false;
  btnHapus.Enabled := false;
  
  btnBantuObat.Enabled := false;
  dbgrd1.Enabled := false;
  chkCetak.Enabled := false;
  konek;

  id_penjualan := 'kosong';
end;

procedure TFpenjualan.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption = 'Tambah[F1]' then
    begin
      dtpTanggalBeli.Enabled := True;
      dblkcbbPelanggan.Enabled := True;

      btnBantuObat.Enabled := True;

      edtFaktur.Text := 'PJ-'+FormatDateTime('ddmmyyyy',Now);
      btnTambah.Caption := 'Batal[F1]';
      btnKeluar.Enabled := false;
      dbgrd1.Enabled := True;

      chkCetak.Enabled := True;

      status := 'tambah';
    end
  else
    begin
      if MessageDlg('Apakah Transaksi Akan Dibatalkan ?',mtConfirmation,[mbyes,mbno],0)=mryes then
        begin
          with dm.qryPenjualan do
            begin
              close;
              sql.Clear;
              SQL.Text := 'select * from tbl_penjualan where id='+QuotedStr(id_penjualan)+'';
              Open;
            end;

          if dm.qryPenjualan.RecordCount > 0 then
            begin
              // hapus detail transaksi
              with dm.qryDetailPenjualan do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Text := 'delete from tbl_detail_penjualan where penjualan_id = '+QuotedStr(id_penjualan)+'';
                  ExecSQL;
                end;

              // hapus pembelian
              with dm.qryPenjualan do
                begin
                  close;
                  SQL.Clear;
                  SQL.Text := 'delete from tbl_penjualan where id='+QuotedStr(id_penjualan)+'';
                  ExecSQL;
                end;

              //hapus stok
              with dm.qryStok do
                begin
                  close;
                  SQL.Clear;
                  SQL.Text := 'delete from tbl_stok where no_faktur = '+QuotedStr(edtFaktur.Text)+'';
                  ExecSQL;
                end;
            end;

          MessageDlg('Transaksi Dibatalkan',mtInformation,[mbOk],0);
          FormShow(Sender);
        end;
    end;
end;

procedure TFpenjualan.btnBantuObatClick(Sender: TObject);
begin
  fBantuObatPenjualan.ShowModal;
end;

procedure TFpenjualan.konek(status: string);
begin
  with dm.qryRelasiPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select a.id as id_penjualan, a.no_faktur, a.tgl_penjualan, a.jumlah_item, '+
                  'a.total, b.id as id_detail_penjualan, b.obat_id, b.jumlah_jual, b.harga_jual, c.kode, c.barcode, '+
                  'c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, e.satuan, b.catatan from tbl_penjualan a left join '+
                  'tbl_detail_penjualan b on b.penjualan_id = a.id left join tbl_obat c on c.id = b.obat_id left join tbl_jenis d '+
                  'on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan where a.no_faktur='+QuotedStr(status)+'';
      open
    end;
end;

procedure TFpenjualan.btnSimpanClick(Sender: TObject);
var jmlEdit : string;
begin
  if btnSimpan.Caption = 'Simpan' then
    begin
      if status = 'tambah' then
        begin
          // simpan ke table pembelian
          with dm.qryPenjualan do
          begin
            close;
            SQL.Clear;
            SQL.Text := 'select * from tbl_penjualan where no_faktur like ''%'+FormatDateTime('yyyy',Now)+'%''';
            Open;

            if IsEmpty then
              begin
                kode := '00001';
              end
            else
              begin
                Last;
                kode := RightStr(fieldbyname('no_faktur').Text,5);
                kode := IntToStr(StrToInt(kode) + 1);
              end;
          end;

          edtFaktur.Text := 'PJ-'+FormatDateTime('ddmmyyyy',Now) + FormatFloat('00000',StrToInt(kode));
          with dm.qryPenjualan do
            begin
              Append;
              FieldByName('no_faktur').AsString := edtFaktur.Text;
              FieldByName('tgl_penjualan').AsDateTime := dtpTanggalBeli.DateTime;
              FieldByName('id_pelanggan').AsString := dblkcbbPelanggan.KeyValue;
              FieldByName('jumlah_item').AsString := '0';
              FieldByName('total').AsString := '0';
              FieldByName('user_id').AsString := dm.qryUser.fieldbyname('id').AsString;
              FieldByName('status').AsString := 'pending';
              Post;
            end;

            status := 'tambahLagi';
        end;

      if dm.qryPenjualan.Locate('no_faktur',edtFaktur.Text,[]) then id_penjualan := dm.qryPenjualan.fieldbyname('id').AsString;

      //cek stok
      

      //simpan ke tabel detail penjualan
      with dm.qryDetailPenjualan do
        begin
          close;
          sql.Clear;
          SQL.Text := 'select * from tbl_detail_penjualan where obat_id = '+QuotedStr(edtIdObat.Text)+' and penjualan_id = '+QuotedStr(id_penjualan)+'';
          Open;

          if IsEmpty then
            begin
              Append;
              FieldByName('penjualan_id').AsString := id_penjualan;
              FieldByName('obat_id').AsString := edtIdObat.Text;
              FieldByName('jumlah_jual').AsString := '1';
              FieldByName('harga_jual').AsString := edtHarga.Text;
              Post;
            end
          else
            begin
              jmlEdit := IntToStr(1 + fieldbyname('jumlah_jual').AsInteger);
              with dm.qryDetailPenjualan do
                begin
                  close;
                  sql.Clear;
                  SQL.Text := 'update tbl_detail_penjualan set jumlah_jual = '+QuotedStr(jmlEdit)+
                              ' where obat_id = '+QuotedStr(edtIdObat.Text)+' and penjualan_id = '+QuotedStr(id_penjualan)+'';
                  ExecSQL;
                end;

              status := 'tambahLagi';
            end;
        end;

      //stok
      with dm.qryStok do
        begin
          close;
          sql.Clear;
          SQL.Text := 'select * from tbl_stok where obat_id = '+QuotedStr(edtIdObat.Text)+' and no_faktur = '+QuotedStr(edtFaktur.Text)+'';
          Open;

          if IsEmpty then
            begin
              Append;
              FieldByName('no_faktur').AsString  := edtFaktur.Text;
              FieldByName('obat_id').AsString    := edtIdObat.Text;
              FieldByName('jumlah').AsString     := '1';
              FieldByName('harga').AsString      := edtHarga.Text;
              FieldByName('keterangan').AsString := 'penjualan';
              Post;
            end
          else
            begin
              jmlEdit := IntToStr(1 + dm.qryStok.fieldbyname('jumlah').AsInteger);
            
              close;
              sql.Clear;
              SQL.Text := 'update tbl_stok set jumlah = '+QuotedStr(jmlEdit)+' where no_faktur = '+QuotedStr(edtFaktur.Text)+'';
              ExecSQL; 
            end;      
        end;

      konek(edtFaktur.Text);
      lblItem.Caption := IntToStr(hitungItem(id_penjualan));
      lblTotalHarga.Caption := FormatFloat('Rp. ###,###,###', hitungTotal(id_penjualan));

      btnSelesai.Enabled := True;
      btnTambah.Caption := 'Batal';
      btnHapus.enabled := false;

      dtpTanggalBeli.Enabled := false;
      dblkcbbPelanggan.Enabled := false;
    end
  else
    begin
      edtHarga.Enabled := True;

      btnSimpan.Caption := 'Simpan';
      btnHapus.Caption := 'Batal[F1]';
      status := 'edit';
    end;  
end;

procedure TFpenjualan.edtKodeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    begin
      // barcode
      //cari item
      //simpan clik
    end;
end;

procedure TFpenjualan.dbgrd1KeyPress(Sender: TObject; var Key: Char);
var jumlahNew : Integer;
    totalNew : Real;
    id,catatan : string;
begin
  if key=#13 then
    begin
      //edit data lewat dbgrid
      jumlahNew := dbgrd1.Fields[3].AsInteger;
      catatan := dbgrd1.Fields[16].AsString;
      id := dbgrd1.Fields[5].AsString;

      with dm.qryDetailPenjualan do
        begin
          close;
          sql.Clear;
          SQL.Text := 'update tbl_detail_penjualan set jumlah_jual = '+QuotedStr(IntToStr(jumlahNew))+', catatan = '+QuotedStr(catatan)+
                      ' where obat_id = '+QuotedStr(dbgrd1.Fields[6].AsString)+' and penjualan_id = '+QuotedStr(dbgrd1.Fields[0].AsString)+'';
          ExecSQL;
        end;

      // stok
      with dm.qryStok do
        begin
          close;
          sql.Clear;
          SQL.Text := 'update tbl_stok set jumlah = '+QuotedStr(IntToStr(jumlahNew))+' where obat_id = '+QuotedStr(dbgrd1.Fields[6].AsString)+' and no_faktur = '+QuotedStr(dbgrd1.Fields[1].AsString)+'';
          ExecSQL;
        end;

      konek(edtFaktur.Text);

      lblItem.Caption := IntToStr(hitungItem(id_penjualan));
      lblTotalHarga.Caption := FormatFloat('Rp. ###,###,###', hitungTotal(id_penjualan));

      btnSelesai.Enabled := True;
      btnTambah.Caption := 'Batal';
      btnHapus.enabled := false;

      dm.qryRelasiPenjualan.Locate('id_detail_penjualan',id,[]);
    end;
end;
procedure TFpenjualan.btnHapusClick(Sender: TObject);
begin
  if MessageDlg('Yakin Data Akan Dihapus ?',mtConfirmation,[mbYes,mbNo],0)=mryes then
    begin
      with dm.qryDetailPenjualan do
        begin
          Close;
          SQL.Clear;
          SQL.Text := 'delete from tbl_detail_penjualan where penjualan_id = '+QuotedStr(edtIdPembelian.Text)+' and obat_id = '+QuotedStr(edtIdObat.Text)+'';
          ExecSQL;
        end;

      MessageDlg('Item Berhasil Dihapus',mtInformation,[mbOK],0);
      konek(edtFaktur.Text);
      lblItem.Caption := IntToStr(hitungItem(id_penjualan));
      lblTotalHarga.Caption := FormatFloat('Rp. ###,###,###', hitungTotal(id_penjualan));
      
      edtKode.Clear;
      btnHapus.Enabled := false;

      if dm.qryDetailPenjualan.IsEmpty then
        btnSelesai.Enabled := false
      else
        btnSimpan.Enabled := true;
    end;
end;

procedure TFpenjualan.btnSelesaiClick(Sender: TObject);
begin
  fBayar.edtTtlBayar.Text := FloatToStr(hitungTotal(id_penjualan));
  fBayar.edtTotalBayar.Text := FloatToStr(hitungTotal(id_penjualan));

  fBayar.edtBayar.Text := '0';
  fBayar.edtByar.Text := '0';

  fBayar.edtKembalian.Text := '0';
  fBayar.edtKmbalian.Text := '0';

  fBayar.ShowModal;
end;

procedure TFpenjualan.dbgrd1CellClick(Column: TColumn);
begin
 if dm.qryRelasiPenjualan.IsEmpty then Exit;

  edtKode.Text := dbgrd1.Fields[8].AsString;
  edtIdObat.Text := dbgrd1.Fields[6].AsString;
  edtIdPembelian.Text := dbgrd1.Fields[0].AsString;
  btnHapus.Enabled := True;
end;

procedure TFpenjualan.btnProsesClick(Sender: TObject);
var
  jumlahItem, total : string;
  a : integer;
begin
  if MessageDlg('Apakah Transaksi Akan Diselesaikan ?',mtConfirmation,[mbYes,mbno],0)=mryes then
    begin
      jumlahItem := IntToStr(hitungItem(id_penjualan));
      total := FloatToStr(hitungTotal(id_penjualan));

      with dm.qryPenjualan do
        begin
          close;
          sql.Clear;
          sql.Text := 'update tbl_penjualan set jumlah_item = '+QuotedStr(jumlahItem)+', total = '+QuotedStr(total)+
                      ', status = '+QuotedStr(edtStatusPenjualan.Text)+', tgl_bayar = '+QuotedStr(FormatDateTime('yyyy-mm-dd hh:mm:ss',Now))+
                      ' where no_faktur = '+QuotedStr(edtFaktur.Text)+'';
          ExecSQL;
        end;

      with dm.qryDetailPenjualan do
        begin
          Close;
          SQL.Clear;
          SQL.Text := 'select * from tbl_detail_penjualan where penjualan_id = '+QuotedStr(id_penjualan)+'';
          Open;

          for a:=1 to RecordCount do
            begin
              RecNo := a;

              with dm.qryObat do
                begin
                  close;
                  SQL.Clear;
                  SQL.Text := 'select * from tbl_obat';
                  Open;
                  
                  if locate('id',dm.qryDetailPenjualan.fieldbyname('obat_id').AsString,[]) then
                    begin
                      Edit;
                      FieldByName('stok').AsInteger := fieldbyname('stok').AsInteger - dm.qryDetailPenjualan.fieldbyname('jumlah_jual').AsInteger;
                      Post;
                    end;
                end;

              Next;
            end;
        end;

      with dm.qrySetting do
          begin
            close;
            sql.Clear;
            SQL.Text := 'select * from tbl_setting';
            Open;
          end;

      //if dm.qrySetting.FieldByName('cetak').AsString = '1' then btnCetak.Click;
      if chkCetak.Checked = True then btnCetak.Click;

      FormShow(Sender);
    end;
end;

procedure TFpenjualan.btnCetakClick(Sender: TObject);
var
txtFile: TextFile;
nmfile, status : string;
a, total : Integer;
begin
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
      SQL.Text := 'select * from tbl_penjualan where id = '+QuotedStr(edtIdPembelian.Text)+'';
      Open;
    end;

  if dm.qryPenjualan.FieldByName('status').AsString = 'selesai' then status := 'Lunas' else status := 'Kredit';

    // Buat File dengan Nama Struk.txt
    nmfile := GetCurrentDir + '\struk.txt';
    AssignFile(txtFile, nmfile);
    Rewrite(txtFile);
    WriteLn(txtFile, '     '+dm.qrySetting.fieldbyname('nama_toko').asString+'   ');
    WriteLn(txtFile, ''+dm.qrySetting.fieldbyname('alamat').asString+' ');
    WriteLn(txtFile, '        '+dm.qrySetting.fieldbyname('telp').asString+' ');
    WriteLn(txtFile, '    Tersedia Obat-Obatan');
    WriteLn(txtFile, '      Herbal dan Alkes');

    WriteLn(txtFile, '----------------------------');
    WriteLn(txtFile, 'No. Nota:' + edtFaktur.text );
    WriteLn(txtFile, 'Tanggal :' + FormatDateTime('dd/mm/yyyy hh:mm:ss', now));
    WriteLn(txtFile, 'Kasir   :' + dm.qryUser.fieldbyname('nama').asString);
    WriteLn(txtFile, 'Status Jual :' + status);
    WriteLn(txtFile, '----------------------------');
    WriteLn(txtFile, 'Nama Barang');
    WriteLn(txtFile, RataKanan('      QTY   Harga ', 'Sub Total', 28, ' '));
    WriteLn(txtFile, '----------------------------');

    a := 1;
    with dm.qryRelasiPenjualan do
      begin
        for a:=1 to RecordCount do
          begin
            RecNo := a;
            total := fieldbyname('jumlah_jual').AsInteger * fieldbyname('harga_jual').AsInteger;

            WriteLn(txtFile,' '+fieldbyname('nama_obat').asString);
            WriteLn(txtFile, RataKanan
                ('      ' + fieldbyname('jumlah_jual').asString +' X '+FormatFloat('###,###,###',fieldbyname('harga_jual').AsInteger)+' ',FormatFloat('###,###,###',total), 28, ' '));

            Next;
          end;
      end;

    WriteLn(txtFile, '----------------------------');
    WriteLn(txtFile, RataKanan('Total   : ', FormatFloat('Rp. ###,###,###', hitungTotal(id_penjualan)), 28,
         ' '));
    WriteLn(txtFile, RataKanan('Bayar   : ', FormatFloat('Rp. ###,###,###', StrToInt(edtBayar.Text)), 28,
         ' '));
    WriteLn(txtFile, RataKanan('Kembali : ', FormatFloat('Rp. ###,###,###', StrToInt(edtKembali.Text)), 28,
         ' '));
    WriteLn(txtFile, '----------------------------');
    WriteLn(txtFile, ' Jumlah Item  : ' + IntToStr(hitungItem(id_penjualan)));
    WriteLn(txtFile, '----------------------------');
    WriteLn(txtFile, '         Terima Kasih');
    WriteLn(txtFile, '    Berelaan Jual Seadannya');
    WriteLn(txtFile, #13 + #10 + #13 + #10 + #13 + #10 + #13 + #10 );
    CloseFile(txtFile);
    // Cetak File Struk.txt
    cetakFile('struk.txt');
end;

procedure TFpenjualan.btnProsesPendingClick(Sender: TObject);
var
  jumlahItem, total : string;
  a : integer;
begin
  if MessageDlg('Apakah Transaksi Akan DiPending?',mtConfirmation,[mbYes,mbno],0)=mryes then
    begin
      jumlahItem := IntToStr(hitungItem(id_penjualan));
      total := FloatToStr(hitungTotal(id_penjualan));

      with dm.qryPenjualan do
        begin
          close;
          sql.Clear;
          sql.Text := 'update tbl_penjualan set jumlah_item = '+QuotedStr(jumlahItem)+', total = '+QuotedStr(total)+
                      ', status = '+QuotedStr('pending')+', tgl_bayar = '+QuotedStr(FormatDateTime('yyyy-mm-dd hh:mm:ss',Now))+
                      ' where no_faktur = '+QuotedStr(edtFaktur.Text)+'';
          ExecSQL;
        end;

      with dm.qryDetailPenjualan do
        begin
          Close;
          SQL.Clear;
          SQL.Text := 'select * from tbl_detail_penjualan where penjualan_id = '+QuotedStr(id_penjualan)+'';
          Open;

          for a:=1 to RecordCount do
            begin
              RecNo := a;

              with dm.qryObat do
                begin
                  close;
                  SQL.Clear;
                  SQL.Text := 'select * from tbl_obat';
                  Open;
                  
                  if locate('id',dm.qryDetailPenjualan.fieldbyname('obat_id').AsString,[]) then
                    begin
                      Edit;
                      FieldByName('stok').AsInteger := fieldbyname('stok').AsInteger - dm.qryDetailPenjualan.fieldbyname('jumlah_jual').AsInteger;
                      Post;
                    end;
                end;

              Next;
            end;
        end;

      with dm.qrySetting do
          begin
            close;
            sql.Clear;
            SQL.Text := 'select * from tbl_setting';
            Open;
          end;
          
      FormShow(Sender);
    end;
end;

end.
