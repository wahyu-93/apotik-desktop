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
    procedure AdjustBatchFIFO(ObatID, JumlahBaru, PenjualanID: Integer);
    procedure KembalikanBatchSebagian(ObatID, JumlahKembali, PenjualanID: Integer);
    procedure KembalikanBatch(PenjualanID: Integer);
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
  dataModule, StrUtils, uBantuObatPenjualan, uBayar, DateUtils, ADODB;

{$R *.dfm}

procedure TFpenjualan.AdjustBatchFIFO(ObatID, JumlahBaru, PenjualanID: Integer);
var
  qryCek    : TADOQuery;
  qryBatch  : TADOQuery;
  qryUpdate : TADOQuery;
  qryLog    : TADOQuery;
  JumlahLama, Delta, SisaKurangi, Ambil, BatchID, SisaBatch: Integer;
begin
  qryCek    := TADOQuery.Create(nil);
  qryBatch  := TADOQuery.Create(nil);
  qryUpdate := TADOQuery.Create(nil);
  qryLog    := TADOQuery.Create(nil);

  try
    qryCek.Connection    := dm.con1;
    qryBatch.Connection  := dm.con1;
    qryUpdate.Connection := dm.con1;
    qryLog.Connection    := dm.con1;

    // cek sudah berapa yang tercatat untuk penjualan + obat ini
    qryCek.SQL.Text :=
      'SELECT COALESCE(SUM(pb.jumlah), 0) AS total_tercatat ' +
      'FROM tbl_penjualan_batch pb ' +
      'JOIN tbl_batch b ON b.id = pb.batch_id ' +
      'WHERE pb.penjualan_id = ' + IntToStr(PenjualanID) +
      '  AND b.obat_id = ' + IntToStr(ObatID);
    qryCek.Open;
    JumlahLama := qryCek.FieldByName('total_tercatat').AsInteger;

    Delta := JumlahBaru - JumlahLama;

    // tidak ada perubahan, skip
    if Delta = 0 then Exit;

    if Delta > 0 then
    begin
      // jumlah bertambah — kurangi batch sejumlah delta
      SisaKurangi := Delta;

      qryBatch.SQL.Text :=
        'SELECT id, jumlah_sisa FROM tbl_batch ' +
        'WHERE obat_id = ' + IntToStr(ObatID) +
        '  AND jumlah_sisa > 0 ' +
        '  AND status = 1 ' +
        'ORDER BY tgl_expired ASC';
      qryBatch.Open;

      if qryBatch.IsEmpty then Exit;

      while (not qryBatch.Eof) and (SisaKurangi > 0) do
        begin
          BatchID   := qryBatch.FieldByName('id').AsInteger;
          SisaBatch := qryBatch.FieldByName('jumlah_sisa').AsInteger;

          if SisaBatch >= SisaKurangi then
            Ambil := SisaKurangi
          else
            Ambil := SisaBatch;

          // kurangi jumlah_sisa
          qryUpdate.SQL.Text :=
            'UPDATE tbl_batch SET jumlah_sisa = jumlah_sisa - ' + IntToStr(Ambil) +
            ' WHERE id = ' + IntToStr(BatchID);
          qryUpdate.ExecSQL;

          // status otomatis menyesuaikan sisa
          qryUpdate.SQL.Text :=
            'UPDATE tbl_batch SET status = CASE WHEN jumlah_sisa = 0 THEN 0 ELSE 1 END' +
            ' WHERE id = ' + IntToStr(BatchID);
          qryUpdate.ExecSQL;

          qryLog.SQL.Text :=
            'INSERT INTO tbl_penjualan_batch ' +
            '(penjualan_id, batch_id, jumlah, is_estimasi, created_at) VALUES (' +
            IntToStr(PenjualanID) + ', ' +
            IntToStr(BatchID)     + ', ' +
            IntToStr(Ambil)       + ', 1, NOW())';
          qryLog.ExecSQL;

          SisaKurangi := SisaKurangi - Ambil;
          qryBatch.Next;
        end;
    end
    else
      begin
        // jumlah berkurang — kembalikan batch sejumlah abs(delta)
        // pakai procedure KembalikanSebagian yang akan kita buat
        KembalikanBatchSebagian(ObatID, Abs(Delta), PenjualanID);
      end;

  except
    // ditelan
  end;

  qryCek.Free;
  qryBatch.Free;
  qryUpdate.Free;
  qryLog.Free;
