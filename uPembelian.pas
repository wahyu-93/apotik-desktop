unit uPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DBCtrls, ComCtrls, Grids, DBGrids, ExtCtrls;

type
  TfPembelian = class(TForm)
    grp1: TGroupBox;
    lbl6: TLabel;
    lbl1: TLabel;
    dtpTanggalBeli: TDateTimePicker;
    edtFaktur: TEdit;
    lbl2: TLabel;
    dblkcbbSupplier: TDBLookupComboBox;
    lbl3: TLabel;
    edtKode: TEdit;
    lbl4: TLabel;
    btnBantuObat: TBitBtn;
    edtNama: TEdit;
    lbl5: TLabel;
    lbl7: TLabel;
    edtSatuan: TEdit;
    edtJenis: TEdit;
    lbl8: TLabel;
    dtpTanggalKadaluarsa: TDateTimePicker;
    lbl9: TLabel;
    edtHarga: TEdit;
    lbl10: TLabel;
    edtJumlahBeli: TEdit;
    grp2: TGroupBox;
    dbgrd1: TDBGrid;
    btnSimpan: TBitBtn;
    btnHapus: TBitBtn;
    btnTambah: TBitBtn;
    btnSelesai: TBitBtn;
    btnKeluar: TBitBtn;
    bvl1: TBevel;
    grp3: TGroupBox;
    grp4: TGroupBox;
    lblItem: TLabel;
    lblTotalHarga: TLabel;
    edtIdObat: TEdit;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
    procedure btnBantuObatClick(Sender: TObject);
    procedure edtHargaKeyPress(Sender: TObject; var Key: Char);
    procedure edtJumlahBeliKeyPress(Sender: TObject; var Key: Char);
    procedure btnSimpanClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPembelian: TfPembelian;
  kode, status, id_pembelian : string;

implementation

uses
  dataModule, StrUtils, uBantuObat, DB, ADODB;

{$R *.dfm}

function hitungItem(id_pembelian : string) : Integer;
begin
  with dm.qryDetailPembelian do
    begin
      close;
      SQL.Clear;
      SQL.Text := 'select * from tbL_detail_pembelian where pembelian_id = '+QuotedStr(id_pembelian)+'';
      Open;

      Result := RecordCount;
    end;
end;

function hitungTotal(id_pembelian : string) : Real;
var
  i : Integer;
  total : Real;
begin
  with dm.qryDetailPembelian do
    begin
      close;
      SQL.Clear;
      SQL.Text := 'select * from tbL_detail_pembelian where pembelian_id = '+QuotedStr(id_pembelian)+'';
      Open;

      total := 0;
      for i:=1 to RecordCount do
        begin
          RecNo := i;
          total := total + (fieldbyname('jumlah_beli').AsInteger * fieldbyname('harga_beli').AsInteger);

          Next;
        end;

      Result := total;
    end;

end;

procedure konek(id_pembelian : string = 'kosong');
begin
  with dm.qryRelasiPembelian do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select a.id, a.no_faktur, a.tgl_pembelian, a.jumlah_item, a.total, b.obat_id, b.jumlah_beli, b.harga_beli, '+
                  'c.kode, c.barcode, c.nama_obat, d.jenis, e.satuan from tbl_pembelian a left join ' +
                  'tbl_detail_pembelian b on b.pembelian_id = a.id left join tbl_obat c on c.id = b.obat_id left join tbl_jenis d on d.id=c.kode_jenis '+
                  'left join tbl_satuan e on e.id = c.kode_satuan where a.no_faktur='+QuotedStr(id_pembelian)+'';
      Open;
    end;
end;

procedure TfPembelian.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfPembelian.FormCreate(Sender: TObject);
begin
  edtFaktur.Clear;
  dtpTanggalBeli.Enabled := false; dtpTanggalBeli.DateTime := Now;
  dblkcbbSupplier.KeyValue := Null; dblkcbbSupplier.Enabled := false;

  btnBantuObat.Enabled := False;
  edtKode.Clear;
  edtNama.Clear;
  edtSatuan.Clear;
  edtJenis.Clear;

  dtpTanggalKadaluarsa.DateTime := Now; dtpTanggalKadaluarsa.Enabled := false;
  edtHarga.Enabled := false; edtHarga.Clear;
  edtJumlahBeli.Enabled := false; edtJumlahBeli.Clear;

  btnSimpan.Enabled := False;
  btnHapus.Enabled := False;
  btnSelesai.Enabled := False;

  lblItem.Caption := '0'; lblTotalHarga.Caption := '0';
  btnTambah.Enabled := True; btnTambah.Caption := 'Tambah';
  btnKeluar.Enabled := True;

  konek;
end;

