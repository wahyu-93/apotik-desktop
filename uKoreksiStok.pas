unit uKoreksiStok;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, ComCtrls, StdCtrls, ExtCtrls, Buttons, jpeg;

type
  TSnapshotBatch = record
    BatchID  : Integer;
    NoBatch  : string;
    StokAwal : Integer;
  end;

  TFKoreksiStok = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    lbl2: TLabel;
    lbl3: TLabel;
    edtNoKoreksi: TEdit;
    edtKodeObat: TEdit;
    edtNamaObat: TEdit;
    btnCariObat: TBitBtn;
    bvl1: TBevel;
    pnl1: TPanel;
    lblStokSistem: TLabel;
    lbl4: TLabel;
    pnl2: TPanel;
    lblStokFisik: TLabel;
    lbl6: TLabel;
    pnl3: TPanel;
    lblSelisih: TLabel;
    lbl8: TLabel;
    dbgrd1: TDBGrid;
    lbl5: TLabel;
    lbl7: TLabel;
    lbl9: TLabel;
    cbbAlasan: TComboBox;
    mmoAlasan: TMemo;
    pnl4: TPanel;
    lbl10: TLabel;
    btnTambah: TBitBtn;
    edtIdObat: TEdit;
    lbl11: TLabel;
    edtStokFisik: TEdit;
    btnUpdateFisik: TBitBtn;
    edtIdBatch: TEdit;
    edtStokSistem: TEdit;
    btnAmbilSnapshot: TBitBtn;
    btnSelesai: TBitBtn;
    lbl12: TLabel;
    edtSelisih: TEdit;
    lbl13: TLabel;
    lbl14: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
    procedure btnCariObatClick(Sender: TObject);
    procedure cbbAlasanChange(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure edtStokFisikKeyPress(Sender: TObject; var Key: Char);
    procedure btnKeluarClick(Sender: TObject);
    procedure btnUpdateFisikClick(Sender: TObject);
    procedure btnAmbilSnapshotClick(Sender: TObject);
    procedure LoadDataObat(AObatID: Integer);
    procedure AmbilSnapshot(AObatID: Integer);
    procedure btnSelesaiClick(Sender: TObject);
    procedure edtStokFisikKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
    FSnapshot      : array of TSnapshotBatch;
    FJumlahBatch   : Integer;
    FObatID        : Integer;
    FSelectedBatchID    : Integer;
    FSelectedStokSistem : Integer;
  public
    { Public declarations }
  end;

var
  FKoreksiStok: TFKoreksiStok;

implementation

uses
  dataModule, uBantuObatPenjualan, StrUtils, ADODB, Math;

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
  dm.qryBatchKoreksi.Close;
  dm.qryBatchKoreksi.SQL.Text :=
    'SELECT ' +
    '  b.id, ' +
    '  b.no_batch, ' +
    '  b.tgl_expired, ' +
    '  b.jumlah_sisa AS stok_sistem, ' +
    '  b.jumlah_sisa AS stok_fisik, ' +
    '  0             AS selisih ' +
    'FROM tbl_batch b ' +
    'WHERE b.obat_id is NULL ' +
    '  AND b.status  = 1 ' +
    'ORDER BY b.tgl_expired ASC';
  dm.qryBatchKoreksi.Open;
end;

procedure TFKoreksiStok.AmbilSnapshot(AObatID: Integer);
var
  i : Integer;
begin
  FObatID := AObatID;

  // Load batch ke qryBatch
  dm.qryBatchSnap.Close;
  dm.qryBatchSnap.SQL.Text :=
    'SELECT id, no_batch, tgl_expired, jumlah_sisa ' +
    'FROM tbl_batch ' +
    'WHERE obat_id = ' + IntToStr(AObatID) +
    '  AND status = 1 ' +
    'ORDER BY tgl_expired ASC';
  dm.qryBatchSnap.Open;

  // Simpan snapshot ke memory
  FJumlahBatch := 0;
  SetLength(FSnapshot, 0);
  dm.qryBatchSnap.First;
  while not dm.qryBatchSnap.EOF do
    begin
      Inc(FJumlahBatch);                        
      SetLength(FSnapshot, FJumlahBatch);
      i := FJumlahBatch - 1;

      FSnapshot[i].BatchID  := dm.qryBatchSnap.FieldByName('id').AsInteger;
      FSnapshot[i].NoBatch  := dm.qryBatchSnap.FieldByName('no_batch').AsString;
      FSnapshot[i].StokAwal := dm.qryBatchSnap.FieldByName('jumlah_sisa').AsInteger;

      dm.qryBatchSnap.Next;
    end;
end;

procedure TFKoreksiStok.LoadDataObat(AObatID: Integer);
var
  sObatID : string;
  FStokSistem :Double;
  FObatID : Integer;
begin
  FObatID := AObatID;
  sObatID := IntToStr(AObatID);

  // 1. Ambil stok sistem (total batch)
  dm.qryTemp.Close;
  dm.qryTemp.SQL.Text :=
    'SELECT COALESCE(SUM(jumlah_sisa), 0) AS stok_sistem ' +
    'FROM tbl_batch ' +
    'WHERE obat_id = ' + sObatID +
    '  AND status = 1';
  dm.qryTemp.Open;

  FStokSistem := dm.qryTemp.FieldByName('stok_sistem').AsFloat;

  // 2. Tampilkan di panel info
  lblStokSistem.Caption := FormatFloat('###,###',FStokSistem);
  lblStokFisik.Caption  := '-';
  lblSelisih.Caption    := '-';

  // 3. Load grid batch
  dm.qryBatchKoreksi.Close;
  dm.qryBatchKoreksi.SQL.Text :=
    'SELECT ' +
    '  b.id, ' +
    '  b.no_batch, ' +
    '  b.tgl_expired, ' +
    '  b.jumlah_sisa AS stok_sistem, ' +
    '  b.jumlah_sisa AS stok_fisik, ' +
    '  0             AS selisih ' +
    'FROM tbl_batch b ' +
    'WHERE b.obat_id = ' + sObatID +
    '  AND b.status  = 1 ' +
    'ORDER BY b.tgl_expired ASC';
  dm.qryBatchKoreksi.Open;
end;

procedure TFKoreksiStok.FormCreate(Sender: TObject);
begin
  edtNoKoreksi.Enabled := false; edtNoKoreksi.Clear;
  edtKodeObat.Enabled := false; edtKodeObat.Clear;
  edtNamaObat.Enabled := false; edtNamaObat.Clear;

  btnTambah.Enabled := True;
  btnTambah.Caption :='Tambah';

  cbbAlasan.Enabled := False; cbbAlasan.Text := '';
  mmoAlasan.Clear; mmoAlasan.Enabled := False;

  btnCariObat.Enabled := false;
  btnKeluar.Enabled := True;

  lblStokSistem.Caption := '-';
  lblStokFisik.Caption := '-';
  lblSelisih.Caption := '-';

  edtStokFisik.Enabled := False;
  edtStokFisik.Clear;
  
  btnUpdateFisik.Enabled := false;

  edtSelisih.Clear;
  btnSelesai.Enabled := false;

  konek;
end;

procedure TFKoreksiStok.btnTambahClick(Sender: TObject);
var kode : string;
begin
  if btnTambah.Caption = 'Tambah' then
    begin
      btnCariObat.Enabled := True;
      btnTambah.Caption := 'Batal';
      btnKeluar.Enabled := false;

      with dm.qryLogKoreksi do
        begin
          close;
          sql.Clear;
          SQL.Text := 'select * from tbl_log_koreksi';
          Open;

          if IsEmpty then
            begin
              kode := '0001';
            end
          else
            begin
              Last;
              kode := RightStr(fieldbyname('no_koreksi').Text,4);
              kode := IntToStr(StrToInt(kode) + 1);
            end;
        end;

        edtNoKoreksi.Text := 'KRK-'+FormatDateTime('ddmmyyyy',Now)+FormatFloat('0000',StrToInt(kode));
    end
  else
   begin
     FormCreate(Sender);
   end;
end;

procedure TFKoreksiStok.btnCariObatClick(Sender: TObject);
begin
  fBantuObatPenjualan.edtType.Text := 'koreksiStok';
  fBantuObatPenjualan.ShowModal;
end;

procedure TFKoreksiStok.cbbAlasanChange(Sender: TObject);
begin
  if cbbAlasan.ItemIndex = 4 then
    begin
      mmoAlasan.Enabled := True;
      mmoAlasan.SetFocus;
    end
  else
    begin
      mmoAlasan.Enabled := False;
    end;
end;

procedure TFKoreksiStok.dbgrd1DblClick(Sender: TObject);
begin
  edtStokFisik.Enabled := True;
  edtStokFisik.Text := dbgrd1.Fields[4].AsString;
  edtIdBatch.Text := dbgrd1.Fields[0].AsString;
  edtStokSistem.Text := dbgrd1.Fields[3].AsString;
  edtSelisih.Text := '0';

  btnUpdateFisik.Enabled := True;
  btnSelesai.Enabled := false;
end;

procedure TFKoreksiStok.edtStokFisikKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8,#9,#13]) then key:=#0;
end;

procedure TFKoreksiStok.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TFKoreksiStok.btnUpdateFisikClick(Sender: TObject);
var iSelisih : Integer;
begin
  if edtStokFisik.Text = '' then
    begin
      MessageDlg('Stok Fisik Belum Diisi', mtInformation, [mbok],0);
      edtStokFisik.SetFocus;
      Exit;
    end;

  iSelisih := StrToInt(edtStokFisik.Text) - StrToInt(edtStokSistem.Text);

  //update tabel batc
  with dm.qryBatchObat do
    begin
      close;
      sql.Clear;
      sql.Text := 'UPDATE tbl_batch SET jumlah_sisa = ' + edtStokFisik.Text +
                  ' WHERE id = ' + edtIdBatch.Text;
      ExecSQL;
    end;

  LoadDataObat(StrToInt(edtIdObat.Text));

  btnUpdateFisik.Enabled := false;
  
  cbbAlasan.Enabled := true;
  mmoAlasan.Enabled := false;
  btnSelesai.Enabled := True;
  btnTambah.Enabled := false;
  btnCariObat.Enabled := False;

  MessageDlg('Jumlah Fisik berhasiil di Update',mtInformation, [mbok],0);
end;

procedure TFKoreksiStok.btnAmbilSnapshotClick(Sender: TObject);
begin
  AmbilSnapshot(StrToInt(edtIdObat.Text));
  LoadDataObat(StrToInt(edtIdObat.Text));

  cbbAlasan.Enabled := True;
  cbbAlasan.SetFocus;

end;

procedure TFKoreksiStok.btnSelesaiClick(Sender: TObject);
var
  i: Integer;
  alasan, alasanKeterangan: string;
  iStokSekarang: Integer;
  iSelisih: Integer;
  bAdaPerubahan: Boolean;
begin
  // 1. VALIDASI INPUT
  if cbbAlasan.Text = '' then
  begin
    MessageDlg('Alasan Belum Dipilih', mtInformation, [mbOK], 0);
    cbbAlasan.SetFocus;
    Exit;
  end;

  if (cbbAlasan.ItemIndex = 4) and (Trim(mmoAlasan.Text) = '') then
  begin
    MessageDlg('Keterangan Belum Diisi untuk alasan Lainnya', mtInformation, [mbOK], 0);
    mmoAlasan.Enabled := True;
    mmoAlasan.SetFocus;
    Exit;
  end;

  // Penentuan kode alasan untuk database
  case cbbAlasan.ItemIndex of
    0: alasan := 'stock_opname';
    1: alasan := 'obat_rusak';
    2: alasan := 'obat_expired';
    3: alasan := 'selisih_hitung';
    4: alasan := 'lainnya';
  end;

  if Trim(mmoAlasan.Text) = '' then
    alasanKeterangan := 'NULL'
  else
    alasanKeterangan := QuotedStr(mmoAlasan.Text);

  // 2. CEK APAKAH ADA PERUBAHAN (SNAPSHOT VS DATABASE TERBARU)
  bAdaPerubahan := False;
  for i := 0 to FJumlahBatch - 1 do
  begin
    dm.qryTemp.Close;
    dm.qryTemp.SQL.Text := 'SELECT jumlah_sisa FROM tbl_batch WHERE id = ' + 
                           IntToStr(FSnapshot[i].BatchID);
    dm.qryTemp.Open;

    if dm.qryTemp.FieldByName('jumlah_sisa').AsInteger <> FSnapshot[i].StokAwal then
    begin
      bAdaPerubahan := True;
      Break;
    end;
  end;

  if not bAdaPerubahan then
  begin
    ShowMessage('Tidak ada perubahan stok yang perlu disimpan (Stok fisik sama dengan sistem)');
    Exit;
  end;

  // 3. PROSES SIMPAN (TRANSACTION)
  dm.con1.BeginTrans;
  try
    for i := 0 to FJumlahBatch - 1 do
    begin
      // Ambil data batch terbaru dari database (karena sudah diupdate btnUpdateFisik)
      dm.qryTemp.Close;
      dm.qryTemp.SQL.Text := 'SELECT * FROM tbl_batch WHERE id = ' + 
                             IntToStr(FSnapshot[i].BatchID);
      dm.qryTemp.Open;

      iStokSekarang := dm.qryTemp.FieldByName('jumlah_sisa').AsInteger;
      iSelisih      := iStokSekarang - FSnapshot[i].StokAwal;

      // Lewati jika batch ini tidak ada perubahan
      if iSelisih = 0 then Continue;

      // A. INSERT ke tbl_log_koreksi (Audit Trail)
      dm.con1.Execute(
        'INSERT INTO tbl_log_koreksi (no_koreksi, obat_id, batch_id, stok_sebelum, ' +
        'stok_sesudah, selisih, alasan_kode, alasan_detail, user_id) ' +
        'VALUES (' + 
        QuotedStr(edtNoKoreksi.Text) + ', ' +
        IntToStr(FObatID) + ', ' +
        IntToStr(FSnapshot[i].BatchID) + ', ' +
        IntToStr(FSnapshot[i].StokAwal) + ', ' +
        IntToStr(iStokSekarang) + ', ' +
        IntToStr(iSelisih) + ', ' +
        QuotedStr(alasan) + ', ' +
        alasanKeterangan + ', ' +
        dm.qryUser.FieldByName('id').AsString + ')'
      );

      // B. INSERT ke KARTU STOK (tbl_stok) via prosedur global
      // Jika selisih > 0 (stok bertambah) -> Masuk. Jika < 0 (stok berkurang) -> Keluar.
      InsertKartuStok(
        dm.con1,
        FObatID,
        FSnapshot[i].BatchID,
        dm.qryTemp.FieldByName('no_batch').AsString,
        Now,
        edtNoKoreksi.Text,
        dm.qryTemp.FieldByName('tgl_expired').Value,
        dm.qryTemp.FieldByName('nie_number').AsString,
        'Koreksi',
        'Alasan: ' + cbbAlasan.Text + ' (' + mmoAlasan.Text + ')',
        IfThen(iSelisih > 0, Abs(iSelisih), 0), // Kolom Masuk
        IfThen(iSelisih < 0, Abs(iSelisih), 0), // Kolom Keluar
        'koreksi',
        0 // Tidak ada ID pembelian/penjualan terkait
      );
    end;

    // 4. UPDATE MASTER STOK (tbl_obat)
    // Memastikan total stok di tabel obat sinkron dengan jumlah seluruh batch aktif
    dm.con1.Execute(
      'UPDATE tbl_obat SET stok = (' +
      '  SELECT COALESCE(SUM(jumlah_sisa), 0) FROM tbl_batch ' +
      '  WHERE obat_id = ' + IntToStr(FObatID) + ' AND status = 1' +
      ') WHERE id = ' + IntToStr(FObatID)
    );

    dm.con1.CommitTrans;
    MessageDlg('Koreksi stok berhasil disimpan dan Kartu Stok diperbarui!', mtInformation, [mbOK], 0);

    // Reset Form ke kondisi awal
    FormCreate(Sender);

  except
    on E: Exception do
    begin
      if dm.con1.InTransaction then dm.con1.RollbackTrans;
      MessageDlg('Gagal menyimpan koreksi: ' + E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TFKoreksiStok.edtStokFisikKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Trim(edtStokFisik.Text) = '' then
    begin
      edtSelisih.Text := '';
      Exit;
    end;
  edtSelisih.Text := IntToStr(StrToInt(edtStokFisik.Text) - StrToInt(edtStokSistem.Text));
end;

procedure TFKoreksiStok.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F1: btnTambah.Click;
    VK_F2: btnCariObat.Click;
    VK_F10: btnKeluar.Click;
  end;
end;

end.
