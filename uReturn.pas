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
  dataModule, uProsesRetur, DB, StrUtils, u_confirmReturAll;

{$R *.dfm}

procedure konek;
begin
 with dm.qryRelasiPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select a.id as id_penjualan, a.no_faktur, a.tgl_penjualan, a.jumlah_item, a.total, b.id as id_detail_penjualan, '+
                  'b.obat_id, b.jumlah_jual, b.harga_jual, c.kode, c.barcode, c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, '+
                  'e.satuan from tbl_penjualan a left join tbl_detail_penjualan b on b.penjualan_id = a.id left join tbl_obat c '+
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
                  'e.satuan from tbl_penjualan a left join tbl_detail_penjualan b on b.penjualan_id = a.id left join tbl_obat c '+
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
var a, jmlRetur, jmlJual, stokObat : Integer;
    obatId : string;
begin
  if MessageDlg('Selesaikan Transaksi',mtConfirmation,[mbyes,mbNo],0) = mryes then
    begin
      // cek data di tbl_stok sesui kode retur
      with dm.qryStok do
        begin
          Close;
          sql.Clear;
          SQL.Text := 'select * from tbl_stok where no_faktur = '+QuotedStr(edtFaktur.Text)+' and keterangan = '+QuotedStr('retur-penjualan')+'';
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

                  //kurangkan data di detail_penjualan
                  with dm.qryDetailPenjualan do
                    begin
                      Close;
                      SQL.Clear;
                      SQL.Text := 'select * from tbl_detail_penjualan where penjualan_id = '+QuotedStr(edtIdPenjualan.Text)+' and obat_id = '+QuotedStr(obatId)+'';
                      Open;

                      jmlJual := dm.qryDetailPenjualan.fieldbyname('jumlah_jual').AsInteger;

                      //update
                      Close;
                      sql.Clear;
                      sql.Text := 'update tbl_detail_penjualan set jumlah_jual = '+QuotedStr(IntToStr(jmlJual - jmlRetur))+', status = '+QuotedStr('retur')+
                                  ' where penjualan_id = '+QuotedStr(edtIdPenjualan.Text)+' and obat_id = '+QuotedStr(obatId)+'';
                      ExecSQL;
                    end;

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
                      SQL.Text := 'update tbl_obat set stok = '+QuotedStr(IntToStr(stokObat+jmlRetur))+' where id = '+QuotedStr(obatId)+'';
                      ExecSQL;
                    end;
                end;

                MessageDlg('Transaksi Berhasil Disimpan', mtInformation,[mbOK],0);
                FormShow(Sender);
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
