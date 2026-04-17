unit u_labaPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, jpeg, ComCtrls, DB;

type
  TfLabaPenjualan = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    pnl1: TPanel;
    lblJumlah: TLabel;
    rbTanggal: TRadioButton;
    rbBulan: TRadioButton;
    dtp1: TDateTimePicker;
    cbbBulan: TComboBox;
    cbbTahun: TComboBox;
    btnLap: TBitBtn;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    dbgrd1: TDBGrid;
    dbgrd2: TDBGrid;
    pnl2: TPanel;
    lbl2: TLabel;
    lblPendapatanEceran: TLabel;
    pnl3: TPanel;
    lbl3: TLabel;
    lblHPPEceran: TLabel;
    pnl4: TPanel;
    lbl4: TLabel;
    lblLabaEceran: TLabel;
    pnl5: TPanel;
    lbl5: TLabel;
    lblHPPGrosir: TLabel;
    pnl6: TPanel;
    lbl7: TLabel;
    lblPendapatanGrosir: TLabel;
    pnl7: TPanel;
    lbl9: TLabel;
    lblLabaGrosir: TLabel;
    lblTitleTotalLaba: TLabel;
    lbl6: TLabel;
    procedure btnKeluarClick(Sender: TObject);
    procedure btnLapClick(Sender: TObject);
    procedure cbbBulanKeyPress(Sender: TObject; var Key: Char);
    procedure rbBulanClick(Sender: TObject);
    procedure rbTanggalClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure BukaDetail(jenisHarga: string);
    procedure dbgrd2DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLabaPenjualan: TfLabaPenjualan;
  total : real;
  a : Integer;
  query, queryGrosir : string;
  
implementation

uses
  dataModule, uDetailObatBatch;

{$R *.dfm}

procedure konekBatchDetail(
  AObatID, ANamaObat, AJenisHarga : string;
  AIsPertanggal, AIsPerbulam      : Boolean;
  ATanggal                        : string;
  ABulan                          : Integer;
  ATahun                          : string
);
var
  filterTgl : string;
  totalJual, totalHPP, totalLaba, totalPendapatan : Double;
