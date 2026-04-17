unit uForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, Grids, DBGrids, ComCtrls, StdCtrls, jpeg;

type
  TFMenu = class(TForm)
    mm1: TMainMenu;
    Master1: TMenuItem;
    Barang1: TMenuItem;
    Supplier1: TMenuItem;
    ransaksi1: TMenuItem;
    Setting1: TMenuItem;
    Keluar1: TMenuItem;
    Pembelian1: TMenuItem;
    Penjualan1: TMenuItem;
    Obat1: TMenuItem;
    Supplier2: TMenuItem;
    SettingHargaJual1: TMenuItem;
    stat1: TStatusBar;
    tmr1: TTimer;
    img1: TImage;
    Pengguna1: TMenuItem;
    Apotik1: TMenuItem;
    tmr2: TTimer;
    Laporan1: TMenuItem;
    LaporanPembelian1: TMenuItem;
    LaporanPenjualan1: TMenuItem;
    LaporanStok1: TMenuItem;
    LaporanItemLaris1: TMenuItem;
    ListPembelian2: TMenuItem;
    Pembelian2: TMenuItem;
    ListPenjualan2: TMenuItem;
    Penjualan2: TMenuItem;
    ReturPenjualan1: TMenuItem;
    ListReturPenjualan1: TMenuItem;
    ReturPenjualan2: TMenuItem;
    RefreshDashboard1: TMenuItem;
    N1: TMenuItem;
    LabaPenjualan1: TMenuItem;
    ReturPembelian1: TMenuItem;
    ListReturPembelian1: TMenuItem;
    ReturPembelian2: TMenuItem;
    LaporanRetur1: TMenuItem;
    BackupDatabase1: TMenuItem;
    BersihkanTabel1: TMenuItem;
    KartuStokObat1: TMenuItem;
    KoreksStok1: TMenuItem;
    lbl1: TLabel;
    lbl6: TLabel;
    lblJam: TLabel;
    lbl5: TLabel;
    lbl2: TLabel;
    lblTotalPembelian: TLabel;
    lbl4: TLabel;
    lblTotalPenjualan: TLabel;
    lbl8: TLabel;
    lblTotalReturPembelian: TLabel;
    lbl10: TLabel;
    lblTtlReturPenjualan: TLabel;
    lbl7: TLabel;
    lblTtlSupplier: TLabel;
    lbl12: TLabel;
    lblTtlObat: TLabel;
    lbl18: TLabel;
    lblTtlStok: TLabel;
    lbl20: TLabel;
    lblTtlExp: TLabel;
    procedure Keluar1Click(Sender: TObject);
    procedure Barang1Click(Sender: TObject);
    procedure Supplier1Click(Sender: TObject);
    procedure Supplier2Click(Sender: TObject);
    procedure Obat1Click(Sender: TObject);
    procedure SettingHargaJual1Click(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Pengguna1Click(Sender: TObject);
    procedure Apotik1Click(Sender: TObject);
    procedure tmr2Timer(Sender: TObject);
    procedure LaporanPembelian1Click(Sender: TObject);
    procedure LaporanPenjualan1Click(Sender: TObject);
    procedure LaporanStok1Click(Sender: TObject);
    procedure LaporanItemLaris1Click(Sender: TObject);
    procedure ListPembelian2Click(Sender: TObject);
    procedure Pembelian2Click(Sender: TObject);
    procedure ListPenjualan2Click(Sender: TObject);
    procedure Penjualan2Click(Sender: TObject);
    procedure ReturPenjualan2Click(Sender: TObject);
    procedure ListReturPenjualan1Click(Sender: TObject);
    procedure RefreshDashboard1Click(Sender: TObject);
    procedure LabaPenjualan1Click(Sender: TObject);
    procedure lblTotalPembelianClick(Sender: TObject);
    procedure lblTotalPenjualanClick(Sender: TObject);
    procedure lblTtlSupplierClick(Sender: TObject);
    procedure lblTtlObatClick(Sender: TObject);
    procedure lblTtlStokClick(Sender: TObject);
    procedure lblTtlExpClick(Sender: TObject);
    procedure lblTtlReturPenjualanClick(Sender: TObject);
    procedure ReturPembelian2Click(Sender: TObject);
    procedure ListReturPembelian1Click(Sender: TObject);
    procedure lblTotalReturPembelianClick(Sender: TObject);
    procedure LaporanRetur1Click(Sender: TObject);
    procedure BackupDatabase1Click(Sender: TObject);
    procedure BersihkanTabel1Click(Sender: TObject);
    procedure KartuStokObat1Click(Sender: TObject);
    procedure KoreksStok1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMenu: TFMenu;

implementation

uses
  uJenisObat, uSatuan, uSupplier, uObat, uPembelian, uPembayaranPembelian, 
  uPenjualan, uSetHarga, dataModule, uPengguna, uSetting, uListPenjualan, 
  uLaporanPembelian, uListJualObat, uLaporanStok, uLaporanItemTerjual, uReturn, 
  uListReturPenjualan, u_labaPenjualan, DB, u_dashboardPembelian, 
  u_dashboardPenjualan, u_dashboardSupplier, u_dashboardObat, 
  u_dashboardObatStok, u_dashboardExp, u_dashboardReturPenjualan, 
  u_returPembelian, u_listReturPembelian, u_dashboardReturPembelian, 
  u_laporanRetur, uBackup, ADODB, uKartuStok, uKoreksiStok;

{$R *.dfm}

function hari (vtgl : TDate):string;
var a : Integer;
const
  nama_hari: array[1..7] of string = ('Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jum''at', 'Sabtu');
begin
  for a:=1 to 7 do
   begin
     LongDayNames[a] := nama_hari[a];
   end;

  Result := FormatDateTime('dddd',vtgl);
end;

procedure TFMenu.Keluar1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFMenu.Barang1Click(Sender: TObject);
begin
  fJenisObat.ShowModal;
end;

procedure TFMenu.Supplier1Click(Sender: TObject);
begin
  FSatuan.ShowModal;
end;

procedure TFMenu.Supplier2Click(Sender: TObject);
begin
  Fsupplier.Show;
end;

procedure TFMenu.Obat1Click(Sender: TObject);
begin
  Fobat.ShowModal;
end;

procedure TFMenu.SettingHargaJual1Click(Sender: TObject);
begin
  fSetHarga.ShowModal;
end;

procedure TFMenu.tmr1Timer(Sender: TObject);
begin
  FormShow(Sender);
end;

procedure TFMenu.FormShow(Sender: TObject);
begin
  stat1.Panels[0].Text := 'Pengguna : ' + dm.qryUser.FieldByName('nama').AsString;
  stat1.Panels[1].Text := 'Role : ' + dm.qryUser.fieldByname('role').AsString;

  lbl6.Caption := 'Selamat Datang, '+ dm.qryUser.fieldbyname('nama').AsString+' !';
  lbl1.Caption := dm.qrySetting.fieldbyname('nama_toko').AsString;

  //total penjualan
  with dm.qryTotalPenjualan do
    begin
      close;
      sql.Clear;
      sql.Text := 'select count(id) as jml_transaksi from tbl_penjualan where tgl_penjualan like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%''';
      Open;

     if FieldByName('jml_transaksi').AsInteger > 0 then
      begin
          lblTotalPenjualan.Caption := FormatFloat('###,###;(###,###);###,###', dm.qryTotalPenjualan.fieldbyname('jml_transaksi').AsFloat);
      end
     else
      begin
        lblTotalPenjualan.Caption := '0';
      end;
    end;

  //total pembelian
  with dm.qryTotalPembelian do
    begin
      close;
      sql.Clear;
      sql.Text := 'select count(id) as jml_transaksifrom from tbl_pembelian where tgl_pembelian like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%''';
      Open;

      if FieldByName('jml_transaksifrom').AsInteger > 0 then
        begin
          lblTotalPembelian.Caption := FormatFloat('###,###;(###,###);###,###', dm.qryTotalPembelian.fieldbyname('jml_transaksifrom').AsFloat);
        end
      else
        begin
          lblTotalPembelian.Caption := '0';
        end;
    end;

  //alert stok
  with dm.qryDashObat do
    begin
      Close;
      sql.Clear;
      SQL.Text := 'select count(id) as jumlah from tbl_obat where stok < 5';
      Open;

      if FieldByName('jumlah').AsInteger = 0 then
        begin
          lblTtlStok.Caption := '0';
        end
      else
        begin
          lblTtlStok.Caption := FormatFloat('###,###;(###,###);###,###',fieldbyname('jumlah').AsFloat);
        end;
    end;

    //alert exp
    with dm.qryDashExp do
      begin
        close;
        sql.Clear;
        sql.Text := 'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id = b.id where (DATEDIFF(b.tgl_exp,now())) < 100 ';
        Open;

        if IsEmpty then
          begin
            lblTtlExp.Caption := '0';
          end
        else
          begin
           lblTtlExp.Caption := FormatFloat('###,###;(###,###);###,###', RecordCount);
          end;
      end;

    // dashboard ttl obat
    with dm.qryDashhObat do
      begin
        close;
        SQL.Clear;
        SQL.Text := 'select count(id) as jumlah from tbl_obat';
        Open;

        if FieldByName('jumlah').AsInteger > 0 then
          begin
            lblTtlObat.Caption := FormatFloat('###,###;(###,###);###,###', fieldbyname('jumlah').AsFloat);
          end
        else
          begin
            lblTtlObat.Caption := '0';
          end;
      end;

    // dashboard supplier
    with dm.qryDashSupplier do
      begin
        Close;
        sql.Clear;
        SQL.Text := 'select count(id) as jumlah from tbl_supplier';
        Open;

        if FieldByName('jumlah').AsInteger > 0 then
          begin
            lblTtlSupplier.Caption := FormatFloat('###,###;(###,###);###,###',fieldbyname('jumlah').AsFloat);
          end
        else
          begin
            lblTtlSupplier.Caption := '0';
          end;
      end;

    // dashboard retur penjualan
    with dm.qryDashReturPenjualan do
      begin
        close;
        sql.Clear;
        SQL.Text := 'select count(id) as jumlah from tbl_retur where tgl_retur like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%'' and jenis_retur = '+QuotedStr('penjualan')+'';
        Open;

        if FieldByName('jumlah').AsInteger > 0then
          begin
             lblTtlReturPenjualan.Caption := FormatFloat('###,###;(###,###);###,###',fieldbyname('jumlah').AsFloat);
          end
        else
          begin
            lblTtlReturPenjualan.Caption := '0';
          end;
      end;

    // dashboard retur pembelian
    with dm.qryDashReturPembelian do
      begin
        close;
        sql.Clear;
        SQL.Text := 'select count(id) as jumlah from tbl_retur where tgl_retur like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%'' and jenis_retur = '+QuotedStr('pembelian')+'';
        Open;

        if FieldByName('jumlah').AsInteger > 0then
          begin
             lblTotalReturPembelian.Caption := FormatFloat('###,###;(###,###);###,###',fieldbyname('jumlah').AsFloat);
          end
        else
          begin
            lblTotalReturPembelian.Caption := '0';
          end;
      end;
end;

procedure TFMenu.Pengguna1Click(Sender: TObject);
begin
  fPengguna.ShowModal;
end;

procedure TFMenu.Apotik1Click(Sender: TObject);
begin
  fSetting.ShowModal;
end;

procedure TFMenu.tmr2Timer(Sender: TObject);
begin
  stat1.Panels[2].Text := 'Tanggal ' + FormatDateTime('dd-mm-yyyy',Now) + ' : ' + TimeToStr(Now);
  lblJam.Caption := hari(Now)+', '+FormatDateTime('dd mmmm yyyy',Now) + ' - ' + TimeToStr(Now);
end;

procedure TFMenu.LaporanPembelian1Click(Sender: TObject);
begin
  fLaporanPembelian.ShowModal;
end;

procedure TFMenu.LaporanPenjualan1Click(Sender: TObject);
begin
  fLaporanPenjualan.ShowModal;
end;

procedure TFMenu.LaporanStok1Click(Sender: TObject);
begin
  fLaporanStok.ShowModal;
end;

procedure TFMenu.LaporanItemLaris1Click(Sender: TObject);
begin
  fLaporanJumlahItemTerjual.ShowModal;
end;

procedure TFMenu.ListPembelian2Click(Sender: TObject);
begin
  fPembayaranPembelian.ShowModal;
end;

procedure TFMenu.Pembelian2Click(Sender: TObject);
begin
  fPembelian.ShowModal;
end;

procedure TFMenu.ListPenjualan2Click(Sender: TObject);
begin
  fListPenjualan.ShowModal;
end;

procedure TFMenu.Penjualan2Click(Sender: TObject);
begin
  Fpenjualan.ShowModal;
end;

procedure TFMenu.ReturPenjualan2Click(Sender: TObject);
begin
  fReturn.ShowModal;  
end;

procedure TFMenu.ListReturPenjualan1Click(Sender: TObject);
begin
  fListReturPenjualan.ShowModal;
end;

procedure TFMenu.RefreshDashboard1Click(Sender: TObject);
begin
  FormShow(Sender);
end;

procedure TFMenu.LabaPenjualan1Click(Sender: TObject);
begin
  fLabaPenjualan.ShowModal;
end;

procedure TFMenu.lblTotalPembelianClick(Sender: TObject);
begin
  fDashboardPembelian.ShowModal;
end;

procedure TFMenu.lblTotalPenjualanClick(Sender: TObject);
begin
  fDashboardPenjualan.ShowModal;
end;

procedure TFMenu.lblTtlSupplierClick(Sender: TObject);
begin
  fDashboardSupplier.ShowModal;
end;

procedure TFMenu.lblTtlObatClick(Sender: TObject);
begin
  fDashboardObat.ShowModal;
end;

procedure TFMenu.lblTtlStokClick(Sender: TObject);
begin
  fDashboardObatStok.ShowModal;
end;

procedure TFMenu.lblTtlExpClick(Sender: TObject);
begin
  fDashboardExp.ShowModal;
end;

procedure TFMenu.lblTtlReturPenjualanClick(Sender: TObject);
begin
  fDashboardReturPenjualan.ShowModal;
end;

procedure TFMenu.ReturPembelian2Click(Sender: TObject);
begin
  fReturPembelian.ShowModal;
end;

procedure TFMenu.ListReturPembelian1Click(Sender: TObject);
begin
  fListReturPembelian.ShowModal;
end;

procedure TFMenu.lblTotalReturPembelianClick(Sender: TObject);
begin
   fDashboardListPembelian.ShowModal;
end;

procedure TFMenu.LaporanRetur1Click(Sender: TObject);
begin
  fLaporanRetur.ShowModal;
end;

procedure TFMenu.BackupDatabase1Click(Sender: TObject);
begin
  fbackup.ShowModal;
end;

{procedure TFMenu.BersihkanTabel1Click(Sender: TObject);
var tahun, bulan, faktur, newfaktur, idFaktur, newIdFaktur : string;
    a : Integer;
begin
  MessageDlg('Pastikan Backup Database Sebelum Melanjutkan Proses',mtConfirmation,[mbOK],0);
  if MessageDlg('Yakin Proses Dilanjutkan?', mtConfirmation, [mbYes,mbNo],0)=mryes then
    begin
      tahun := FormatDateTime('yyyy',Now);
      bulan := FormatDateTime('mm', Now);
      
      with dm.qryHapusPenjualan do
        begin
          close;
          SQL.Clear;
          SQL.Text := 'select * from tbl_penjualan where tgl_penjualan not like ''%'+tahun+'%''';
          Open;

          faktur := '(';
          idFaktur := '(';

          for a:=1 to RecordCount do
            begin
              RecNo:= a;
              faktur := faktur + ''''+fieldbyname('no_faktur').AsString +''',';
              idFaktur := idFaktur + ''''+fieldbyname('id').AsString +''',';
            end;
            a:=a+1;

            newfaktur := Copy(faktur,1,Length(faktur)-1);
            newfaktur := newfaktur + ')';

            newIdFaktur := Copy(idFaktur,1,Length(idFaktur)-1);
            newIdFaktur := newIdFaktur + ')';
        end;

        // hapus table stok
        with dm.qryHapusStok do
          begin
            close;
            sql.Clear;
            SQL.Text := 'delete from tbl_stok where no_faktur in'+ newfaktur;
            ExecSQL;
          end;

        // hapus table detail penjualan
        with dm.qryHapusDetailPenjualan do
          begin
            close;
            sql.Clear;
            sql.Text := 'delete from tbl_detail_penjualan where penjualan_id in'+newIdFaktur;
            ExecSQL;
          end;

        // hapus table penjualan
        with dm.qryHapusPenjualan do
          begin
            close;
            sql.Clear;
            sql.Text := 'delete from tbl_penjualan where id in'+newIdFaktur;
            ExecSQL;
          end;      

        MessageDlg('Proses Sukses',mtInformation,[mbok],0);
    end;
end; }

procedure TFMenu.BersihkanTabel1Click(Sender: TObject);
var
  sBatasTanggal : string;   // batas tanggal arsip (1 tahun lalu)
  sBulanSnapshot: string;   // bulan snapshot, format YYYY-MM-01
  iJmlPenjualan : Integer;  // jumlah record yang akan diarsip
begin
  { -- Konfirmasi dua tahap -- }
  MessageDlg(
    'Pastikan Backup Database sudah dilakukan sebelum melanjutkan!',
    mtWarning, [mbOK], 0
  );
 
  if MessageDlg(
    'Proses akan mengarsip data penjualan lebih dari 1 tahun lalu.' + #13#10 +
    'Data dipindah ke tabel arsip sebelum dihapus.' + #13#10#13#10 +
    'Lanjutkan?',
    mtConfirmation, [mbYes, mbNo], 0
  ) <> mrYes then
    Exit;
 
  { -- Hitung batas tanggal: hari ini dikurangi 12 bulan -- }
  sBatasTanggal  := FormatDateTime('yyyy-mm-dd', IncMonth(Now));
  sBulanSnapshot := FormatDateTime('yyyy-mm-01', Now);
  ShowMessage(sBatasTanggal);
  Screen.Cursor := crHourGlass;
  try
 
    { ============================================================
      LANGKAH 1: Cek dulu ada data yang perlu diarsip atau tidak
      Hindari error SQL jika ternyata kosong
      ============================================================ }
    with dm.qryHapusPenjualan do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT COUNT(*) AS jml FROM tbl_penjualan ' +
        'WHERE tgl_penjualan < ' + QuotedStr(sBatasTanggal);
      Open;
      iJmlPenjualan := FieldByName('jml').AsInteger;
      Close;
    end;
 
    if iJmlPenjualan = 0 then
    begin
      Screen.Cursor := crDefault;
      MessageDlg(
        'Tidak ada data sebelum ' + sBatasTanggal + ' yang perlu diarsip.',
        mtInformation, [mbOK], 0
      );
      Exit;
    end;
 
    { ============================================================
      LANGKAH 2: Buat snapshot saldo stok sebelum data dihapus
      Snapshot ini menjaga kartu stok tetap akurat setelah arsip
      ============================================================ }
    with dm.qryHapusPenjualan do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'INSERT INTO tbl_stok_snapshot ' +
        '  (bulan, obat_id, batch_id, no_batch, saldo_masuk, saldo_keluar, saldo_akhir) ' +
        'SELECT ' +
        '  ' + QuotedStr(sBulanSnapshot) + ' AS bulan, ' +
        '  b.obat_id, ' +
        '  b.id AS batch_id, ' +
        '  b.no_batch, ' +
        '  COALESCE(SUM(dp.jumlah_beli), 0) AS saldo_masuk, ' +
        '  COALESCE(SUM(pb.jumlah), 0)      AS saldo_keluar, ' +
        '  COALESCE(SUM(dp.jumlah_beli), 0) - COALESCE(SUM(pb.jumlah), 0) AS saldo_akhir ' +
        'FROM tbl_batch b ' +
        'LEFT JOIN tbl_detail_pembelian dp ON dp.obat_id = b.obat_id ' +
        '                                 AND dp.pembelian_id = b.pembelian_id ' +
        'LEFT JOIN tbl_penjualan_batch pb  ON pb.batch_id = b.id ' +
        'LEFT JOIN tbl_penjualan pj        ON pj.id = pb.penjualan_id ' +
        '                                 AND pj.tgl_penjualan < ' + QuotedStr(sBatasTanggal) +
        'GROUP BY b.obat_id, b.id, b.no_batch ' +
        'ON DUPLICATE KEY UPDATE ' +
        '  saldo_masuk  = VALUES(saldo_masuk), ' +
        '  saldo_keluar = VALUES(saldo_keluar), ' +
        '  saldo_akhir  = VALUES(saldo_akhir), ' +
        '  dibuat_pada  = NOW()';
      ExecSQL;
    end;
 
    { ============================================================
      LANGKAH 3: Arsip header penjualan lama
      ============================================================ }
    with dm.qryHapusPenjualan do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'INSERT INTO arsip_penjualan ' +
        'SELECT * FROM tbl_penjualan ' +
        'WHERE tgl_penjualan < ' + QuotedStr(sBatasTanggal);
      ExecSQL;
    end;
 
    { ============================================================
      LANGKAH 4: Arsip detail penjualan lama
      (join ke penjualan supaya filter tanggalnya tepat)
      ============================================================ }
    with dm.qryHapusDetailPenjualan do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'INSERT INTO arsip_detail_penjualan ' +
        'SELECT d.* FROM tbl_detail_penjualan d ' +
        'JOIN tbl_penjualan p ON p.id = d.penjualan_id ' +
        'WHERE p.tgl_penjualan < ' + QuotedStr(sBatasTanggal);
      ExecSQL;
    end;
 
    { ============================================================
      LANGKAH 5: Hapus stok terkait penjualan lama
      Harus hapus ini SEBELUM hapus detail dan penjualan
      ============================================================ }
    with dm.qryHapusStok do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'DELETE s FROM tbl_stok s ' +
        'JOIN tbl_penjualan p ON p.no_faktur = s.no_faktur ' +
        'WHERE p.tgl_penjualan < ' + QuotedStr(sBatasTanggal);
      ExecSQL;
    end;
 
    { ============================================================
      LANGKAH 6: Hapus detail penjualan lama
      ============================================================ }
    with dm.qryHapusDetailPenjualan do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'DELETE d FROM tbl_detail_penjualan d ' +
        'JOIN tbl_penjualan p ON p.id = d.penjualan_id ' +
        'WHERE p.tgl_penjualan < ' + QuotedStr(sBatasTanggal);
      ExecSQL;
    end;
 
    { ============================================================
      LANGKAH 7: Hapus header penjualan lama (terakhir!)
      ============================================================ }
    with dm.qryHapusPenjualan do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'DELETE FROM tbl_penjualan ' +
        'WHERE tgl_penjualan < ' + QuotedStr(sBatasTanggal);
      ExecSQL;
    end;
 
    Screen.Cursor := crDefault;
    MessageDlg(
      'Proses arsip selesai.' + #13#10 +
      IntToStr(iJmlPenjualan) + ' transaksi dipindah ke tabel arsip.' + #13#10 +
      'Data sebelum ' + sBatasTanggal + ' telah dihapus dari tabel aktif.',
      mtInformation, [mbOK], 0
    );
 
  except
    on E: Exception do
    begin
      Screen.Cursor := crDefault;
      MessageDlg(
        'Terjadi error saat proses arsip:' + #13#10 + E.Message + #13#10#13#10 +
        'Periksa apakah tabel arsip sudah dibuat (jalankan 00_Setup_Tabel_Arsip.sql)',
        mtError, [mbOK], 0
      );
    end;
  end;
end;

procedure TFMenu.KartuStokObat1Click(Sender: TObject);
begin
  fKartuStok.ShowModal;
end;

procedure TFMenu.KoreksStok1Click(Sender: TObject);
begin
  FKoreksiStok.ShowModal;
end;

end.