procedure TfPembelian.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption='Tambah' then
    begin
      dtpTanggalBeli.Enabled := True;
      dblkcbbSupplier.Enabled := True;
      btnBantuObat.Enabled := True;

      dtpTanggalKadaluarsa.Enabled := True;
      edtHarga.Enabled := True;
      edtJumlahBeli.Enabled := True;

      btnSimpan.Enabled := True;

      with dm.qryPembelian do
        begin
          close;
          SQL.Clear;
          SQL.Text := 'select * from tbl_pembelian where no_faktur like ''%'+FormatDateTime('yyyy',Now)+'%''';
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

        edtFaktur.Text := FormatDateTime('ddmmyyyy',Now) + FormatFloat('00000',StrToInt(kode));
        btnSimpan.Caption := 'Simpan';
        status:='tambah';
    end
  else
    begin
      if MessageDlg('Apakah Transaksi Akan Dibatalkan ?',mtConfirmation,[mbyes,mbno],0)=mryes then
        begin
          // hapus detail transaksi
          with dm.qryDetailPembelian do
            begin
              Close;
              SQL.Clear;
              SQL.Text := 'delete from tbl_detail_pembelian where pembelian_id = '+QuotedStr(id_pembelian)+'';
              ExecSQL;
            end;

          // hapus pembelian
          with dm.qryPembelian do
            begin
              close;
              SQL.Clear;
              SQL.Text := 'delete from tbl_pembelian where id='+QuotedStr(id_pembelian)+'';
              ExecSQL;
            end;

          MessageDlg('Transaksi Dibatalkan',mtInformation,[mbOk],0);
          FormCreate(Sender);
        end;
    end;
end;

procedure TfPembelian.btnBantuObatClick(Sender: TObject);
begin
  fBantuObat.ShowModal;
end;

procedure TfPembelian.edtHargaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#8, #9]) then Key:=#0;
end;

procedure TfPembelian.edtJumlahBeliKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8, #9]) then Key:=#0;
end;

procedure TfPembelian.btnSimpanClick(Sender: TObject);
begin
  if dblkcbbSupplier.KeyValue = null then
    begin
      MessageDlg('Supplier Belum Dipilih',mtInformation,[mbok],0);
      dblkcbbSupplier.SetFocus;
      Exit;
    end;

  if edtKode.Text = '' then
    begin
      MessageDlg('Obat Belum Dipilih',mtInformation,[mbok],0);
      Exit;
    end;

  if edtHarga.Text = '' then
    begin
      MessageDlg('Harga Pembelian Tidak Boleh Kosong',mtInformation,[mbok],0);
      edtHarga.SetFocus;
      exit;
    end;

  if edtJumlahBeli.Text = '' then
    begin
      MessageDlg('Jumlah Pembelian Tidak Boleh Kosong',mtInformation,[mbok],0);
      edtJumlahBeli.SetFocus;
      exit;
    end;

  if btnSimpan.Caption = 'Simpan' then
    begin
      if status = 'tambah' then
        begin
          // simpan ke table pembelian
          with dm.qryPembelian do
            begin
              Append;
              FieldByName('no_faktur').AsString := edtFaktur.Text;
              FieldByName('tgl_pembelian').AsDateTime := dtpTanggalBeli.Date;
              FieldByName('supplier_id').AsString := dblkcbbSupplier.KeyValue;
              FieldByName('jumlah_item').AsString := '0';
              FieldByName('total').AsString := '0';
              FieldByName('user_id').AsString := '1';
              FieldByName('status').AsString := 'pending';
              Post;
            end;

            status := 'tambahLagi';
        end;

      if dm.qryPembelian.Locate('no_faktur',edtFaktur.Text,[]) then id_pembelian := dm.qryPembelian.fieldbyname('id').AsString;

      //simpan ke tabel detail pembelian
      with dm.qryDetailPembelian do
        begin
          Append;
          FieldByName('pembelian_id').AsString := id_pembelian;
          FieldByName('obat_id').AsString := edtIdObat.Text;
          FieldByName('jumlah_beli').AsString := edtJumlahBeli.Text;
          FieldByName('harga_beli').AsString := edtHarga.Text;
          Post;
        end;

      // clear entitas barang
      edtKode.Clear;
      edtNama.Clear;
      edtJenis.Clear;
      edtSatuan.Clear;
      dtpTanggalKadaluarsa.Date := Now;
      edtHarga.Clear;
      edtJumlahBeli.Clear;

      konek(edtFaktur.Text);
      lblItem.Caption := IntToStr(hitungItem(id_pembelian));
      lblTotalHarga.Caption := FormatFloat('Rp. ###,###,###', hitungTotal(id_pembelian));

      lblItem.Alignment := taCenter;
      lblTotalHarga.Alignment := taCenter;

      btnSelesai.Enabled := True;
      btnTambah.Caption := 'Batal';
    end;
end;

procedure TfPembelian.dbgrd1DblClick(Sender: TObject);
begin
  edtKode.Text := dbgrd1.Fields[6].AsString + ' - ' + dbgrd1.Fields[7].AsString;
  edtNama.Text := dbgrd1.Fields[8].AsString;
  edtSatuan.Text := dbgrd1.Fields[10].AsString;
  edtJenis.Text := dbgrd1.Fields[9].AsString;
  edtHarga.Text := dbgrd1.Fields[12].AsString;
  edtJenis.Text := dbgrd1.Fields[11].AsString;
  edtIdObat.Text := dbgrd1.Fields[5].AsString;

  btnSimpan.Caption := 'Edit';
  btnHapus.Enabled := True;
  btnSelesai.Enabled := false;
end;

procedure TfPembelian.btnHapusClick(Sender: TObject);
begin
  if MessageDlg('Yakin Item Akan Dihapus ?', mtConfirmation,[mbyes,mbNo],0)=mryes then
    begin
    
    end;
end;

procedure TfPembelian.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F2: fBantuObat.ShowModal;
  end;
end;

end.