begin

  // bangun filter tanggal sesuai pilihan di form utama
  if AIsPertanggal then
    filterTgl := 'DATE(z.tgl_penjualan) = ' + QuotedStr(ATanggal)
  else if AIsPerbulam and (ABulan > 0) then
    filterTgl := 'MONTH(z.tgl_penjualan) = ' + IntToStr(ABulan) +
                 ' AND YEAR(z.tgl_penjualan) = ' + ATahun
  else
    filterTgl := 'YEAR(z.tgl_penjualan) = ' + QuotedStr(ATahun);

  totalJual := 0;
  totalHPP := 0;
  totalLaba := 0;
  totalPendapatan :=0;

  with dm.qryDetailBatch do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT ' +
        '  a.obat_id, ' +
        '  b.kode, ' +
        '  b.nama_obat, ' +

        '  pb.batch_id, ' +
        '  bt.no_batch, ' +
        '  bt.tgl_expired, ' +

        '  pb.jumlah AS qty_batch, ' +

        '  CASE ' +
        '    WHEN pb.harga_beli > 0 THEN pb.harga_beli ' +
        '    ELSE c.harga_beli_terakhir ' +
        '  END AS harga_beli, ' +

        '  a.harga_jual, ' +

        '  (pb.jumlah * a.harga_jual) AS total_jual, ' +

        '  (pb.jumlah * ( ' +
        '    a.harga_jual - ' +
        '    CASE ' +
        '      WHEN pb.harga_beli > 0 THEN pb.harga_beli ' +
        '      ELSE c.harga_beli_terakhir ' +
        '    END ' +
        '  )) AS laba_batch, ' +

        '  a.jenis_harga, ' +
        '  z.tgl_penjualan ' +

        'FROM tbl_penjualan_batch pb ' +

        'JOIN tbl_detail_penjualan a ON pb.detail_penjualan_id = a.id ' +
        'JOIN tbl_penjualan z ON z.id = pb.penjualan_id ' +
        'JOIN tbl_obat b ON a.obat_id = b.id ' +

        'LEFT JOIN tbl_batch bt ON bt.id = pb.batch_id ' +
        'LEFT JOIN tbl_harga_jual c ON c.obat_id = b.id ' +

        'WHERE ' + filterTgl + ' ' +
        '  AND a.jenis_harga = ' + QuotedStr(AJenisHarga) + ' ' +
        '  AND a.status IS NULL ' +
        '  AND a.obat_id = ' + AObatID + ' ' +

        'ORDER BY bt.id';

      Open;

      if not IsEmpty then
        begin
          First;

          FDetailObatBatch.lblDetailBatch.Caption   := 'Detail Batch - ' + ANamaObat + ' ('+ AJenisHarga +')';

          // info obat dari record pertama
          FDetailObatBatch.lblKodeObat.Caption   := 'Kode Obat : ' + FieldByName('kode').AsString;
          FDetailObatBatch.lblHargaJual.Caption  := 'Harga Jual : ' + FormatFloat('Rp. ###,###,###', FieldByName('harga_jual').AsFloat);

          while not Eof do
            begin
              totalJual := totalJual + FieldByName('qty_batch').AsFloat;
              totalPendapatan := totalPendapatan + FieldByName('total_jual').AsFloat;
              totalHPP  := totalHPP  + (FieldByName('harga_beli').AsFloat *
                                        FieldByName('qty_batch').AsFloat);
              totalLaba := totalLaba + FieldByName('laba_batch').AsFloat;
              dm.qryDetailBatch.Next;
            end;

          FDetailObatBatch.lblJumlahTerjual.Caption    := 'Jumlah Terjual : ' + FormatFloat('###,###,###', totalJual) + ' Pcs';
          FDetailObatBatch.lblTotalHPP.Caption         := 'RP. ' + FormatFloat('Rp. ###,###,###', totalHPP);
          FDetailObatBatch.lblTotalPendapatan.Caption  := 'Rp. ' + FormatFloat('Rp. ###,###,###', totalPendapatan);
          FDetailObatBatch.lblTotalLaba.Caption        := 'Rp. ' + FormatFloat('Rp. ###,###,###', totalLaba);
        end;
    end;

  FDetailObatBatch.ShowModal;
end;

