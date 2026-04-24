unit uReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Buttons, ComCtrls, jpeg, ExtCtrls;

type
  TfReturn = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    edtFaktur: TEdit;
    lbl3: TLabel;
    lbl2: TLabel;
    btnCari: TBitBtn;
    dbgrd1: TDBGrid;
    edtTanggalJual: TEdit;
    btnRetualAll: TBitBtn;
    btnRetur: TBitBtn;
    btnKeluar: TBitBtn;
    lbl4: TLabel;
    dtpTanggalRetur: TDateTimePicker;
    img1: TImage;
    btnTambah: TBitBtn;
    edtKode: TEdit;
    dbgrd2: TDBGrid;
    lbl5: TLabel;
    lbl6: TLabel;
    bvl1: TBevel;
    btnSelesai: TBitBtn;
    edtIdPenjualan: TEdit;
    procedure btnKeluarClick(Sender: TObject);
    procedure edtFakturKeyPress(Sender: TObject; var Key: Char);
    procedure btnCariClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnReturClick(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure btnSelesaiClick(Sender: TObject);
    procedure btnRetualAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fReturn: TfReturn;
  kode : string;

implementation

uses
  dataModule, uProsesRetur, DB, StrUtils, u_confirmReturAll, ADODB;

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

procedure konek;
begin
 with dm.qryRelasiPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select a.id as id_penjualan, a.no_faktur, a.tgl_penjualan, a.jumlah_item, a.total, b.id as id_detail_penjualan, '+
                  'b.obat_id, b.jumlah_jual, b.harga_jual, c.kode, c.barcode, c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, '+
                  'e.satuan, b.catatan from tbl_penjualan a left join tbl_detail_penjualan b on b.penjualan_id = a.id left join tbl_obat c '+
                  'on c.id = b.obat_id left join tbl_jenis d on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan '+
                  'where a.no_faktur= '+QuotedStr('kosong')+'';
      Open;
    end;

end;

procedure konekRelasiReturObat(faktur : string = 'kosong');
begin
  with dm.qryRelasiReturObat do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'select * from tbl_stok left join tbl_obat on tbl_obat.id = tbl_stok.obat_id where tbl_stok.no_faktur = '+QuotedStr(faktur)+' and tbl_stok.keterangan = '+QuotedStr('retur-penjualan')+'';
      Open;
    end;
end;

procedure TfReturn.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfReturn.edtFakturKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then btnCari.Click;
end;

procedure TfReturn.btnCariClick(Sender: TObject);
begin
  if edtFaktur.Text = '' then
    begin
      MessageDlg('No. Faktur Belum Dimasukkan',mtInformation,[mbOK],0);
      edtFaktur.SetFocus;
      Exit;
    end;

  with dm.qryRelasiPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select a.id as id_penjualan, a.no_faktur, a.tgl_penjualan, a.jumlah_item, a.total, b.id as id_detail_penjualan, '+
                  'b.obat_id, b.jumlah_jual, b.harga_jual, c.kode, c.barcode, c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, '+
                  'e.satuan, b.catatan from tbl_penjualan a left join tbl_detail_penjualan b on b.penjualan_id = a.id left join tbl_obat c '+
                  'on c.id = b.obat_id left join tbl_jenis d on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan '+
                  'where a.no_faktur = '+QuotedStr(edtFaktur.Text)+'';
      Open;

      if IsEmpty then
        begin
          MessageDlg('No. Faktur Tidak Ditemukan',mtInformation,[mbOK],0);
          Exit;
        end
      else
        begin
          btnRetualAll.Enabled := True;
          edtTanggalJual.Text := fieldbyname('tgl_penjualan').AsString;
          edtIdPenjualan.Text := fieldbyname('id_penjualan').AsString;
        end;

    end;
end;

procedure TfReturn.FormShow(Sender: TObject);
begin
  edtFaktur.Clear; edtFaktur.Enabled := False;
  edtTanggalJual.Clear; edtTanggalJual.Enabled := false;
  dtpTanggalRetur.Enabled := false; dtpTanggalRetur.Date := Now;
  btnCari.Enabled := false;

  btnTambah.Enabled := True; btnTambah.Caption := 'Tambah';
  btnRetualAll.Enabled := false;
  btnRetur.Enabled := false;
  btnKeluar.Enabled := True;
  btnSelesai.Enabled := false;

  konek;
  konekRelasiReturObat;
end;

procedure TfReturn.btnReturClick(Sender: TObject);
begin
  fProsesRetur.edtFaktur.Text := edtFaktur.Text;
  fProsesRetur.edtTglJual.Text := edtTanggalJual.Text;
  fProsesRetur.edtTglRetur.Text := DateToStr(dtpTanggalRetur.DateTime);

  fProsesRetur.edtKodeObat.Text := dbgrd1.Fields[7].AsString;
  fProsesRetur.edtNamaObat.Text := dbgrd1.Fields[11].AsString;
  fProsesRetur.edtJumlahJual.Text := dbgrd1.Fields[14].AsString;
  fProsesRetur.edtHargaJual.Text := FormatFloat('Rp. ###,###,###', dbgrd1.Fields[15].AsFloat);
  fProsesRetur.edtKodeRetur.Text := edtKode.Text;
  fProsesRetur.edtIdPenjualan.Text := dbgrd1.Fields[0].AsString;

  fProsesRetur.edtHarga.Text := dbgrd1.Fields[15].AsString;
  fProsesRetur.edtIdObat.Text := dbgrd1.Fields[6].AsString;
  fProsesRetur.edtJumlahRetur.Text := dbgrd1.Fields[14].AsString;
  fProsesRetur.mmoAlasan.Clear;

  fProsesRetur.ShowModal;
end;

procedure TfReturn.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption = 'Tambah' then
    begin
      edtFaktur.Enabled := True; edtFaktur.SetFocus;
      dtpTanggalRetur.Enabled := True; dtpTanggalRetur.Date := Now;

      btnCari.Enabled := True;
      btnTambah.Caption := 'Batal';
      btnKeluar.Enabled := false;

      with dm.qryRetur do
        begin
          Close;
          sql.Clear;
          SQL.Text := 'select * from tbl_retur where kode like ''%'+FormatDateTime('yyyy',Now)+'%''';
          Open;

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

          edtKode.Text := 'RT-' + FormatDateTime('ddmmyyyy',Now) + FormatFloat('0000',StrToInt(kode));

          //simpan tbl_retur
          with dm.qryRetur do
            begin
              Append;
              FieldByName('kode').AsString := edtKode.Text;
              FieldByName('tgl_retur').AsString := DateToStr(dtpTanggalRetur.Date);
              FieldByName('jenis_retur').AsString := 'penjualan';
              Post;
            end;
        end;
    end
  else
    begin
      if MessageDlg('Yakin Transaksi Akan Dibatalkan',mtConfirmation, [mbYes,mbNo],0) = mryes then
        begin
          with dm.qryRetur do
            begin
              Close;
              sql.Clear;
              sql.Text := 'delete from tbl_retur where kode = '+QuotedStr(edtKode.Text)+'';
              ExecSQL;
            end;

          with dm.qryStok do
            begin
              close;
              sql.Clear;
              sql.Text := 'delete from tbl_stok where no_faktur = '+QuotedStr(edtFaktur.Text)+' and keterangan = '+QuotedStr('retur-penjualan')+'';
              ExecSQL;
            end;
            
          FormShow(Sender);
        end;
    end;
end;

procedure TfReturn.dbgrd1DblClick(Sender: TObject);
begin
  btnRetur.Enabled := True;
end;

procedure TfReturn.btnSelesaiClick(Sender: TObject);
var 
  a, jmlRetur, jmlJual, stokObat : Integer;
  obatId, batchId, pbId : string;
  totalJualBatch, jmlKembalikan, sisaRetur, stokSisa : Integer;
  qryBatchRetur: TADOQuery;
begin
  if MessageDlg('Selesaikan Transaksi Retur Penjualan?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    // Gunakan Transaksi untuk menjaga integritas data
    while dm.con1.InTransaction do dm.con1.RollbackTrans;
    dm.con1.BeginTrans;

    try
      // 1. Ambil data item yang diretur dari tabel sementara/stok
      with dm.qryStok do
      begin
        Close;
        SQL.Text := 'SELECT * FROM tbl_stok WHERE no_faktur = ' + QuotedStr(edtFaktur.Text) + 
                    ' AND keterangan = ' + QuotedStr('retur-penjualan');
        Open;

        if IsEmpty then
        begin
          dm.con1.RollbackTrans;
          MessageDlg('Data item retur tidak ditemukan!', mtWarning, [mbOK], 0);
          Exit;
        end;

        // 2. Loop per Item Obat yang diretur
        while not Eof do
        begin
          obatId := FieldByName('obat_id').AsString;
          jmlRetur := FieldByName('jumlah').AsInteger;

          // A. Update Detail Penjualan (Kurangi jumlah jual & set status)
          dm.con1.Execute('UPDATE tbl_detail_penjualan SET jumlah_jual = jumlah_jual - ' + IntToStr(jmlRetur) + 
                         ', status = ' + QuotedStr('retur') +
                         ' WHERE penjualan_id = ' + QuotedStr(edtIdPenjualan.Text) + 
                         ' AND obat_id = ' + QuotedStr(obatId));

          // B. Tambah stok utama di tbl_obat
          dm.con1.Execute('UPDATE tbl_obat SET stok = stok + ' + IntToStr(jmlRetur) + 
                         ' WHERE id = ' + QuotedStr(obatId));

          // C. Kembalikan stok ke Batch secara proporsional
          // Hitung total terjual dari semua batch untuk obat ini dalam transaksi tsb
          qryBatchRetur := TADOQuery.Create(nil);
          try
            qryBatchRetur.Connection := dm.con1;
            qryBatchRetur.ParamCheck := False;
            
            qryBatchRetur.SQL.Text := 
              'SELECT SUM(jumlah) as total FROM tbl_penjualan_batch pb ' +
              'JOIN tbl_batch b ON b.id = pb.batch_id ' +
              'WHERE pb.penjualan_id = ' + QuotedStr(edtIdPenjualan.Text) + 
              ' AND b.obat_id = ' + QuotedStr(obatId);
            qryBatchRetur.Open;
            totalJualBatch := qryBatchRetur.FieldByName('total').AsInteger;
            
            sisaRetur := jmlRetur;

            // Ambil detail batch yang terjual
            qryBatchRetur.Close;
            qryBatchRetur.SQL.Text := 
              'SELECT pb.id as pb_id, pb.batch_id, pb.jumlah as jml_batch, b.no_batch, b.tgl_expired, b.nie_number, b.jumlah_sisa ' +
              'FROM tbl_penjualan_batch pb ' +
              'JOIN tbl_batch b ON b.id = pb.batch_id ' +
              'WHERE pb.penjualan_id = ' + QuotedStr(edtIdPenjualan.Text) + 
              ' AND b.obat_id = ' + QuotedStr(obatId) + ' ORDER BY b.created_at ASC';
            qryBatchRetur.Open;

            while (not qryBatchRetur.Eof) and (sisaRetur > 0) do
            begin
              pbId := qryBatchRetur.FieldByName('pb_id').AsString;
              batchId := qryBatchRetur.FieldByName('batch_id').AsString;
              
              // Hitung jumlah yang dikembalikan ke batch ini (proporsional)
              if qryBatchRetur.RecordCount = 1 then
                jmlKembalikan := sisaRetur
              else
                jmlKembalikan := Round(jmlRetur * (qryBatchRetur.FieldByName('jml_batch').AsInteger / totalJualBatch));

              if jmlKembalikan > sisaRetur then jmlKembalikan := sisaRetur;

              // Update tbl_batch (tambah sisa stok)
              dm.con1.Execute('UPDATE tbl_batch SET jumlah_sisa = jumlah_sisa + ' + IntToStr(jmlKembalikan) + 
                             ' WHERE id = ' + QuotedStr(batchId));

              // Update tbl_penjualan_batch (catat jumlah retur)
              dm.con1.Execute('UPDATE tbl_penjualan_batch SET jumlah_retur = jumlah_retur + ' + IntToStr(jmlKembalikan) + 
                             ' WHERE id = ' + QuotedStr(pbId));

              // D. INSERT KARTU STOK (Sebagai barang MASUK)
              InsertKartuStok(
                dm.con1,
                StrToInt(obatId),
                StrToInt(batchId),
                qryBatchRetur.FieldByName('no_batch').AsString,
                Now,
                edtFaktur.Text,
                qryBatchRetur.FieldByName('tgl_expired').Value,
                qryBatchRetur.FieldByName('nie_number').AsString,
                'Retur_Penjualan',
                'Barang kembali dari konsumen (Faktur Jual: ' + edtFaktur.Text + ')',
                jmlKembalikan,  // Masuk
                0,              // Keluar
                'retur_jual',
                StrToInt(edtIdPenjualan.Text)
              );

              sisaRetur := sisaRetur - jmlKembalikan;
              qryBatchRetur.Next;
            end;
          finally
            qryBatchRetur.Free;
          end;

          Next;
        end;
      end;

      // 3. Update Header Penjualan (Total Harga & Item setelah retur)
      dm.con1.Execute('UPDATE tbl_penjualan p ' +
                     'SET p.jumlah_item = (SELECT COUNT(id) FROM tbl_detail_penjualan WHERE penjualan_id = p.id), ' +
                     'p.total = (SELECT SUM(harga_jual * jumlah_jual) FROM tbl_detail_penjualan WHERE penjualan_id = p.id), ' +
                     'p.status = ' + QuotedStr('selesai-retur') + 
                     ' WHERE p.id = ' + QuotedStr(edtIdPenjualan.Text));

      dm.con1.CommitTrans;
      MessageDlg('Transaksi Retur Penjualan Berhasil Disimpan', mtInformation, [mbOK], 0);
      FormShow(Sender);

    except
      on E: Exception do
      begin
        if dm.con1.InTransaction then dm.con1.RollbackTrans;
        MessageDlg('Kesalahan: ' + E.Message, mtError, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TfReturn.btnRetualAllClick(Sender: TObject);
begin
  fReturAll.edtKodeRetur.Text := edtKode.Text;
  fReturAll.edtFaktur.Text := edtFaktur.Text;
  fReturAll.edtIdPenjualan.Text := edtIdPenjualan.Text;
  
  fReturAll.ShowModal;
end;

end.
