unit uPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, Grids, DBGrids, ExtCtrls, DBCtrls;

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
    procedure btnKeluarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
    procedure btnBantuObatClick(Sender: TObject);
    procedure konek(status : string = 'kosong');
    procedure btnSimpanClick(Sender: TObject);
    procedure edtKodeKeyPress(Sender: TObject; var Key: Char);
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
  dataModule, StrUtils, uBantuObatPenjualan;

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

  btnBantuObat.Enabled := false;
  konek;
end;

procedure TFpenjualan.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption = 'Tambah[F1]' then
    begin
      dtpTanggalBeli.Enabled := True;
      dblkcbbPelanggan.Enabled := True;

      btnBantuObat.Enabled := True;

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
        btnTambah.Caption := 'Batal[F1]';
        btnKeluar.Enabled := false;
   
        status := 'tambah';
    end
  else
    begin
      FormShow(Sender);
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
                  'c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, e.satuan from tbl_penjualan a left join '+
                  'tbl_detail_penjualan b on b.penjualan_id = a.id left join tbl_obat c on c.id = b.obat_id left join tbl_jenis d '+
                  'on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan where a.no_faktur='+QuotedStr(status)+'';
      open
    end;
end;

procedure TFpenjualan.btnSimpanClick(Sender: TObject);
begin
  if btnSimpan.Caption = 'Simpan' then
    begin
      if status = 'tambah' then
        begin
          // simpan ke table pembelian
          with dm.qryPenjualan do
            begin
              Append;
              FieldByName('no_faktur').AsString := edtFaktur.Text;
              FieldByName('tgl_penjualan').AsDateTime := dtpTanggalBeli.Date;
              FieldByName('id_pelanggan').AsString := dblkcbbPelanggan.KeyValue;
              FieldByName('jumlah_item').AsString := '0';
              FieldByName('total').AsString := '0';
              FieldByName('user_id').AsString := '1';
              FieldByName('status').AsString := 'pending';
              Post;
            end;

            status := 'tambahLagi';
        end;

      if dm.qryPenjualan.Locate('no_faktur',edtFaktur.Text,[]) then id_penjualan := dm.qryPenjualan.fieldbyname('id').AsString;

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
              Edit;
              FieldByName('harga_jual').AsString := edtHarga.Text;

              if status = 'tambahLagi' then
                FieldByName('jumlah_jual').AsString := IntToStr(1 + fieldbyname('jumlah_beli').AsInteger)
              else
                FieldByName('jumlah_jual').AsString := '1';
              Post;

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
            end
          else
            begin
              Edit;
            end;

          FieldByName('no_faktur').AsString := edtFaktur.Text;
          FieldByName('obat_id').AsString   := edtIdObat.Text;
          FieldByName('jumlah').AsString    := '1';
          FieldByName('harga').AsString     := edtHarga.Text;
          FieldByName('keterangan').AsString:= 'penjualan';
          Post;
        end;

      konek(edtFaktur.Text);
      lblItem.Caption := IntToStr(hitungItem(id_penjualan));
      lblTotalHarga.Caption := FormatFloat('Rp. ###,###,###', hitungTotal(id_penjualan));

      btnSelesai.Enabled := True;
      btnTambah.Caption := 'Batal';
      btnHapus.enabled := false;
    end
  else
    begin
      edtHarga.Enabled := True;

      btnSimpan.Caption := 'Simpan';
      btnHapus.Caption := 'Batal';
      status := 'edit';
    end;  
end;

procedure TFpenjualan.edtKodeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    begin
      //cari item
      //simpan clik
    end;
end;

end.