procedure konek;
begin
  with dm.qryLabaPenjualan do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT a.obat_id, b.kode, b.nama_obat, ' +
        'ROUND(SUM(pb.jumlah * CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) / NULLIF(SUM(pb.jumlah), 0)) AS harga_beli_terakhir, ' +
        'a.harga_jual, ' +
        'COALESCE(SUM(pb.jumlah), SUM(a.jumlah_jual)) AS jmlItemJual, ' +
        'COALESCE(SUM(pb.jumlah * a.harga_jual), SUM(a.jumlah_jual * a.harga_jual)) AS total_jual, ' +
        'SUM((a.harga_jual - CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) * COALESCE(pb.jumlah, a.jumlah_jual)) AS laba, ' +
        'a.jenis_harga ' +
        'FROM tbl_penjualan z ' +
        'LEFT JOIN tbl_detail_penjualan a ON z.id = a.penjualan_id ' +
        'LEFT JOIN tbl_obat b ON a.obat_id = b.id ' +
        'LEFT JOIN tbl_harga_jual c ON c.obat_id = b.id ' +
        'LEFT JOIN tbl_penjualan_batch pb ON pb.penjualan_id = z.id ' +
        '  AND pb.detail_penjualan_id = a.id ' +
        'WHERE 1=0 ' +
        'AND a.jenis_harga = ''eceran'' ' +
        'AND COALESCE(a.status, '''') <> ''retur'' ' +
        'GROUP BY a.obat_id, a.jenis_harga, b.kode, b.nama_obat, a.harga_jual';
      Open;
    end;
end;

procedure konekGrosir;
begin
  with dm.qryLabaPenjualanGrosir do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT a.obat_id, b.kode, b.nama_obat, ' +
        'ROUND(SUM(pb.jumlah * CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) / NULLIF(SUM(pb.jumlah), 0)) AS harga_beli_terakhir, ' +
        'a.harga_jual, ' +
        'COALESCE(SUM(pb.jumlah), SUM(a.jumlah_jual)) AS jmlItemJual, ' +
        'COALESCE(SUM(pb.jumlah * a.harga_jual), SUM(a.jumlah_jual * a.harga_jual)) AS total_jual, ' +
        'SUM((a.harga_jual - CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) * COALESCE(pb.jumlah, a.jumlah_jual)) AS laba, ' +
        'a.jenis_harga ' +
        'FROM tbl_penjualan z ' +
        'LEFT JOIN tbl_detail_penjualan a ON z.id = a.penjualan_id ' +
        'LEFT JOIN tbl_obat b ON a.obat_id = b.id ' +
        'LEFT JOIN tbl_harga_jual c ON c.obat_id = b.id ' +
        'LEFT JOIN tbl_penjualan_batch pb ON pb.penjualan_id = z.id ' +
        '  AND pb.detail_penjualan_id = a.id ' +
        'WHERE 1=0 ' +
        'AND a.jenis_harga = ''grosir'' ' +
        'AND COALESCE(a.status, '''') <> ''retur'' ' +
        'GROUP BY a.obat_id, a.jenis_harga, b.kode, b.nama_obat, a.harga_jual';
      Open;
    end;
end;


procedure TfLabaPenjualan.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfLabaPenjualan.btnLapClick(Sender: TObject);
var labaEceran, labaGrosir, totalLaba : Real;
    totalPendapatanEceran     : Real;
    totalHPPEceran            : Real;
    totalPendapatanGrosir     : Real;
    totalHPPGrosir            : Real;
