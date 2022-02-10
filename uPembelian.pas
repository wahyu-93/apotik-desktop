unit uPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DBCtrls, ComCtrls, Grids, DBGrids, ExtCtrls,
  jpeg;

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
    edtIdPembelian: TEdit;
    img1: TImage;
    lbl11: TLabel;
    edtFakturSales: TEdit;
    lbl12: TLabel;
    dtpTglJatuhTempo: TDateTimePicker;
    procedure clearEntitasBarang;
    procedure fokusDbgrid;
    procedure btnKeluarClick(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
    procedure btnBantuObatClick(Sender: TObject);
    procedure edtHargaKeyPress(Sender: TObject; var Key: Char);
    procedure edtJumlahBeliKeyPress(Sender: TObject; var Key: Char);
    procedure btnSimpanClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSelesaiClick(Sender: TObject);
    procedure dbgrd1KeyPress(Sender: TObject; var Key: Char);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure FormShow(Sender: TObject);

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
      sql.Text := 'select a.id as id_pembelian, a.no_faktur, a.no_faktur_supplier, a.tgl_pembelian, a.jumlah_item, a.total, b.id as id_detail_pembelian, '+
                  'b.obat_id, b.jumlah_beli, b.harga_beli, c.kode, c.barcode, c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, e.satuan '+
                  'from tbl_pembelian a left join tbl_detail_pembelian b on b.pembelian_id = a.id left join tbl_obat c on c.id = b.obat_id left join '+
                  'tbl_jenis d on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan where a.no_faktur='+QuotedStr(id_pembelian)+'';
      Open;
    end;
end;

procedure TfPembelian.clearEntitasBarang;
begin
  edtKode.Clear;
  edtNama.Clear;
  edtJenis.Clear;
  edtSatuan.Clear;
  dtpTanggalKadaluarsa.Date := Now;
  edtHarga.Clear;
  edtJumlahBeli.Clear;
end;

procedure TfPembelian.fokusDbgrid;
begin
  edtKode.Text := dbgrd1.Fields[9].AsString + ' - ' + dbgrd1.Fields[10].AsString;
  edtNama.Text := dbgrd1.Fields[11].AsString;
  edtSatuan.Text := dbgrd1.Fields[13].AsString;
  edtJenis.Text := dbgrd1.Fields[12].AsString;
  edtHarga.Text := dbgrd1.Fields[15].AsString;
  edtJumlahBeli.Text := dbgrd1.Fields[14].AsString;
  edtIdObat.Text := dbgrd1.Fields[6].AsString;
  dtpTanggalKadaluarsa.Date := dbgrd1.Fields[10].AsDateTime;
  edtIdPembelian.Text := dbgrd1.Fields[5].AsString;

  btnSimpan.Caption := 'Edit';
  btnHapus.Enabled := True;
  btnSelesai.Enabled := false;

  edtHarga.Enabled := False;
  edtJumlahBeli.Enabled := false;
end;

procedure TfPembelian.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfPembelian.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption='Tambah[F1]' then
    begin
      dtpTanggalBeli.Enabled := True;
      dblkcbbSupplier.Enabled := True;
      btnBantuObat.Enabled := True;

      dtpTanggalKadaluarsa.Enabled := True;
      edtHarga.Enabled := True;
      edtJumlahBeli.Enabled := True;

      edtFakturSales.Enabled := True;
      btnSimpan.Enabled := True;

      edtFaktur.Text := 'PB-'+FormatDateTime('ddmmyyyy',Now);
      btnSimpan.Caption := 'Simpan';
      status:='tambah';
      btnTambah.Caption := 'Batal[F1]';

      btnKeluar.Enabled := false;
      dtpTglJatuhTempo.Enabled := True;
    end
  else
    begin
      if MessageDlg('Apakah Transaksi Akan Dibatalkan ?',mtConfirmation,[mbyes,mbno],0)=mryes then
        begin
          with dm.qryPembelian do
            begin
              close;
              sql.Clear;
              SQL.Text := 'select * from tbl_pembelian where id='+QuotedStr(id_pembelian)+'';
              Open;
            end;

          if dm.qryPembelian.RecordCount > 0 then
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

procedure TfPembelian.btnBantuObatClick(Sender: TObject);
begin
  fBantuObat.edt1.Text := 'pembelian';
  fBantuObat.ShowModal;
end;

procedure TfPembelian.edtHargaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#8, #9, #13]) then Key:=#0;
  if Key=#13 then edtJumlahBeli.SetFocus;
end;

procedure TfPembelian.edtJumlahBeliKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8, #9, #13]) then Key:=#0;
  if key=#13 then btnSimpan.Click;
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

  if edtFakturSales.Text = '' then
    begin
      MessageDlg('No Faktur dari Supplier Diisi', mtInformation,[mbOK],0);
      edtFakturSales.SetFocus;
      Exit;
    end;

  if btnSimpan.Caption = 'Simpan' then
    begin
      if status = 'tambah' then
        begin
           // simpan ke table pembelian
          with dm.qryPembelian do
          begin
            close;
            SQL.Clear;
            SQL.Text := 'select * from tbl_pembelian where no_faktur like ''%'+FormatDateTime('mmyyyy',Now)+'%''';
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

          edtFaktur.Text := 'PB-'+FormatDateTime('ddmmyyyy',Now) + FormatFloat('00000',StrToInt(kode));

          with dm.qryPembelian do
            begin
              Append;
              FieldByName('no_faktur').AsString := edtFaktur.Text;
              FieldByName('jumlah_item').AsString := '0';
              FieldByName('total').AsString := '0';
              FieldByName('user_id').AsString := dm.qryUser.fieldbyname('id').AsString;
              FieldByName('status').AsString := 'pending';
              FieldByName('tgl_pembelian').AsDateTime := dtpTanggalBeli.Date;
              FieldByName('supplier_id').AsString := dblkcbbSupplier.KeyValue;
              FieldByName('no_faktur_supplier').AsString := edtFakturSales.Text;
              FieldByName('tgl_jatuh_tempo').AsDateTime := dtpTglJatuhTempo.Date;
              Post;
            end;

            dblkcbbSupplier.Enabled := false;
            edtFakturSales.Enabled := False;
            status := 'tambahLagi';
        end;

      if dm.qryPembelian.Locate('no_faktur',edtFaktur.Text,[]) then id_pembelian := dm.qryPembelian.fieldbyname('id').AsString;

      //simpan ke tabel detail pembelian
      with dm.qryDetailPembelian do
        begin
          close;
          sql.Clear;
          SQL.Text := 'select * from tbl_detail_pembelian where obat_id = '+QuotedStr(edtIdObat.Text)+' and pembelian_id = '+QuotedStr(id_pembelian)+'';
          Open;

          if IsEmpty then
            begin
              Append;
              FieldByName('pembelian_id').AsString := id_pembelian;
              FieldByName('obat_id').AsString := edtIdObat.Text;
              FieldByName('jumlah_beli').AsString := edtJumlahBeli.Text;
              FieldByName('harga_beli').AsString := edtHarga.Text;
              Post;
            end
          else
            begin
              with dm.qryDetailPembelian do
                begin
                  close;
                  sql.Clear;
                  SQL.Text := 'update tbl_detail_pembelian set jumlah_beli = '+QuotedStr(edtJumlahBeli.Text)+', harga_beli = '+QuotedStr(edtHarga.Text)+
                              ' where obat_id = '+QuotedStr(edtIdObat.Text)+' and pembelian_id = '+QuotedStr(id_pembelian)+'';
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
              FieldByName('no_faktur').AsString := edtFaktur.Text;
              FieldByName('obat_id').AsString   := edtIdObat.Text;
              FieldByName('jumlah').AsString    := edtJumlahBeli.Text;
              FieldByName('harga').AsString     := edtHarga.Text;
              FieldByName('keterangan').AsString:= 'pembelian';
              Post;
            end
          else
            begin
              with dm.qryStok do
                begin
                  close;
                  sql.Clear;
                  sql.Text := 'update tbl_stok set jumlah = '+QuotedStr(edtJumlahBeli.Text)+', harga = '+QuotedStr(edtHarga.Text)+
                              ' where no_faktur = '+QuotedStr(edtFaktur.Text)+' and obat_id = '+QuotedStr(edtIdObat.Text)+'';
                  ExecSQL;
                end;

            end;
        end;

        // update tgl expired obat
        with dm.qryObat do
          begin
            close;
            sql.Clear;
            sql.Text := 'update tbl_obat set tgl_obat = '+QuotedStr(DateToStr(Now))+', tgl_exp = '+QuotedStr(FormatDateTime('yyyy-mm-dd',dtpTanggalKadaluarsa.DateTime))+
                        ' where id = '+QuotedStr(edtIdObat.Text)+'';
            ExecSQL;
          end;

      // clear entitas barang
      clearEntitasBarang;

      konek(edtFaktur.Text);
      lblItem.Caption := IntToStr(hitungItem(id_pembelian));
      lblTotalHarga.Caption := FormatFloat('Rp. ###,###,###', hitungTotal(id_pembelian));

      lblItem.Alignment := taCenter;
      lblTotalHarga.Alignment := taCenter;

      btnSelesai.Enabled := True;
      btnTambah.Caption := 'Batal';
      btnHapus.enabled := false;
    end
  else
    begin
      edtHarga.Enabled := True;
      edtJumlahBeli.Enabled := True;

      btnSimpan.Caption := 'Simpan';
      btnHapus.Caption := 'Batal';
      status := 'edit';
    end;
end;

procedure TfPembelian.btnHapusClick(Sender: TObject);
begin
  if btnHapus.Caption = 'Hapus[F6]' then
    begin
      if MessageDlg('Yakin Item Akan Dihapus ?', mtConfirmation,[mbyes,mbNo],0)=mryes then
        begin
          with dm.qryDetailPembelian do
            begin
              with dm.qryDetailPembelian do
                begin
                  Locate('id',edtIdPembelian.Text,[]);
                  Delete;
                end;
            end;

            konek(edtFaktur.Text);
            clearEntitasBarang;
            lblItem.Caption := IntToStr(hitungItem(id_pembelian));
            lblTotalHarga.Caption := FormatFloat('Rp. ###,###,###', hitungTotal(id_pembelian));
      
            btnSimpan.Caption := 'Simpan';
            btnHapus.Enabled := false;
            btnSelesai.Enabled := True;
            MessageDlg('item Berhasil dihapus',mtInformation,[mbOK],0);

          with dm.qryDetailPembelian do
            begin
              close;
              SQL.Clear;
              SQL.Text := 'select * from tbl_detail_pembelian where pembelian_id = '+QuotedStr(id_pembelian)+'';
              Open;

              if IsEmpty then btnSelesai.Enabled := False else btnSelesai.Enabled := True;
            end
        end;
    end
  else
    begin
      //batal
      clearEntitasBarang;
      btnSimpan.Caption := 'Simpan';
      btnHapus.Caption := 'Hapus[F6]'; btnHapus.Enabled := False;
      btnSelesai.Enabled := True;
    end;

end;

procedure TfPembelian.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F1: btnTambah.Click;
    VK_F2: btnBantuObat.Click;
    VK_F5: btnSelesai.Click;
    VK_F6: btnHapus.Click;
    VK_F10 : btnKeluar.Click;
  end;
end;

procedure TfPembelian.btnSelesaiClick(Sender: TObject);
var
  jumlahItem, total : string;
  a : integer;
begin
  if MessageDlg('Apakah Transaksi Akan Diselesaikan ?',mtConfirmation,[mbYes,mbno],0)=mryes then
    begin
      MessageDlg('Transaki Berhasil Disimpan', mtInformation, [mbok],0);

      jumlahItem := IntToStr(hitungItem(id_pembelian));
      total := FloatToStr(hitungTotal(id_pembelian));

      with dm.qryPembelian do
        begin
          close;
          sql.Clear;
          sql.Text := 'update tbl_pembelian set jumlah_item = '+QuotedStr(jumlahItem)+', total = '+QuotedStr(total)+' where no_faktur = '+QuotedStr(edtFaktur.Text)+'';
          ExecSQL;
        end;

      with dm.qryDetailPembelian do
        begin
          Close;
          SQL.Clear;
          SQL.Text := 'select * from tbl_detail_pembelian where pembelian_id = '+QuotedStr(id_pembelian)+'';
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
                  
                  if locate('id',dm.qryDetailPembelian.fieldbyname('obat_id').AsString,[]) then
                    begin
                      Edit;
                      FieldByName('stok').AsInteger := fieldbyname('stok').AsInteger + dm.qryDetailPembelian.fieldbyname('jumlah_beli').AsInteger;
                      Post;
                    end;
                end;

              Next;
            end;
        end;

      FormShow(Sender);
    end;
end;

procedure TfPembelian.dbgrd1KeyPress(Sender: TObject; var Key: Char);
var jumlahNew : Integer;
    totalNew : Real;
    id : string;
begin
  if key=#13 then
    begin
      //edit data lewat dbgrid
      jumlahNew := dbgrd1.Fields[14].AsInteger;
      id := dbgrd1.Fields[5].AsString;
      
      with dm.qryDetailPembelian do
        begin
          close;
          sql.Clear;
          SQL.Text := 'update tbl_detail_pembelian set jumlah_beli = '+QuotedStr(IntToStr(jumlahNew))+
                      ' where obat_id = '+QuotedStr(dbgrd1.Fields[6].AsString)+' and pembelian_id = '+QuotedStr(dbgrd1.Fields[0].AsString)+'';
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

      lblItem.Caption := IntToStr(hitungItem(id_pembelian));
      lblTotalHarga.Caption := FormatFloat('Rp. ###,###,###', hitungTotal(id_pembelian));

      btnSelesai.Enabled := True;
      btnTambah.Caption := 'Batal';
      btnHapus.enabled := false;

      dm.qryRelasiPembelian.Locate('id_detail_pembelian',id,[]);
    end;
end;

procedure TfPembelian.dbgrd1CellClick(Column: TColumn);
begin
  fokusDbgrid;
end;


procedure TfPembelian.FormShow(Sender: TObject);
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
  btnHapus.Enabled := False; btnHapus.Caption := 'Hapus[F6]';
  btnSelesai.Enabled := False;

  lblItem.Caption := '0'; lblTotalHarga.Caption := '0';
  btnTambah.Enabled := True; btnTambah.Caption := 'Tambah[F1]';
  btnKeluar.Enabled := True;
  
  edtFakturSales.Clear;
  dtpTglJatuhTempo.Enabled := false;
  dtpTglJatuhTempo.Date := Now;

  konek;

  id_pembelian := 'kosong';
end;

end.
