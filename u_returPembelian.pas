unit u_returPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, jpeg;

type
  TfReturPembelian = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    edtKode: TEdit;
    edtIdPembelian: TEdit;
    grp2: TGroupBox;
    lbl3: TLabel;
    lbl2: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    bvl1: TBevel;
    edtFaktur: TEdit;
    btnCari: TBitBtn;
    dbgrd1: TDBGrid;
    edtTanggalJual: TEdit;
    btnRetualAll: TBitBtn;
    btnRetur: TBitBtn;
    btnKeluar: TBitBtn;
    dtpTanggalRetur: TDateTimePicker;
    btnTambah: TBitBtn;
    dbgrd2: TDBGrid;
    btnSelesai: TBitBtn;
    edtSupplier: TEdit;
    lbl7: TLabel;
    mmo1: TMemo;
    procedure btnKeluarClick(Sender: TObject);
    procedure edtFakturKeyPress(Sender: TObject; var Key: Char);
    procedure btnCariClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnTambahClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure btnSelesaiClick(Sender: TObject);
    procedure btnRetualAllClick(Sender: TObject);
    procedure dbgrd2KeyPress(Sender: TObject; var Key: Char);
    procedure btnReturClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fReturPembelian: TfReturPembelian;
  kode, idRetur : string;
  
implementation

uses
  dataModule, ADODB, uProsesRetur, u_confirmReturAll, StrUtils, 
  u_returAllPembelian;

{$R *.dfm}

procedure konek;
begin
 with dm.qryRelasiPembelian do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select a.id as id_pembelian, a.no_faktur, a.no_faktur_supplier, a.tgl_pembelian, a.jumlah_item, a.total, b.id as '+
                  'id_detail_pembelian, b.obat_id, b.jumlah_beli, b.harga_beli, c.kode, c.barcode, c.nama_obat, c.tgl_obat, c.tgl_exp, '+
                  'd.jenis, e.satuan from tbl_pembelian a left join tbl_detail_pembelian b on b.pembelian_id = a.id left join tbl_obat c '+
                  'on c.id = b.obat_id left join tbl_jenis d on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan '+
                  'where a.no_faktur = '+QuotedStr('kosong')+'';
      Open;
    end;
end;

procedure konekRelasiReturObat(faktur : string = 'kosong');
begin
  with dm.qryDtlRetur do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'select * from tbl_retur a left join tbl_detail_retur b on b.retur_id = a.id inner join tbl_obat c on c.id = b.obat_id where a.faktur_penjualan = '+QuotedStr(faktur)+'';
      Open;
    end;
end;

procedure TfReturPembelian.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfReturPembelian.edtFakturKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key=#13 then btnCari.Click;
end;

procedure TfReturPembelian.btnCariClick(Sender: TObject);
begin
  if edtFaktur.Text = '' then
    begin
      MessageDlg('No. Faktur Belum Dimasukkan',mtInformation,[mbOK],0);
      edtFaktur.SetFocus;
      Exit;
    end;

  //cek nota sudah pernah di retur atau tidak
  with dm.qryRetur do
    begin
      close;
      sql.Clear;
      sql.Text := 'select * from tbl_retur where faktur_penjualan = '+QuotedStr(edtFaktur.Text)+'';
      Open;

      if recordcount > 0 then
        begin
          MessageDlg('Nota Sudah Pernah Di Retur',mtInformation,[mbOK],0);
          Exit;
        end;
    end;


  with dm.qryRelasiPembelian do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select a.id as id_pembelian, a.no_faktur, a.no_faktur_supplier, a.tgl_pembelian, a.jumlah_item, a.total, b.id as '+
                  'id_detail_pembelian, b.obat_id, b.jumlah_beli, b.harga_beli, c.kode, c.barcode, c.nama_obat, c.tgl_obat, c.tgl_exp, '+
                  'd.jenis, e.satuan from tbl_pembelian a left join tbl_detail_pembelian b on b.pembelian_id = a.id left join tbl_obat c '+
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
          edtTanggalJual.Text := fieldbyname('tgl_pembelian').AsString;
          edtIdPembelian.Text := fieldbyname('id_pembelian').AsString;

          with dm.qryPembelianSupplier do
            begin
              close;
              sql.Clear;
              SQL.Text := 'select b.* from tbl_pembelian a left join tbl_supplier b on b.id = a.supplier_id where a.id = '+QuotedStr(dm.qryRelasiPembelian.fieldbyname('id_pembelian').AsString)+'';
              Open;

              edtSupplier.Text := fieldbyname('nama_supplier').AsString;
            end;
        end;
    end;