begin
  if (rbTanggal.Checked = false) and (rbBulan.Checked = False) then
    begin
      MessageDlg('Jenis Laporan Belum Dipilih',mtInformation, [mbOK], 0);
      Exit;
    end;

  if rbTanggal.Checked = True then
    begin
      query :=
        'SELECT a.obat_id, b.kode, b.nama_obat, ' +
        'COALESCE(ROUND(SUM(pb.jumlah * CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) / NULLIF(SUM(pb.jumlah), 0)), MAX(c.harga_beli_terakhir)) AS harga_beli_terakhir, ' +
        'a.harga_jual, ' +
        'COALESCE(SUM(pb.jumlah), SUM(a.jumlah_jual)) AS jmlItemJual, ' +
        'COALESCE(SUM(pb.jumlah * a.harga_jual), SUM(a.jumlah_jual * a.harga_jual)) AS total_jual, ' +
        'SUM((a.harga_jual - CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) * COALESCE(pb.jumlah, a.jumlah_jual)) AS laba, ' +
        'a.jenis_harga ' +
        'FROM tbl_penjualan z ' +
        'LEFT JOIN tbl_detail_penjualan a ON z.id = a.penjualan_id ' +
        'LEFT JOIN tbl_obat b ON a.obat_id = b.id ' +
        'LEFT JOIN tbl_harga_jual c ON c.obat_id = b.id ' +
        'LEFT JOIN tbl_penjualan_batch pb ON pb.penjualan_id = z.id ' +
        '  AND pb.batch_id IN (SELECT id FROM tbl_batch WHERE obat_id = a.obat_id) ' +
        'WHERE DATE(z.tgl_penjualan) = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtp1.Date)) +
        '  AND a.jenis_harga = ' + QuotedStr('eceran') +
        '  AND a.status IS NULL ' +
        'GROUP BY a.obat_id, a.jenis_harga, b.kode, b.nama_obat, a.harga_jual';

      queryGrosir :=
        'SELECT a.obat_id, b.kode, b.nama_obat, ' +
        'COALESCE(ROUND(SUM(pb.jumlah * CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) / NULLIF(SUM(pb.jumlah), 0)), MAX(c.harga_beli_terakhir)) AS harga_beli_terakhir, ' +
        'a.harga_jual, ' +
        'COALESCE(SUM(pb.jumlah), SUM(a.jumlah_jual)) AS jmlItemJual, ' +
        'COALESCE(SUM(pb.jumlah * a.harga_jual), SUM(a.jumlah_jual * a.harga_jual)) AS total_jual, ' +
        'SUM((a.harga_jual - CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) * COALESCE(pb.jumlah, a.jumlah_jual)) AS laba, ' +
        'a.jenis_harga ' +
        'FROM tbl_penjualan z ' +
        'LEFT JOIN tbl_detail_penjualan a ON z.id = a.penjualan_id ' +
        'LEFT JOIN tbl_obat b ON a.obat_id = b.id ' +
        'LEFT JOIN tbl_harga_jual c ON c.obat_id = b.id ' +
        'LEFT JOIN tbl_penjualan_batch pb ON pb.penjualan_id = z.id ' +
        '  AND pb.batch_id IN (SELECT id FROM tbl_batch WHERE obat_id = a.obat_id) ' +
        'WHERE DATE(z.tgl_penjualan) = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtp1.Date)) +
        '  AND a.jenis_harga = ' + QuotedStr('grosir') +
        '  AND a.status IS NULL ' +
        'GROUP BY a.obat_id, a.jenis_harga, b.kode, b.nama_obat, a.harga_jual';
    end
    else if rbBulan.Checked = True then
    begin
      if cbbTahun.Text = '' then
        begin
          MessageDlg('Tahun Wajib Diisi', mtInformation, [mbOK], 0);
          Exit;
        end;

      if cbbBulan.Text <> '-' then
        begin
          query :=
            'SELECT a.obat_id, b.kode, b.nama_obat, ' +
            'COALESCE(ROUND(SUM(pb.jumlah * CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) / NULLIF(SUM(pb.jumlah), 0)), MAX(c.harga_beli_terakhir)) AS harga_beli_terakhir, ' +
            'a.harga_jual, ' +
            'COALESCE(SUM(pb.jumlah), SUM(a.jumlah_jual)) AS jmlItemJual, ' +
            'COALESCE(SUM(pb.jumlah * a.harga_jual), SUM(a.jumlah_jual * a.harga_jual)) AS total_jual, ' +
            'SUM((a.harga_jual - CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) * COALESCE(pb.jumlah, a.jumlah_jual)) AS laba, ' +
            'a.jenis_harga ' +
            'FROM tbl_penjualan z ' +
            'LEFT JOIN tbl_detail_penjualan a ON z.id = a.penjualan_id ' +
            'LEFT JOIN tbl_obat b ON a.obat_id = b.id ' +
            'LEFT JOIN tbl_harga_jual c ON c.obat_id = b.id ' +
            'LEFT JOIN tbl_penjualan_batch pb ON pb.penjualan_id = z.id ' +
            '  AND pb.batch_id IN (SELECT id FROM tbl_batch WHERE obat_id = a.obat_id) ' +
            'WHERE MONTH(z.tgl_penjualan) = ' + IntToStr(cbbBulan.ItemIndex) +
            '  AND YEAR(z.tgl_penjualan) = ' + cbbTahun.Text +
            '  AND a.jenis_harga = ' + QuotedStr('eceran') +
            '  AND a.status IS NULL ' +
            'GROUP BY a.obat_id, a.jenis_harga, b.kode, b.nama_obat, a.harga_jual';

          queryGrosir :=
            'SELECT a.obat_id, b.kode, b.nama_obat, ' +
            'COALESCE(ROUND(SUM(pb.jumlah * CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) / NULLIF(SUM(pb.jumlah), 0)), MAX(c.harga_beli_terakhir)) AS harga_beli_terakhir, ' +
            'a.harga_jual, ' +
            'COALESCE(SUM(pb.jumlah), SUM(a.jumlah_jual)) AS jmlItemJual, ' +
            'COALESCE(SUM(pb.jumlah * a.harga_jual), SUM(a.jumlah_jual * a.harga_jual)) AS total_jual, ' +
            'SUM((a.harga_jual - CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) * COALESCE(pb.jumlah, a.jumlah_jual)) AS laba, ' +
            'a.jenis_harga ' +
            'FROM tbl_penjualan z ' +
            'LEFT JOIN tbl_detail_penjualan a ON z.id = a.penjualan_id ' +
            'LEFT JOIN tbl_obat b ON a.obat_id = b.id ' +
            'LEFT JOIN tbl_harga_jual c ON c.obat_id = b.id ' +
            'LEFT JOIN tbl_penjualan_batch pb ON pb.penjualan_id = z.id ' +
            '  AND pb.batch_id IN (SELECT id FROM tbl_batch WHERE obat_id = a.obat_id) ' +
            'WHERE MONTH(z.tgl_penjualan) = ' + IntToStr(cbbBulan.ItemIndex) +
            '  AND YEAR(z.tgl_penjualan) = ' + cbbTahun.Text +
            '  AND a.jenis_harga = ' + QuotedStr('grosir') +
            '  AND a.status IS NULL ' +
            'GROUP BY a.obat_id, a.jenis_harga, b.kode, b.nama_obat, a.harga_jual';
        end
      else
        begin
          query :=
            'SELECT a.obat_id, b.kode, b.nama_obat, ' +
            'COALESCE(ROUND(SUM(pb.jumlah * CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) / NULLIF(SUM(pb.jumlah), 0)), MAX(c.harga_beli_terakhir)) AS harga_beli_terakhir, ' +
            'a.harga_jual, ' +
            'COALESCE(SUM(pb.jumlah), SUM(a.jumlah_jual)) AS jmlItemJual, ' +
            'COALESCE(SUM(pb.jumlah * a.harga_jual), SUM(a.jumlah_jual * a.harga_jual)) AS total_jual, ' +
            'SUM((a.harga_jual - CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) * COALESCE(pb.jumlah, a.jumlah_jual)) AS laba, ' +
            'a.jenis_harga ' +
            'FROM tbl_penjualan z ' +
            'LEFT JOIN tbl_detail_penjualan a ON z.id = a.penjualan_id ' +
            'LEFT JOIN tbl_obat b ON a.obat_id = b.id ' +
            'LEFT JOIN tbl_harga_jual c ON c.obat_id = b.id ' +
            'LEFT JOIN tbl_penjualan_batch pb ON pb.penjualan_id = z.id ' +
            '  AND pb.batch_id IN (SELECT id FROM tbl_batch WHERE obat_id = a.obat_id) ' +
            'WHERE YEAR(z.tgl_penjualan) = ' + QuotedStr(cbbTahun.Text) +
            '  AND a.jenis_harga = ' + QuotedStr('eceran') +
            '  AND a.status IS NULL ' +
            'GROUP BY a.obat_id, a.jenis_harga, b.kode, b.nama_obat, a.harga_jual';

          queryGrosir :=
            'SELECT a.obat_id, b.kode, b.nama_obat, ' +
            'COALESCE(ROUND(SUM(pb.jumlah * CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) / NULLIF(SUM(pb.jumlah), 0)), MAX(c.harga_beli_terakhir)) AS harga_beli_terakhir, ' +
            'a.harga_jual, ' +
            'COALESCE(SUM(pb.jumlah), SUM(a.jumlah_jual)) AS jmlItemJual, ' +
            'COALESCE(SUM(pb.jumlah * a.harga_jual), SUM(a.jumlah_jual * a.harga_jual)) AS total_jual, ' +
            'SUM((a.harga_jual - CASE WHEN pb.harga_beli > 0 THEN pb.harga_beli ELSE c.harga_beli_terakhir END) * COALESCE(pb.jumlah, a.jumlah_jual)) AS laba, ' +
            'a.jenis_harga ' +
            'FROM tbl_penjualan z ' +
            'LEFT JOIN tbl_detail_penjualan a ON z.id = a.penjualan_id ' +
            'LEFT JOIN tbl_obat b ON a.obat_id = b.id ' +
            'LEFT JOIN tbl_harga_jual c ON c.obat_id = b.id ' +
            'LEFT JOIN tbl_penjualan_batch pb ON pb.penjualan_id = z.id ' +
            '  AND pb.batch_id IN (SELECT id FROM tbl_batch WHERE obat_id = a.obat_id) ' +
            'WHERE YEAR(z.tgl_penjualan) = ' + QuotedStr(cbbTahun.Text) +
            '  AND a.jenis_harga = ' + QuotedStr('grosir') +
            '  AND a.status IS NULL ' +
            'GROUP BY a.obat_id, a.jenis_harga, b.kode, b.nama_obat, a.harga_jual';
        end;
    end;

  with dm.qryLabaPenjualan do
    begin
      close;
      SQL.Clear;
      sql.Text := query;
      Open;

      labaEceran            := 0;
      totalPendapatanEceran := 0;
      totalHPPEceran        := 0;

      if not IsEmpty then
        begin
          First;
          while not Eof do
            begin
              labaEceran            := labaEceran + FieldByName('laba').AsFloat;
              totalPendapatanEceran := totalPendapatanEceran + FieldByName('total_jual').AsFloat;
              totalHPPEceran        := totalHPPEceran + (FieldByName('total_jual').AsFloat - FieldByName('laba').AsFloat);
              Next;
            end;
        end;
    end;

  with dm.qryLabaPenjualanGrosir do
    begin
      close;
      SQL.Clear;
      sql.Text := queryGrosir;
      Open;

      labaGrosir            := 0;
      totalPendapatanGrosir := 0;
      totalHPPGrosir        := 0;

      if not IsEmpty then
        begin
          First;
          while not Eof do
            begin
              labaGrosir            := labaGrosir + FieldByName('laba').AsFloat;
              totalPendapatanGrosir := totalPendapatanGrosir + FieldByName('total_jual').AsFloat;
              totalHPPGrosir        := totalHPPGrosir + (FieldByName('total_jual').AsFloat - FieldByName('laba').AsFloat);
              Next;
            end;
        end;
    end;

  totalLaba := labaEceran + labaGrosir;

  if (totalPendapatanEceran <= 0) and (totalPendapatanGrosir <= 0) then
    begin
      MessageDlg('Data Tidak Ditemukan', mtInformation, [mbOK], 0);
      lblPendapatanEceran.Caption := '-';
      lblHPPEceran.Caption        := '-';
      lblLabaEceran.Caption       := '-';
      lblPendapatanGrosir.Caption := '-';
      lblHPPGrosir.Caption        := '-';
      lblLabaGrosir.Caption       := '-';
      lblJumlah.Caption           := '-';
      Exit;
    end;

  // update label eceran
  lblPendapatanEceran.Caption := FormatFloat('Rp. ###,###,###', totalPendapatanEceran);
  lblHPPEceran.Caption        := FormatFloat('Rp. ###,###,###', totalHPPEceran);
  lblLabaEceran.Caption       := FormatFloat('Rp. ###,###,###', labaEceran);

  // update label grosir
  lblPendapatanGrosir.Caption := FormatFloat('Rp. ###,###,###', totalPendapatanGrosir);
  lblHPPGrosir.Caption        := FormatFloat('Rp. ###,###,###', totalHPPGrosir);
  lblLabaGrosir.Caption       := FormatFloat('Rp. ###,###,###', labaGrosir);

  // total keseluruhan
  lblTitleTotalLaba.Caption := 'Total Laba Keseluruhan (Eceran + Grosir)';
  lblJumlah.Caption := 'Total Laba : ' + FormatFloat('Rp. ###,###,###', totalLaba);