end;

procedure TFpenjualan.KembalikanBatchSebagian(ObatID, JumlahKembali, PenjualanID: Integer);
var
  qryLog    : TADOQuery;
  qryUpdate : TADOQuery;
  SisaKembali, Ambil, BatchID, JumlahTercatat: Integer;
begin
  SisaKembali := JumlahKembali;

  qryLog    := TADOQuery.Create(nil);
  qryUpdate := TADOQuery.Create(nil);

  try
    qryLog.Connection    := dm.con1;
    qryUpdate.Connection := dm.con1;

    // ambil log batch untuk penjualan+obat ini, urut expired terjauh dulu
    // (kembalikan ke batch yang paling jauh expirednya duluan — kebalikan FIFO)
    qryLog.SQL.Text :=
      'SELECT pb.id, pb.batch_id, pb.jumlah, ' +
      '(SELECT tgl_expired FROM tbl_batch WHERE id = pb.batch_id) AS tgl_exp ' +
      'FROM tbl_penjualan_batch pb ' +
      'WHERE pb.penjualan_id = ' + IntToStr(PenjualanID) +
      '  AND pb.batch_id IN (' +
      '    SELECT id FROM tbl_batch WHERE obat_id = ' + IntToStr(ObatID) +
      '  ) ' +
      'ORDER BY tgl_exp DESC';
    qryLog.Open;

    while (not qryLog.Eof) and (SisaKembali > 0) do
    begin
      BatchID        := qryLog.FieldByName('batch_id').AsInteger;
      JumlahTercatat := qryLog.FieldByName('jumlah').AsInteger;

      if JumlahTercatat >= SisaKembali then
        Ambil := SisaKembali
      else
        Ambil := JumlahTercatat;

      // kembalikan ke tbl_batch
      qryUpdate.SQL.Text :=
        'UPDATE tbl_batch SET jumlah_sisa = jumlah_sisa + ' + IntToStr(Ambil) +
        ' WHERE id = ' + IntToStr(BatchID);
      qryUpdate.ExecSQL;

      // status otomatis menyesuaikan sisa
      qryUpdate.SQL.Text :=
        'UPDATE tbl_batch SET status = CASE WHEN jumlah_sisa = 0 THEN 0 ELSE 1 END' +
        ' WHERE id = ' + IntToStr(BatchID);
      qryUpdate.ExecSQL;

      // kurangi atau hapus record log
      if JumlahTercatat = Ambil then
        begin
          qryUpdate.SQL.Text :=
            'DELETE FROM tbl_penjualan_batch WHERE id = ' +
            qryLog.FieldByName('id').AsString;
          qryUpdate.ExecSQL;
        end
      else
        begin
          qryUpdate.SQL.Text :=
            'UPDATE tbl_penjualan_batch SET jumlah = jumlah - ' + IntToStr(Ambil) +
            ' WHERE id = ' + qryLog.FieldByName('id').AsString;
          qryUpdate.ExecSQL;
        end;

      SisaKembali := SisaKembali - Ambil;
      qryLog.Next;
    end;

  except
    on E: Exception do
    ShowMessage('KembalikanBatchSebagian error: ' + E.Message);
  end;

  qryLog.Free;
  qryUpdate.Free;
end;

procedure TFpenjualan.KembalikanBatch(PenjualanID: Integer);
var
  qryLog    : TADOQuery;
  qryUpdate : TADOQuery;
