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
    edtJumlagJual: TEdit;
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
    procedure AdjustBatchFIFO(ObatID, JumlahBaru, PenjualanID, DetailPenjualanID: Integer);
    procedure KembalikanBatchSebagian(ObatID, JumlahKembali, PenjualanID: Integer);
    procedure KembalikanBatch(PenjualanID: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fpenjualan: TFpenjualan;
  kode, status, id_penjualan, detail_penjualan_id : string;

implementation

uses
  dataModule, StrUtils, uBantuObatPenjualan, uBayar, DateUtils, ADODB, DB;

{$R *.dfm}

procedure InsertKartuStok(
  Conn: TADOConnection;
  AObatID: Integer;
  ABatchID: Variant;
  ANoBatch: String;
  ATglFull: TDateTime;
  ANoFaktur: String;
  ATglExpired: Variant;
  ANie: String;
  ASumber: String;
  AKeterangan: String;
  AMasuk: Integer;
  AKeluar: Integer;
  ARefType: String;
  ARefID: Int64
);
var
  q: TADOQuery;
  LastSaldo, NewSaldo: Integer;
  sBatchID, sTglExp, sSQL: String;
begin
  // 1. Handle Batch ID
  if VarIsNull(ABatchID) or (VarToStr(ABatchID) = '') then
    sBatchID := 'NULL'
  else
    sBatchID := QuotedStr(VarToStr(ABatchID));

  // 2. Handle Tgl Expired
  if VarIsNull(ATglExpired) or (VarToStr(ATglExpired) = '') then
    sTglExp := 'NULL'
  else
    sTglExp := QuotedStr(FormatDateTime('yyyy-MM-dd', ATglExpired));

  q := TADOQuery.Create(nil);
  try
    q.Connection := Conn;
    // PENTING: Matikan pengecekan parameter agar tanda ":" tidak dianggap parameter
    q.ParamCheck := False; 

    // 3. Ambil saldo terakhir
    {sSQL := 'SELECT COALESCE(SUM(masuk - keluar),0) AS saldo ' +
            'FROM tbl_kartu_stok ' +
            'WHERE obat_id = ' + IntToStr(AObatID) + ' ' +
            'AND (batch_id = ' + sBatchID + ' OR (' + sBatchID + ' IS NULL AND batch_id IS NULL))'; }

    sSQL := 'SELECT COALESCE(SUM(masuk - keluar),0) AS saldo ' +
            'FROM tbl_kartu_stok ' +
            'WHERE obat_id = ' + IntToStr(AObatID);
    
    q.SQL.Text := sSQL;
    q.Open;
    LastSaldo := q.FieldByName('saldo').AsInteger;

    // 4. Validasi stok
    if (LastSaldo + AMasuk - AKeluar) < 0 then
      raise Exception.Create('Stok batch tidak mencukupi untuk Obat ID: ' + IntToStr(AObatID));

    NewSaldo := LastSaldo + AMasuk - AKeluar;

    // 5. Insert kartu stok
    q.Close;
    q.SQL.Clear;
    q.SQL.Add('INSERT INTO tbl_kartu_stok (');
    q.SQL.Add('obat_id, batch_id, no_batch, tgl_full, no_faktur, tgl_expired, nie,');
    q.SQL.Add('sumber, keterangan, masuk, keluar, saldo, ref_type, ref_id');
    q.SQL.Add(') VALUES (');
    q.SQL.Add(IntToStr(AObatID) + ', ');
    q.SQL.Add(sBatchID + ', ');
    q.SQL.Add(QuotedStr(ANoBatch) + ', ');
    q.SQL.Add(QuotedStr(FormatDateTime('yyyy-MM-dd HH:mm:ss', ATglFull)) + ', ');
    q.SQL.Add(QuotedStr(ANoFaktur) + ', ');
    q.SQL.Add(sTglExp + ', ');
    q.SQL.Add(QuotedStr(ANie) + ', ');
    q.SQL.Add(QuotedStr(ASumber) + ', ');
    q.SQL.Add(QuotedStr(AKeterangan) + ', ');
    q.SQL.Add(IntToStr(AMasuk) + ', ');
    q.SQL.Add(IntToStr(AKeluar) + ', ');
    q.SQL.Add(IntToStr(NewSaldo) + ', ');
    q.SQL.Add(QuotedStr(ARefType) + ', ');
    q.SQL.Add(IntToStr(ARefID));
    q.SQL.Add(')');

    q.ExecSQL;
  finally
    q.Free;
  end;
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
              //hapus data batch
              KembalikanBatch(StrToInt(id_penjualan));
              
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
  fBantuObatPenjualan.edtType.Text := 'penjualan';
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

  with dm.qryPelanggan do
    begin
      Active := False;
      active := True;
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
var
  jumlahNew, jumlahLama : Integer;
  hargaJual             : Real;
  id, catatan, jenisHarga : string;
  obatID, penjualanID   : string;
  TransAktif            : Boolean;
begin
  if Key <> #13 then Exit;

  TransAktif := False;

  try
    // -- AMBIL DATA DARI GRID --------------------------------------
    jumlahNew  := dbgrd1.Fields[3].AsInteger;
    catatan    := dbgrd1.Fields[16].AsString;
    id         := dbgrd1.Fields[5].AsString;
    obatID     := dbgrd1.Fields[6].AsString;
    penjualanID:= dbgrd1.Fields[0].AsString;
    jenisHarga := 'eceran';

    // validasi jumlah
    if jumlahNew <= 0 then
    begin
      MessageDlg('Jumlah tidak boleh 0 atau kurang.', mtWarning, [mbOK], 0);
      Exit;
    end;

    // -- AMBIL JUMLAH LAMA (untuk rollback tampilan kalau gagal) ---
    dm.qryBantu1.Close;
    dm.qryBantu1.SQL.Text :=
      'SELECT jumlah_jual FROM tbl_detail_penjualan ' +
      'WHERE obat_id = '      + QuotedStr(obatID)      +
      '  AND penjualan_id = ' + QuotedStr(penjualanID);
    dm.qryBantu1.Open;

    if dm.qryBantu1.IsEmpty then
    begin
      dm.qryBantu1.Close;
      raise Exception.Create('Data detail penjualan tidak ditemukan.');
    end;

    jumlahLama := dm.qryBantu1.FieldByName('jumlah_jual').AsInteger;
    dm.qryBantu1.Close;

    // -- CEK HARGA -------------------------------------------------
    dm.qryHarga.Close;
    dm.qryHarga.SQL.Text :=
      'SELECT harga_jual, harga_jual_grosir, qty_max_grosir ' +
      'FROM tbl_harga_jual ' +
      'WHERE obat_id = ' + QuotedStr(obatID);
    dm.qryHarga.Open;

    if dm.qryHarga.IsEmpty then
    begin
      dm.qryHarga.Close;
      raise Exception.Create('Data harga obat tidak ditemukan.');
    end;

    hargaJual := dm.qryHarga.FieldByName('harga_jual').AsFloat;

    if dm.qryHarga.FieldByName('qty_max_grosir').AsInteger <> 0 then
    begin
      if jumlahNew >= dm.qryHarga.FieldByName('qty_max_grosir').AsInteger then
      begin
        hargaJual  := dm.qryHarga.FieldByName('harga_jual_grosir').AsFloat;
        jenisHarga := 'grosir';
      end;
    end;
    dm.qryHarga.Close;

    // -- MULAI TRANSAKSI -------------------------------------------
    dm.con1.BeginTrans;
    TransAktif := True;

    // -- UPDATE DETAIL PENJUALAN -----------------------------------
    dm.qryDetailPenjualan.Close;
    dm.qryDetailPenjualan.SQL.Text :=
      'UPDATE tbl_detail_penjualan '                          +
      'SET jumlah_jual = ' + IntToStr(jumlahNew)             + ', ' +
      '    harga_jual = '  + FloatToStr(hargaJual)           + ', ' +
      '    catatan = '     + QuotedStr(catatan)              + ', ' +
      '    jenis_harga = ' + QuotedStr(jenisHarga)           +
      ' WHERE obat_id = '      + QuotedStr(obatID)           +
      '   AND penjualan_id = ' + QuotedStr(penjualanID);
    dm.qryDetailPenjualan.ExecSQL;

    // -- UPDATE STOK -----------------------------------------------
    dm.qryStok.Close;
    dm.qryStok.SQL.Text :=
      'UPDATE tbl_stok '                                      +
      'SET jumlah = ' + IntToStr(jumlahNew)                  +
      ' WHERE obat_id = '  + QuotedStr(obatID)               +
      '   AND no_faktur = ' + QuotedStr(dbgrd1.Fields[1].AsString);
    dm.qryStok.ExecSQL;

    // -- BATCH FIFO ------------------------------------------------
    // kalau stok tidak cukup, AdjustBatchFIFO akan raise Exception
    // transaksi otomatis di-rollback di blok except bawah
    AdjustBatchFIFO(
      StrToInt(obatID),
      jumlahNew,
      StrToInt(penjualanID),
      StrToInt(detail_penjualan_id)
    );

    // -- SEMUA SUKSES ? COMMIT -------------------------------------
    dm.con1.CommitTrans;
    TransAktif := False;

    // -- UPDATE TAMPILAN -------------------------------------------
    konek(edtFaktur.Text);
    lblItem.Caption       := IntToStr(hitungItem(id_penjualan));
    lblTotalHarga.Caption := FormatFloat('Rp. ###,###,###', hitungTotal(id_penjualan));
    btnSelesai.Enabled    := True;
    btnTambah.Caption     := 'Batal';
    btnHapus.Enabled      := False;
    dm.qryRelasiPenjualan.Locate('id_detail_penjualan', id, []);

  except
    on E: Exception do
    begin
      // -- ROLLBACK kalau transaksi masih aktif ------------------
      if TransAktif then
      begin
        try
          dm.con1.RollbackTrans;
        except
          // abaikan error rollback
        end;
        TransAktif := False;
      end;

      // -- KEMBALIKAN TAMPILAN GRID KE JUMLAH LAMA ---------------
      // refresh grid supaya angka kembali ke jumlahLama dari DB
      konek(edtFaktur.Text);

      // tampilkan pesan error ke user
      MessageDlg(
        'Gagal mengubah jumlah penjualan.' + #13#10 +
        #13#10 +
        'Keterangan: ' + E.Message         + #13#10 +
        #13#10 +
        'Data dikembalikan ke jumlah sebelumnya (' +
        IntToStr(jumlahLama) + ' item).',
        mtError, [mbOK], 0
      );
    end;
  end;
end;

procedure TFpenjualan.btnHapusClick(Sender: TObject);
begin
  if MessageDlg('Yakin Data Akan Dihapus ?',mtConfirmation,[mbYes,mbNo],0)=mryes then
    begin
      KembalikanBatchSebagian(StrToInt(edtIdObat.Text), StrToInt(edtJumlagJual.Text), StrToInt(edtIdPembelian.Text));
      
      with dm.qryDetailPenjualan do
        begin
          Close;
          SQL.Clear;
          SQL.Text := 'delete from tbl_detail_penjualan where penjualan_id = '+QuotedStr(edtIdPembelian.Text)+' and obat_id = '+QuotedStr(edtIdObat.Text)+'';
          ExecSQL;
        end;

      //hapus stok
      with dm.qryStok do
        begin
          close;
          SQL.Clear;
          SQL.Text := 'delete from tbl_stok where no_faktur = '+QuotedStr(edtFaktur.Text)+' and obat_id = '+QuotedStr(edtIdObat.Text)+'';
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
  edtJumlagJual.Text := dbgrd1.Fields[14].AsString;
  btnHapus.Enabled := True;
end;

procedure TFpenjualan.btnProsesClick(Sender: TObject);
var
  jumlahItem, total: string;
  a: integer;
  pesan: string;
  qryBatchJual: TADOQuery;
begin
  if edtStatusPenjualan.Text = 'selesai' then
    pesan := 'Apakah Transaksi Akan Diselesaikan ?'
  else
    pesan := 'Apakah Transaksi Akan Dipending Pembayaran ?';

  if MessageDlg(pesan, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    // Pastikan tidak ada transaksi menggantung sebelum memulai
    if dm.con1.InTransaction then 
       dm.con1.RollbackTrans; 

    dm.con1.BeginTrans;
    try
      jumlahItem := IntToStr(hitungItem(id_penjualan));
      total := FloatToStr(hitungTotal(id_penjualan));

      // 1. Update Tabel Penjualan
      with dm.qryPenjualan do
      begin
        Close;
        SQL.Clear;
        SQL.Text := 'UPDATE tbl_penjualan SET ' +
                    'jumlah_item = ' + QuotedStr(jumlahItem) + ', ' +
                    'total = ' + QuotedStr(total) + ', ' +
                    'status = ' + QuotedStr(edtStatusPenjualan.Text) + ', ' +
                    'tgl_bayar = ' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:mm:ss', Now)) + ' ' +
                    'WHERE no_faktur = ' + QuotedStr(edtFaktur.Text) +'';
        ExecSQL;
      end;

      // 2. Update Stok Obat
      with dm.qryDetailPenjualan do
      begin
        Close;
        SQL.Text := 'SELECT * FROM tbl_detail_penjualan WHERE penjualan_id = ' + QuotedStr(id_penjualan);
        Open;

        while not Eof do
        begin
          // Gunakan SQL Update langsung agar lebih cepat dan aman daripada Locate/Edit/Post
          dm.con1.Execute('UPDATE tbl_obat SET stok = stok - ' + FieldByName('jumlah_jual').AsString + 
                         ' WHERE id = ' + QuotedStr(FieldByName('obat_id').AsString));
          Next;
        end;
      end;

      // 3. Cek Duplikasi Kartu Stok
      with dm.qryBantu4 do
      begin
        Close;
        SQL.Text := 'SELECT COUNT(*) AS jml FROM tbl_kartu_stok WHERE ref_type = ''penjualan'' AND ref_id = ' + id_penjualan;
        Open;
        if FieldByName('jml').AsInteger > 0 then
          raise Exception.Create('Transaksi sudah diposting ke kartu stok!');
      end;

      // 4. Insert ke Kartu Stok
      qryBatchJual := TADOQuery.Create(nil);
      try
        qryBatchJual.Connection := dm.con1;
        qryBatchJual.SQL.Text := 
          'SELECT pb.batch_id, pb.jumlah, b.no_batch, b.tgl_expired, b.nie_number, b.obat_id ' +
          'FROM tbl_penjualan_batch pb JOIN tbl_batch b ON b.id = pb.batch_id ' +
          'WHERE pb.penjualan_id = ' + QuotedStr(id_penjualan);
        qryBatchJual.Open;

        if qryBatchJual.IsEmpty then
          raise Exception.Create('Batch penjualan tidak ditemukan!');

        while not qryBatchJual.Eof do
        begin
          InsertKartuStok(
            dm.con1,
            qryBatchJual.FieldByName('obat_id').AsInteger,
            qryBatchJual.FieldByName('batch_id').AsInteger,
            qryBatchJual.FieldByName('no_batch').AsString,
            Now,
            edtFaktur.Text,
            qryBatchJual.FieldByName('tgl_expired').Value,
            qryBatchJual.FieldByName('nie_number').AsString,
            'Penjualan',
            'Finalisasi penjualan',
            0,
            qryBatchJual.FieldByName('jumlah').AsInteger,
            'penjualan',
            StrToInt(id_penjualan)
          );
          qryBatchJual.Next;
        end;
      finally
        qryBatchJual.Free;
      end;

      // KUNCI PERBAIKAN: Harus ada Commit jika semua berhasil
      dm.con1.CommitTrans;
      MessageDlg('Data berhasil Disimpan!', mtInformation,[mbOK],0);

    except
      on E: Exception do
      begin
        dm.con1.RollbackTrans;
        MessageDlg('Gagal memproses data: ' + E.Message, mtError, [mbOK], 0);
        Exit; // Keluar agar tidak lanjut ke cetak jika error
      end;
    end;

    // Bagian Luar Transaksi
    with dm.qrySetting do
    begin
      Close;
      SQL.Text := 'SELECT * FROM tbl_setting';
      Open;
    end;

    if chkCetak.Checked then btnCetak.Click;

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
      // 80 mm
      nmfile := GetCurrentDir + '\struk.txt';
      AssignFile(txtFile, nmfile);
      Rewrite(txtFile);

      // Semua 32 diganti 42, garis diganti 42 strip
      WriteLn(txtFile, RataTengah(dm.qrySetting.FieldByName('nama_toko').AsString, 42));
      WriteLn(txtFile, RataTengah(dm.qrySetting.FieldByName('alamat').AsString, 42));
      WriteLn(txtFile, RataTengah('Telp: ' + dm.qrySetting.FieldByName('telp').AsString, 42));
      WriteLn(txtFile, RataTengah('Tersedia Obat-Obatan', 42));
      WriteLn(txtFile, RataTengah('Herbal dan Alkes', 42));

      WriteLn(txtFile, StringOfChar('-', 42));
      WriteLn(txtFile, 'No. Nota : ' + edtFaktur.Text);
      WriteLn(txtFile, 'Tanggal  : ' + FormatDateTime('dd/mm/yyyy hh:mm:ss', Now));
      WriteLn(txtFile, 'Kasir    : ' + dm.qryUser.FieldByName('nama').AsString);
      WriteLn(txtFile, 'Status   : ' + status);
      WriteLn(txtFile, StringOfChar('-', 42));
      WriteLn(txtFile, 'Nama Barang');
      WriteLn(txtFile, RataKanan('      QTY   Harga ', 'Sub Total', 42, ' '));
      WriteLn(txtFile, StringOfChar('-', 42));

      with dm.qryRelasiPenjualan do
        for a := 1 to RecordCount do
        begin
          RecNo := a;
          total := FieldByName('jumlah_jual').AsInteger * FieldByName('harga_jual').AsInteger;
          WriteLn(txtFile, ' ' + FieldByName('nama_obat').AsString);
          WriteLn(txtFile, RataKanan(
            '      ' + FieldByName('jumlah_jual').AsString +
            ' X ' + FormatFloat('###,###,###', FieldByName('harga_jual').AsInteger) + ' ',
            FormatFloat('###,###,###', total), 42, ' '));
        end;

      WriteLn(txtFile, StringOfChar('-', 42));
      WriteLn(txtFile, RataKanan('Total   : ',
        FormatFloat('Rp. ###,###,###', hitungTotal(id_penjualan)), 42, ' '));
      WriteLn(txtFile, RataKanan('Bayar   : ',
        FormatFloat('Rp. ###,###,###', StrToInt(edtBayar.Text)), 42, ' '));
      WriteLn(txtFile, RataKanan('Kembali : ',
        FormatFloat('Rp. ###,###,###', StrToInt(edtKembali.Text)), 42, ' '));
      WriteLn(txtFile, StringOfChar('-', 42));
      WriteLn(txtFile, ' Jumlah Item : ' + IntToStr(hitungItem(id_penjualan)));
      WriteLn(txtFile, StringOfChar('-', 42));
      WriteLn(txtFile, RataTengah('Terima Kasih', 42));
      WriteLn(txtFile, RataTengah('Berelaan Jual Seadanya', 42));
      WriteLn(txtFile, Enter);
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

procedure TFpenjualan.btnSimpanClick(Sender: TObject);
var
  jmlEdit      : Integer;
  TransAktif   : Boolean;
begin
  if btnSimpan.Caption <> 'Simpan' then
  begin
    edtHarga.Enabled  := True;
    btnSimpan.Caption := 'Simpan';
    btnHapus.Caption  := 'Batal[F1]';
    status            := 'edit';
    Exit;
  end;

  // -- validasi input dasar ----------------------------------------
  if Trim(edtIdObat.Text) = '' then
  begin
    MessageDlg('Pilih obat terlebih dahulu.', mtWarning, [mbOK], 0);
    Exit;
  end;

  if Trim(edtHarga.Text) = '' then
  begin
    MessageDlg('Harga obat tidak boleh kosong.', mtWarning, [mbOK], 0);
    Exit;
  end;

  TransAktif := False;

  try
    dm.con1.BeginTrans;
    TransAktif := True;

    // -- BUAT FAKTUR BARU (hanya kalau status = tambah) -------------
    if status = 'tambah' then
    begin
      // kunci tabel sejenak agar nomor faktur tidak dobel antar user
      dm.qryBantu1.Close;
      dm.qryBantu1.SQL.Text :=
        'SELECT no_faktur FROM tbl_penjualan ' +
        'WHERE no_faktur LIKE ' + QuotedStr('%' + FormatDateTime('mmyyyy', Now) + '%') +
        ' ORDER BY id DESC LIMIT 1 FOR UPDATE';
      dm.qryBantu1.Open;

      if dm.qryBantu1.IsEmpty then
        kode := '00001'
      else
        kode := FormatFloat('00000', StrToInt(RightStr(dm.qryBantu1.FieldByName('no_faktur').AsString, 5)) + 1);

      dm.qryBantu1.Close;

      edtFaktur.Text := 'PJ-' + FormatDateTime('ddmmyyyy', Now) + kode;

      // INSERT faktur baru pakai SQL langsung — lebih aman
      dm.qryBantu1.SQL.Text :=
        'INSERT INTO tbl_penjualan ' +
        '(no_faktur, tgl_penjualan, id_pelanggan, jumlah_item, total, user_id, status) VALUES (' +
        QuotedStr(edtFaktur.Text)                              + ', ' +
        QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',
                                  dtpTanggalBeli.DateTime))   + ', ' +
        QuotedStr(VarToStr(dblkcbbPelanggan.KeyValue))        + ', ' +
        '0, 0, '                                               +
        QuotedStr(dm.qryUser.FieldByName('id').AsString)      + ', ' +
        QuotedStr('pending')                                   + ')';
      dm.qryBantu1.ExecSQL;

      // ambil id yang baru diinsert
      dm.qryBantu1.SQL.Text := 'SELECT LAST_INSERT_ID() AS new_id';
      dm.qryBantu1.Open;
      id_penjualan := dm.qryBantu1.FieldByName('new_id').AsString;
      dm.qryBantu1.Close;

      status := 'tambahLagi';
    end;

    // pastikan id_penjualan terisi kalau status sudah tambahLagi
    if Trim(id_penjualan) = '' then
      raise Exception.Create('ID penjualan tidak ditemukan. Silakan mulai ulang transaksi.');

    // -- DETAIL PENJUALAN --------------------------------------------
    dm.qryBantu2.Close;
    dm.qryBantu2.SQL.Text :=
      'SELECT id, jumlah_jual FROM tbl_detail_penjualan ' +
      'WHERE obat_id = '     + QuotedStr(edtIdObat.Text) +
      '  AND penjualan_id = ' + QuotedStr(id_penjualan);
    dm.qryBantu2.Open;

    if dm.qryBantu2.IsEmpty then
    begin
      // obat belum ada di detail ? INSERT baru
      dm.qryBantu2.Close;
      dm.qryBantu2.SQL.Text :=
        'INSERT INTO tbl_detail_penjualan ' +
        '(penjualan_id, obat_id, jumlah_jual, harga_jual) VALUES (' +
        QuotedStr(id_penjualan)  + ', ' +
        QuotedStr(edtIdObat.Text)+ ', 1, ' +
        QuotedStr(edtHarga.Text) + ')';
      dm.qryBantu2.ExecSQL;

      // ambil id detail yang baru
      dm.qryBantu2.SQL.Text := 'SELECT LAST_INSERT_ID() AS new_id';
      dm.qryBantu2.Open;
      detail_penjualan_id := dm.qryBantu2.FieldByName('new_id').AsString;
      dm.qryBantu2.Close;

      jmlEdit := 1;
    end
    else
    begin
      // obat sudah ada ? UPDATE jumlah + 1
      detail_penjualan_id := dm.qryBantu2.FieldByName('id').AsString;
      jmlEdit := dm.qryBantu2.FieldByName('jumlah_jual').AsInteger + 1;
      dm.qryBantu2.Close;

      dm.qryBantu2.SQL.Text :=
        'UPDATE tbl_detail_penjualan ' +
        'SET jumlah_jual = ' + IntToStr(jmlEdit) +
        ' WHERE id = ' + QuotedStr(detail_penjualan_id);
      dm.qryBantu2.ExecSQL;
    end;

    // -- STOK --------------------------------------------------------
    dm.qryBantu3.Close;
    dm.qryBantu3.SQL.Text :=
      'SELECT id, jumlah FROM tbl_stok ' +
      'WHERE obat_id = '  + QuotedStr(edtIdObat.Text) +
      '  AND no_faktur = ' + QuotedStr(edtFaktur.Text);
    dm.qryBantu3.Open;

    if dm.qryBantu3.IsEmpty then
    begin
      dm.qryBantu3.Close;
      dm.qryBantu3.SQL.Text :=
        'INSERT INTO tbl_stok ' +
        '(no_faktur, obat_id, jumlah, harga, keterangan) VALUES (' +
        QuotedStr(edtFaktur.Text) + ', ' +
        QuotedStr(edtIdObat.Text) + ', 1, ' +
        QuotedStr(edtHarga.Text)  + ', ' +
        QuotedStr('penjualan')    + ')';
      dm.qryBantu3.ExecSQL;
    end
    else
    begin
      dm.qryBantu3.Close;
      dm.qryBantu3.SQL.Text :=
        'UPDATE tbl_stok ' +
        'SET jumlah = jumlah + 1 ' +
        'WHERE no_faktur = ' + QuotedStr(edtFaktur.Text) +
        '  AND obat_id = '   + QuotedStr(edtIdObat.Text);
      dm.qryBantu3.ExecSQL;
    end;

    // -- BATCH FIFO -------------------------------------------------
    // AdjustBatchFIFO sekarang ikut transaksi yang sama
    // Rollback otomatis kalau FIFO gagal
    AdjustBatchFIFO(
      StrToInt(edtIdObat.Text),
      jmlEdit,
      StrToInt(id_penjualan),
      StrToInt(detail_penjualan_id)
    );

    // -- SEMUA SUKSES ? COMMIT --------------------------------------
    dm.con1.CommitTrans;
    TransAktif := False;

    // -- UPDATE TAMPILAN --------------------------------------------
    konek(edtFaktur.Text);
    lblItem.Caption       := IntToStr(hitungItem(id_penjualan));
    lblTotalHarga.Caption := FormatFloat('Rp. ###,###,###', hitungTotal(id_penjualan));

    btnSelesai.Enabled        := True;
    btnTambah.Caption         := 'Batal';
    btnHapus.Enabled          := False;
    dtpTanggalBeli.Enabled    := False;
    dblkcbbPelanggan.Enabled  := False;

  except
    on E: Exception do
    begin
      if TransAktif then
      begin
        try
          dm.con1.RollbackTrans;
        except
          // abaikan error rollback
        end;
        TransAktif := False;
      end;

      MessageDlg(
        'Gagal menyimpan penjualan.' + #13#10 +
        #13#10 +
        'Keterangan: ' + E.Message  + #13#10 +
        #13#10 +
        'Transaksi dibatalkan. Silakan coba lagi.',
        mtError, [mbOK], 0
      );
    end;
  end;