end;

procedure TfLabaPenjualan.cbbBulanKeyPress(Sender: TObject; var Key: Char);
begin
 Key:=#0;
end;

procedure TfLabaPenjualan.rbBulanClick(Sender: TObject);
begin
  dtp1.Enabled := false;

  cbbTahun.Text := ''; cbbTahun.Enabled := True;
  cbbBulan.Text := ''; cbbBulan.Enabled := True;
end;

procedure TfLabaPenjualan.rbTanggalClick(Sender: TObject);
begin
  dtp1.Enabled := True;

  cbbTahun.Text := ''; cbbTahun.Enabled := false;
  cbbBulan.Text := ''; cbbBulan.Enabled := false;
end;

procedure TfLabaPenjualan.FormShow(Sender: TObject);
var thnSekarang, i : Integer;
begin
  rbTanggal.Checked := false;
  rbBulan.Checked := false;

  dtp1.Date := Now;
  cbbBulan.Text := '';

  cbbTahun.Clear;
  thnSekarang := StrToInt(FormatDateTime('yyyy', now));
  for i := 0 to 9 do
    begin
       cbbTahun.Items.Add(IntToStr(thnSekarang - i));
    end;
  cbbTahun.Text := '';

  dtp1.Enabled := false;
  cbbTahun.Enabled := False;
  cbbBulan.Enabled := False;
  
  konek;
  konekGrosir;

  lblJumlah.Caption := '-';

  lblPendapatanEceran.Caption := '-';
  lblHPPEceran.Caption        := '-';
  lblLabaEceran.Caption       := '-';
  lblPendapatanGrosir.Caption := '-';
  lblHPPGrosir.Caption        := '-';
  lblLabaGrosir.Caption       := '-';
  lblJumlah.Caption           := '-';

  lblTitleTotalLaba.Caption := '-';