end;

procedure TfReturPembelian.FormShow(Sender: TObject);
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

  edtSupplier.Clear;

  konek;
  konekRelasiReturObat;
end;

procedure TfReturPembelian.btnTambahClick(Sender: TObject);
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
              FieldByName('jenis_retur').AsString := 'pembelian';
              Post;

              Close;
              sql.Clear;
              SQL.Text := 'select * from tbl_retur where kode = '+QuotedStr(edtKode.Text)+'';
              Open;

              idRetur := fieldbyname('id').AsString;
            end;
        end;
    end
  else
    begin
      if MessageDlg('Yakin Transaksi Akan Dibatalkan',mtConfirmation, [mbYes,mbNo],0) = mryes then
        begin
          with dm.qryRetur do
            begin
              close;
              sql.Clear;
              SQL.Text := 'select * from tbl_retur where kode = '+QuotedStr(edtKode.Text)+'';
              Open;

              idRetur := fieldbyname('id').AsString;

              Close;
              sql.Clear;
              sql.Text := 'delete from tbl_retur where kode = '+QuotedStr(edtKode.Text)+'';
              ExecSQL;
            end;

          with dm.qryStok do
            begin
              close;
              sql.Clear;
              sql.Text := 'delete from tbl_stok where no_faktur = '+QuotedStr(edtFaktur.Text)+' and keterangan = '+QuotedStr('retur-pembelian')+'';
              ExecSQL;
            end;

          with dm.qryDetailReturTable do
            begin
              Close;
              sql.Clear;
              SQL.Text := 'delete from tbl_detail_retur where retur_id = '+QuotedStr(idRetur)+'';
              ExecSQL;
            end;

          FormShow(Sender);
        end;
    end;
end;


procedure TfReturPembelian.dbgrd1DblClick(Sender: TObject);
begin
  btnRetur.Click;
end;

procedure TfReturPembelian.btnSelesaiClick(Sender: TObject);
var a, jmlRetur, jmlBeli, stokObat : Integer;
    obatId : string;
begin
  if MessageDlg('Selesaikan Transaksi',mtConfirmation,[mbyes,mbNo],0) = mryes then
    begin
      // cek data di tbl_stok sesui kode retur
      with dm.qryStok do
        begin
          Close;
          sql.Clear;
          SQL.Text := 'select * from tbl_stok where no_faktur = '+QuotedStr(edtFaktur.Text)+' and keterangan = '+QuotedStr('retur-pembelian')+'';
          Open;

          if IsEmpty then
            begin
              MessageDlg('Transaksi Tidak Bisa Diselesaikan!',mtInformation,[mbok],0);
              Exit;
            end
          else
            begin
              //loop
              for a:= 1 to RecordCount do
                begin
                  RecNo := a;
                  obatId := dm.qryStok.fieldbyname('obat_id').AsString;
                  jmlRetur := dm.qryStok.fieldbyname('jumlah').AsInteger;

                  //tabahkan stok tbl_obat
                  with dm.qryObat do
                    begin
                      close;
                      sql.Clear;
                      SQL.Text := 'select * from tbl_obat where id = '+QuotedStr(obatId)+'';
                      Open;

                      stokObat := dm.qryObat.fieldbyname('stok').AsInteger;

                      //update
                      close;
                      SQL.Clear;
                      SQL.Text := 'update tbl_obat set stok = '+QuotedStr(IntToStr(stokObat-jmlRetur))+' where id = '+QuotedStr(obatId)+'';
                      ExecSQL;
                    end;
                end;

                MessageDlg('Transaksi Berhasil Disimpan', mtInformation,[mbOK],0);
                FormShow(Sender);
            end;
        end;
    end;