begin
  qryLog    := TADOQuery.Create(nil);
  qryUpdate := TADOQuery.Create(nil);

  try
    qryLog.Connection    := dm.con1;
    qryUpdate.Connection := dm.con1;

    // ambil semua record batch yang terkait penjualan ini
    qryLog.SQL.Text :=
      'SELECT batch_id, jumlah FROM tbl_penjualan_batch ' +
      'WHERE penjualan_id = ' + IntToStr(PenjualanID);
    qryLog.Open;

    while not qryLog.Eof do
      begin
        // kembalikan jumlah_sisa ke tbl_batch
        qryUpdate.SQL.Text :=
          'UPDATE tbl_batch SET jumlah_sisa = jumlah_sisa + ' +
          qryLog.FieldByName('jumlah').AsString +
          ' WHERE id = ' + qryLog.FieldByName('batch_id').AsString;
        qryUpdate.ExecSQL;

        // status otomatis menyesuaikan sisa
        qryUpdate.SQL.Text :=
          'UPDATE tbl_batch SET status = CASE WHEN jumlah_sisa = 0 THEN 0 ELSE 1 END' +
          ' WHERE id = ' + qryLog.FieldByName('batch_id').AsString;
        qryUpdate.ExecSQL;

        qryLog.Next;
      end;

    // hapus log batch penjualan ini
    qryUpdate.SQL.Text :=
      'DELETE FROM tbl_penjualan_batch ' +
      'WHERE penjualan_id = ' + IntToStr(PenjualanID);
    qryUpdate.ExecSQL;

  except
    on E: Exception do
    begin
      // ditelan — tidak ganggu proses batal
      // uncomment untuk debug:
      // ShowMessage('Kembalikan batch error: ' + E.Message);
    end;
  end;

  qryLog.Free;
  qryUpdate.Free;
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

  edtBayar.Text := '0';
  edtKembali.Text := '0';
  
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

              //hapus data batch
              KembalikanBatch(StrToInt(id_penjualan));
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
            SQL.Text := 'select * from tbl_penjualan where no_faktur like ''%'+FormatDateTime('mmyyyy',Now)+'%''';
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

      // ================================================================
      // BATCH FIFO — ditambahkan setelah proses stok lama selesai
      // Kalau batch belum ada untuk obat ini, otomatis skip
      // Tidak mempengaruhi transaksi kasir sama sekali
      // ================================================================
      AdjustBatchFIFO(
        StrToInt(edtIdObat.Text),   // obat_id
        1,                          // per klik Simpan selalu 1 unit
        StrToInt(id_penjualan)      // id penjualan yang baru disimpan
      );

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
    totalNew, hargaJual : Real;
    id,catatan,jenisHarga : string;
begin
  if key=#13 then
    begin
      //edit data lewat dbgrid
      jumlahNew := dbgrd1.Fields[3].AsInteger;
      catatan := dbgrd1.Fields[16].AsString;
      id := dbgrd1.Fields[5].AsString;
      jenisHarga := 'eceran';

      // jika lebih dari jumlah max grosir gunakan harga grosir
      with dm.qryHarga do
        begin
          close;
          sql.Clear;
          sql.Text := 'select * from tbl_harga_jual where obat_id = '+QuotedStr(dbgrd1.Fields[6].AsString)+'';
          Open;

          hargaJual := dm.qryHarga.fieldbyname('harga_jual').AsFloat;

          if dm.qryHarga.FieldByName('qty_max_grosir').AsInteger <> 0 then
            begin
              if jumlahNew >= dm.qryHarga.FieldByName('qty_max_grosir').AsInteger then
                begin
                  hargaJual := dm.qryHarga.fieldbyname('harga_jual_grosir').AsFloat;
                  jenisHarga := 'grosir';
                end
            end
        end;

      with dm.qryDetailPenjualan do
        begin
          close;
          sql.Clear;
          SQL.Text := 'update tbl_detail_penjualan set jumlah_jual = '+QuotedStr(IntToStr(jumlahNew))+', harga_jual = '+QuotedStr(FloatToStr(hargaJual))+', catatan = '+QuotedStr(catatan)+
                      ', jenis_harga='+QuotedStr(jenisHarga)+' where obat_id = '+QuotedStr(dbgrd1.Fields[6].AsString)+' and penjualan_id = '+QuotedStr(dbgrd1.Fields[0].AsString)+'';
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

      AdjustBatchFIFO(
        StrToInt(edtIdObat.Text),   // obat_id
        jumlahNew,                  // per klik Simpan selalu 1 unit
        StrToInt(id_penjualan)      // id penjualan yang baru disimpan
      );

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

      KembalikanBatch(StrToInt(id_penjualan));

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
  pesan : string;