end;

procedure TfLabaPenjualan.dbgrd1DblClick(Sender: TObject);
begin
  if dm.qryLabaPenjualan.IsEmpty then Exit;
  BukaDetail('eceran');
end;

procedure TfLabaPenjualan.BukaDetail(jenisHarga: string);
var
  obatId   : string;
  namaObat : string;
begin
  if jenisHarga = 'eceran' then
    begin
      if dm.qryLabaPenjualan.IsEmpty then Exit;
      obatId   := dm.qryLabaPenjualan.FieldByName('obat_id').AsString;
      namaObat := dm.qryLabaPenjualan.FieldByName('nama_obat').AsString;
    end
  else
    begin
      if dm.qryLabaPenjualanGrosir.IsEmpty then Exit;
      obatId   := dm.qryLabaPenjualanGrosir.FieldByName('obat_id').AsString;
      namaObat := dm.qryLabaPenjualanGrosir.FieldByName('nama_obat').AsString;
    end;

   konekBatchDetail(
      obatId,
      namaObat,
      jenisHarga,
      rbTanggal.Checked,
      rbBulan.Checked,
      FormatDateTime('yyyy-mm-dd', dtp1.Date),  // tgl pertanggal
      cbbBulan.ItemIndex,                        // bulan
      cbbTahun.Text                              // tahun
    );
end;

procedure TfLabaPenjualan.dbgrd2DblClick(Sender: TObject);
begin
  if dm.qryLabaPenjualanGrosir.IsEmpty then Exit;
  BukaDetail('grosir');
end;

end.