end;

procedure TFpenjualan.AdjustBatchFIFO(ObatID, JumlahBaru, PenjualanID, DetailPenjualanID: Integer);
var
  qryCek    : TADOQuery;
  qryBatch  : TADOQuery;
  qryUpdate : TADOQuery;
  qryLog    : TADOQuery;
  JumlahLama, Delta, SisaKurangi, Ambil, BatchID, SisaBatch: Integer;
  HargaBeli : Double;
begin
  qryCek    := TADOQuery.Create(nil);
  qryBatch  := TADOQuery.Create(nil);
  qryUpdate := TADOQuery.Create(nil);
  qryLog    := TADOQuery.Create(nil);

  try        // ? try LUAR: khusus untuk finally (Free)
    try      // ? try DALAM: khusus untuk except
      qryCek.Connection    := dm.con1;
      qryBatch.Connection  := dm.con1;
      qryUpdate.Connection := dm.con1;
      qryLog.Connection    := dm.con1;

      // -- CEK JUMLAH YANG SUDAH TERCATAT -----------------------------
      qryCek.SQL.Text :=
        'SELECT COALESCE(SUM(pb.jumlah), 0) AS total_tercatat ' +
        'FROM tbl_penjualan_batch pb '                          +
        'JOIN tbl_batch b ON b.id = pb.batch_id '              +
        'WHERE pb.penjualan_id        = ' + IntToStr(PenjualanID)       +
        '  AND pb.detail_penjualan_id = ' + IntToStr(DetailPenjualanID) +
        '  AND b.obat_id              = ' + IntToStr(ObatID);
      qryCek.Open;
      JumlahLama := qryCek.FieldByName('total_tercatat').AsInteger;
      qryCek.Close;

      Delta := JumlahBaru - JumlahLama;

      if Delta = 0 then Exit;

      if Delta > 0 then
      begin
        SisaKurangi := Delta;

        qryBatch.SQL.Text :=
          'SELECT id, jumlah_sisa, harga_beli FROM tbl_batch ' +
          'WHERE obat_id = '    + IntToStr(ObatID)             +
          '  AND jumlah_sisa > 0 '                             +
          '  AND status = 1 '                                  +
          'ORDER BY tgl_expired ASC '                          +
          'FOR UPDATE';
        qryBatch.Open;

        if qryBatch.IsEmpty then
        begin
          qryBatch.Close;
          raise Exception.Create('Stok obat sudah habis, tidak dapat diproses.');
        end;

        while (not qryBatch.Eof) and (SisaKurangi > 0) do
        begin
          BatchID   := qryBatch.FieldByName('id').AsInteger;
          SisaBatch := qryBatch.FieldByName('jumlah_sisa').AsInteger;
          HargaBeli := qryBatch.FieldByName('harga_beli').AsFloat;

          if SisaBatch >= SisaKurangi then
            Ambil := SisaKurangi
          else
            Ambil := SisaBatch;

          qryUpdate.SQL.Text :=
            'UPDATE tbl_batch '                                    +
            'SET jumlah_sisa = jumlah_sisa - ' + IntToStr(Ambil)  +
            ' WHERE id = '           + IntToStr(BatchID)          +
            '   AND jumlah_sisa >= ' + IntToStr(Ambil);
          qryUpdate.ExecSQL;

          if qryUpdate.RowsAffected = 0 then
          begin
            qryBatch.Next;
            Continue;
          end;

          qryUpdate.SQL.Text :=
            'UPDATE tbl_batch '                              +
            'SET status = CASE WHEN jumlah_sisa <= 0 '      +
            '             THEN 0 ELSE 1 END '               +
            'WHERE id = ' + IntToStr(BatchID);
          qryUpdate.ExecSQL;

          qryLog.SQL.Text :=
            'SELECT id FROM tbl_penjualan_batch '                        +
            'WHERE penjualan_id        = ' + IntToStr(PenjualanID)       +
            '  AND detail_penjualan_id = ' + IntToStr(DetailPenjualanID) +
            '  AND batch_id            = ' + IntToStr(BatchID);
          qryLog.Open;

          if qryLog.IsEmpty then
          begin
            qryLog.Close;
            qryLog.SQL.Text :=
              'INSERT INTO tbl_penjualan_batch '                  +
              '(penjualan_id, detail_penjualan_id, batch_id, '   +
              ' jumlah, harga_beli, is_estimasi, created_at) '   +
              'VALUES ('                                          +
              IntToStr(PenjualanID)                    + ', '    +
              IntToStr(DetailPenjualanID)               + ', '    +
              IntToStr(BatchID)                         + ', '    +
              IntToStr(Ambil)                           + ', '    +
              FormatFloat('0.####', HargaBeli)          + ', 1, NOW())';
            qryLog.ExecSQL;
          end
          else
          begin
            qryLog.Close;
            qryLog.SQL.Text :=
              'UPDATE tbl_penjualan_batch '                                  +
              'SET jumlah = jumlah + '  + IntToStr(Ambil)                   +
              ' WHERE penjualan_id        = ' + IntToStr(PenjualanID)       +
              '   AND detail_penjualan_id = ' + IntToStr(DetailPenjualanID) +
              '   AND batch_id            = ' + IntToStr(BatchID);
            qryLog.ExecSQL;
          end;

          SisaKurangi := SisaKurangi - Ambil;
          qryBatch.Next;
        end;

        qryBatch.Close;

        if SisaKurangi > 0 then
          raise Exception.Create(
            'Stok tidak mencukupi, masih kurang ' +
            IntToStr(SisaKurangi) + ' item. Transaksi dibatalkan.'
          );
      end
      else
      begin
        KembalikanBatchSebagian(ObatID, Abs(Delta), PenjualanID);
      end;

    except  // ? except milik try DALAM
      on E: Exception do
      begin
        if qryBatch.Active then qryBatch.Close;
        if qryLog.Active   then qryLog.Close;
        if qryCek.Active   then qryCek.Close;
        raise Exception.Create(E.Message);
      end;
    end;    // ? end try DALAM

  finally   // ? finally milik try LUAR
    qryCek.Free;
    qryBatch.Free;
    qryUpdate.Free;
    qryLog.Free;
  end;      // ? end try LUAR
end;


end.