begin
  if edtStatusPenjualan.Text = 'selesai' then
    pesan := 'Apakah Transaksi Akan Diselesaikan ?'
  else
    pesan := 'Apakah Transaksi Akan Dipending Pembayaran ?';

  if MessageDlg(pesan,mtConfirmation,[mbYes,mbno],0)=mryes then
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
      SQL.Text := 'select * from tbl_penjualan where no_faktur = '+QuotedStr(edtFaktur.Text)+'';
      Open;
    end;

  if dm.qryPenjualan.FieldByName('status').AsString = 'selesai' then status := 'Lunas' else status := 'Kredit';

  if dm.qrySetting.FieldByName('kertas').AsString = '80' then
    begin
      // Buat File dengan Nama Struk.txt
      // 80 mm
      nmfile := GetCurrentDir + '\struk.txt';
      AssignFile(txtFile, nmfile);
      Rewrite(txtFile);
      WriteLn(txtFile, RataTengah(dm.qrySetting.FieldByName('nama_toko').AsString, 32));
      WriteLn(txtFile, RataTengah(dm.qrySetting.FieldByName('alamat').AsString, 32));
      WriteLn(txtFile, RataTengah('Telp: ' + dm.qrySetting.FieldByName('telp').AsString, 32));
      WriteLn(txtFile, RataTengah('Tersedia Obat-Obatan',32));
      WriteLn(txtFile, RataTengah('Herbal dan Alkes',32));

      WriteLn(txtFile, '---------------------------------');
      WriteLn(txtFile, 'No. Nota:' + edtFaktur.text );
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
      WriteLn(txtFile, RataKanan('Total   : ', FormatFloat('Rp. ###,###,###', hitungTotal(id_penjualan)), 32,
           ' '));
      WriteLn(txtFile, RataKanan('Bayar   : ', FormatFloat('Rp. ###,###,###', StrToInt(edtBayar.Text)), 32,
           ' '));
      WriteLn(txtFile, RataKanan('Kembali : ', FormatFloat('Rp. ###,###,###', StrToInt(edtKembali.Text)), 32,
           ' '));
      WriteLn(txtFile, '---------------------------------');
      WriteLn(txtFile, ' Jumlah Item  : ' + IntToStr(hitungItem(id_penjualan)));
      WriteLn(txtFile, '---------------------------------');
      WriteLn(txtFile, RataTengah('Terima Kasih',32));
      WriteLn(txtFile, RataTengah('Berelaan Jual Seadanya',32));
      WriteLn(txtFile, RataTengah('Semoga Lekas Sembuh',32));
      WriteLn(txtFile, Enter + Enter + Enter + Enter + Enter + Enter + Enter + Enter + Enter + Enter );
      CloseFile(txtFile);
    end
  else
    begin
      //58 mm
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
      WriteLn(txtFile, 'No. Nota : ' + edtFaktur.Text);
      WriteLn(txtFile, 'Tanggal  : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', Now));
      WriteLn(txtFile, 'Kasir    : ' + dm.qryUser.FieldByName('nama').AsString);
      WriteLn(txtFile, 'Status   : ' + status);
      WriteLn(txtFile, StringOfChar('-', 32));
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

              WriteLn(txtFile,fieldbyname('nama_obat').asString);
              WriteLn(txtFile, RataKanan
                  ('      ' + fieldbyname('jumlah_jual').asString +' X '+FormatFloat('###,###,###',fieldbyname('harga_jual').AsInteger)+' ',FormatFloat('###,###,###',total), 32, ' '));


              Next;
            end;
        end;

      WriteLn(txtFile, StringOfChar('-', 32));

      WriteLn(txtFile, RataKanan('Total   : ', FormatFloat('Rp. ###,###,###', hitungTotal(id_penjualan)), 32,
           ' '));
      WriteLn(txtFile, RataKanan('Bayar   : ', FormatFloat('Rp. ###,###,###', StrToInt(edtBayar.Text)), 32,
           ' '));
      WriteLn(txtFile, RataKanan('Kembali : ', FormatFloat('Rp. ###,###,###', StrToInt(edtKembali.Text)), 32,
           ' '));

      WriteLn(txtFile, StringOfChar('-', 32));
      WriteLn(txtFile, ' Jumlah Item: ' + IntToStr(hitungItem(id_penjualan)));
      WriteLn(txtFile, StringOfChar('-', 32));
      WriteLn(txtFile, RataTengah('Terima Kasih',32));
      WriteLn(txtFile, RataTengah('Berelaan Jual Seadanya',32));
      WriteLn(txtFile, RataTengah('Semoga Lekas Sembuh',32));
      WriteLn(txtFile, Enter );
      CloseFile(txtFile);
    end;

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