end;

procedure TfReturPembelian.btnRetualAllClick(Sender: TObject);
begin
 fReturAllPembelian.edtKodeRetur.Text := edtKode.Text;
 fReturAllPembelian.edtFaktur.Text := edtFaktur.Text;
 fReturAllPembelian.edtIdPembelian.Text := edtIdPembelian.Text;

 fReturAllPembelian.ShowModal;
end;

procedure TfReturPembelian.dbgrd2KeyPress(Sender: TObject; var Key: Char);
var idObat, idRetur : string;
    jmlItem, jmlRetur : Integer;
begin
  if Key=#13 then
    begin
      idRetur := dbgrd2.Fields[7].AsString;
      idObat := dbgrd2.Fields[8].AsString;
      jmlItem := dbgrd2.Fields[23].AsInteger;
      jmlRetur := dbgrd2.Fields[21].AsInteger;

      if jmlRetur > jmlItem then
        begin
          MessageDlg('Cek Kembali Jumlah Barang Di Retur',mtInformation,[mbOK],0);
          dbgrd2.Fields[21].AsInteger := jmlItem;
          Exit;
        end
      else
        begin
          //update jml retur
          with dm.qryDetailReturTable do
            begin
              close;
              SQL.Clear;
              SQL.Text := 'update tbl_detail_retur set jumlah_retur = '+QuotedStr(IntToStr(jmlRetur))+' where retur_id = '+QuotedStr(idRetur)+'';
              ExecSQL;
            end;
        end;

      konekRelasiReturObat(edtFaktur.Text);
    end;
end;

procedure TfReturPembelian.btnReturClick(Sender: TObject);
var idObat, hargaRetur, jmlRetur, jmlItem, status, catatan : string;
begin
  with dm.qryDetailReturTable do
    begin
      // cek sudah ada atau tidak ada, kalo tidak ada exit
      close;
      sql.Clear;
      sql.Text := 'select * from tbl_detail_retur a left join tbl_retur b on b.id = a.retur_id where b.faktur_penjualan = '+QuotedStr(edtFaktur.Text)+' and '+
                  'a.obat_id = '+QuotedStr(dbgrd1.Fields[8].AsString)+'';
      Open;

      if recordcount > 0 then
        begin
          MessageDlg('Item Sudah Dimasukkan',mtInformation,[mbOK],0);
          Exit;
        end
      else
        begin
          with dm.qryRetur do
            begin
              Close;
              SQL.Clear;
              SQL.Text := 'update tbl_retur set faktur_penjualan = '+QuotedStr(edtFaktur.Text)+' where id = '+QuotedStr(idRetur)+'';
              ExecSQL;
            end;      

          idObat := dbgrd1.Fields[6].AsString;
          hargaRetur := dbgrd1.Fields[11].AsString;
          jmlRetur := '0';
          jmlItem := dbgrd1.Fields[10].AsString;
          status := 'retur-pembelian';

          close;
          sql.Clear;
          SQL.Text := 'insert into tbl_detail_retur (retur_id, obat_id, harga_retur, jumlah_retur, jumlah_item, status) values '+
                      '( '+QuotedStr(idRetur)+', '+QuotedStr(idObat)+', '+QuotedStr(hargaRetur)+', '+QuotedStr(jmlRetur)+', '+QuotedStr(jmlItem)+', '+QuotedStr(status)+')';
          ExecSQL;

          konekRelasiReturObat(edtFaktur.Text);
          btnRetualAll.Enabled := false;
          btnSelesai.Enabled := True;
        end;
    end;
end;

end.
