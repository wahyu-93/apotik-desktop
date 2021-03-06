unit uBantuObat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls, Math;

type
  TfBantuObat = class(TForm)
    grp2: TGroupBox;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnPilih: TBitBtn;
    btnKeluar: TBitBtn;
    grp1: TGroupBox;
    lbl1: TLabel;
    edt1: TEdit;
    img1: TImage;
    procedure btnKeluarClick(Sender: TObject);
    procedure konek(status : string = 'pembelian');
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnPilihClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure dbgrd1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure dbgrd1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fBantuObat: TfBantuObat;

implementation

uses
  dataModule, uPembelian, DB, uSetHarga;

{$R *.dfm}

procedure TfBantuObat.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfBantuObat.edtpencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if edt1.Text = 'pembelian' then
    begin
      with dm.qryObatRelasi do
        begin
          close;
          sql.Clear;
          sql.Text := 'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_jenis, b.kode_satuan, b.stok, b.status, a.id as id_jenis, a.kode as jenisKode, a.jenis, c.id as id_satuan, '+
                      'c.kode as satuanKode, c.satuan from tbl_jenis a left join tbl_obat b on a.id = b.kode_jenis INNER join tbl_satuan c on c.id = b.kode_satuan where b.nama_obat like ''%'+edtpencarian.Text+'%'' order by b.id';
          Open;
        end;
    end
  else
  if edt1.Text = 'setHarga' then
    begin
      with dm.qryObatRelasi do
        begin
          close;
          sql.Clear;
          sql.Text := 'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_jenis, b.kode_satuan, b.stok, b.status, a.id as id_jenis, a.kode as jenisKode, a.jenis, c.id as id_satuan, '+
                      'c.kode as satuanKode, c.satuan from tbl_jenis a left join tbl_obat b on a.id = b.kode_jenis INNER join tbl_satuan c on c.id = b.kode_satuan '+
                      'where b.nama_obat like ''%'+edtpencarian.Text+'%''order by b.id';
          Open;
        end;
    end;
end;

procedure TfBantuObat.btnPilihClick(Sender: TObject);
var barcode : string;
    untung, persentase : real;
begin
  if edt1.Text = 'pembelian' then
    begin
      if dbgrd1.Fields[2].AsString = '' then barcode := dbgrd1.Fields[1].AsString else barcode := dbgrd1.Fields[1].AsString+' - '+dbgrd1.Fields[2].AsString;

      fPembelian.edtIdObat.Text := dbgrd1.Fields[0].AsString;
      fPembelian.edtKode.Text := barcode;
      fPembelian.edtNama.Text := dbgrd1.Fields[3].AsString;
      fPembelian.edtJenis.Text := dbgrd1.Fields[8].AsString;
      fPembelian.edtSatuan.Text := dbgrd1.Fields[11].AsString;

      fPembelian.edtHarga.Clear;
      fPembelian.edtJumlahBeli.Clear;
      fPembelian.dtpTanggalKadaluarsa.Date := Now;

      fPembelian.btnSimpan.Enabled := True; fPembelian.btnSimpan.Caption := 'Simpan';
      fPembelian.btnHapus.Enabled := false;

      fPembelian.edtHarga.Enabled := True;
      fPembelian.edtJumlahBeli.Enabled := True;

      Close;
    end
  else
  if edt1.Text = 'setHarga' then
    begin
      barcode := dbgrd1.Fields[1].AsString;

      fSetHarga.edtKode.Text := barcode;
      fSetHarga.lblNamaObat.Caption := dbgrd1.Fields[3].AsString;
      fSetHarga.lblSatuan.Caption := dbgrd1.Fields[11].AsString;
      fSetHarga.lblJenis.Caption := dbgrd1.Fields[8].AsString;

      with dm.qryRelasiStok do
        begin
          close;
          SQL.Clear;
          SQL.Text := 'select a.nama_supplier, b.id as id_pembelian, b.no_faktur, b.tgl_pembelian, b.supplier_id, c.harga, c.keterangan, c.created_at, '+
                      'd.id as id_obat, d.kode, d.barcode, d.nama_obat, d.tgl_exp, d.stok from tbl_supplier a left join tbl_pembelian b on b.supplier_id = a.id inner join '+
                      'tbl_stok c on c.no_faktur = b.no_faktur inner join tbl_obat d on d.id = c.obat_id where d.id = '+QuotedStr(dbgrd1.Fields[0].AsString)+' order by b.id desc';
          Open;
          first;
        end;         

      fSetHarga.lblHargaBeli.Caption := FormatFloat('Rp. ###,###,###', dm.qryRelasiStok.fieldbyname('harga').AsFloat);
      fSetHarga.lblSupplier.Caption := dm.qryRelasiStok.fieldbyname('nama_supplier').AsString;
      fSetHarga.edtSupplier.Text := dm.qryRelasiStok.fieldbyname('nama_supplier').AsString;

      fSetHarga.edtHarga.Enabled := True; fSetHarga.edtHarga.SetFocus;
      fSetHarga.edtIdObat.Text := dbgrd1.Fields[0].AsString;
      fSetHarga.edtHargaBeli.Text := dm.qryRelasiStok.fieldbyname('harga').AsString;
      fSetHarga.dtpTglExp.Enabled := True;

      fSetHarga.edtHargaGrosir.Enabled := True;
      fSetHarga.edtMaxGrosir.Enabled := True;

      if fSetHarga.edtSupplier.Text = '' then
        begin
          // cek harga di tabel set harga
          with dm.qryHarga do
            begin
              close;
              SQL.Clear;
              SQL.Text := 'select * from tbl_harga_jual where obat_id = '+QuotedStr(dbgrd1.Fields[0].AsString)+'';
              Open;

              if IsEmpty then
                begin
                  fSetHarga.edtHargaBeli.Enabled := True;
                  fSetHarga.edtHargaBeli.SetFocus;
                end
              else
                begin
                  fSetHarga.edtHargaBeli.Text := dm.qryHarga.fieldbyname('harga_beli_terakhir').AsString;
                  fSetHarga.edtHarga.Text := dm.qryHarga.fieldbyname('harga_jual').AsString;
                  fSetHarga.edtHargaGrosir.Text := dm.qryHarga.fieldbyname('harga_jual_grosir').AsString;
                  fSetHarga.edtMaxGrosir.Text := dm.qryHarga.fieldbyname('qty_max_grosir').AsString;

                  fSetHarga.edtLabaHarga.Text := FloatToStr(dm.qryHarga.fieldbyname('harga_jual').AsFloat - dm.qryHarga.fieldbyname('harga_beli_terakhir').AsFloat);

                  fSetHarga.edtLabaHargaGrosir.Text := FloatToStr(dm.qryHarga.fieldbyname('harga_jual_grosir').AsFloat - dm.qryHarga.fieldbyname('harga_beli_terakhir').AsFloat);
                end;
            end;
         end
      else
        begin
          fSetHarga.edtHargaBeli.Enabled := false;
        end;

      if dm.qryRelasiStok.FieldByName('tgl_exp').AsString = '' then
        fSetHarga.dtpTglExp.Date := Now
      else
        fSetHarga.dtpTglExp.Date := dm.qryRelasiStok.fieldbyname('tgl_exp').AsDateTime;

      if fSetHarga.edtHargaBeli.Text <> '' then
        begin
          if fSetHarga.edtHarga.Text <> '' then
            begin
               untung := StrToFloat(fSetHarga.edtHarga.Text) - StrToFloat(fSetHarga.edtHargaBeli.Text);
               fSetHarga.edtLabaHarga.Text := FloatToStr(untung);

               persentase := (untung / StrToFloat(fSetHarga.edtHargaBeli.Text)) * (100);
               fSetHarga.edtLabaPersenHarga.Text := FloatToStr(Floor(persentase)) + '%';
            end;

          if fSetHarga.edtHargaGrosir.Text <> '' then
            begin
              untung := StrToFloat(fSetHarga.edtHargaGrosir.Text) - StrToFloat(fSetHarga.edtHargaBeli.Text);
              fSetHarga.edtLabaHargaGrosir.Text := FloatToStr(untung);

              persentase := (untung / StrToFloat(fSetHarga.edtHargaBeli.Text)) * (100);
              fSetHarga.edtLabaPersenGrosir.Text := FloatToStr(Floor(persentase)) + '%';
            end;

        end;

      close;
    end;

end;

procedure TfBantuObat.dbgrd1DblClick(Sender: TObject);
begin
  btnPilih.Click;
end;

procedure TfBantuObat.dbgrd1KeyPress(Sender: TObject; var Key: Char);
begin
  btnPilih.Click;
end;    

procedure TfBantuObat.konek(status: string);
begin
  if status='pembelian' then
    begin
      with dm.qryObatRelasi do
        begin
          close;
          sql.Clear;
          sql.Text := 'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_jenis, b.kode_satuan, b.stok, b.status, a.id as id_jenis, a.kode as jenisKode, a.jenis, c.id as id_satuan, '+
                      'c.kode as satuanKode, c.satuan from tbl_jenis a left join tbl_obat b on a.id = b.kode_jenis INNER join tbl_satuan c on c.id = b.kode_satuan order by b.id';
          Open;
        end;
    end
  else
  if status='setHarga' then
    begin
      with dm.qryObatRelasi do
        begin
          close;
          sql.Clear;
          sql.Text := 'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_jenis, b.kode_satuan, b.stok, b.status, a.id as id_jenis, a.kode as jenisKode, a.jenis, c.id as id_satuan, '+
                      'c.kode as satuanKode, c.satuan from tbl_jenis a left join tbl_obat b on a.id = b.kode_jenis INNER join tbl_satuan c on c.id = b.kode_satuan '+
                      ' order by b.id';
          Open;
        end;
    end;
end;

procedure TfBantuObat.FormShow(Sender: TObject);
begin
  edtpencarian.Clear;
  konek(edt1.Text);
end;

procedure TfBantuObat.dbgrd1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if edt1.Text = 'setHarga' then
    begin
      if dm.qryObatRelasi.FieldByName('status').AsString = '1' then
      begin
        dbgrd1.Canvas.Brush.Color := clMoneyGreen;
        dbgrd1.Canvas.Font.Color := clBlack;
      end;
    end
  else
    begin
      if dm.qryObatRelasi.FieldByName('stok').AsString = '0' then
      begin
        dbgrd1.Canvas.Brush.Color := clSkyBlue;
        dbgrd1.Canvas.Font.Color := clBlack;
      end;
    end;
  dbgrd1.DefaultDrawColumnCell(rect, datacol, column, state);
end;

procedure TfBantuObat.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_UP: dbgrd1.SetFocus;
    VK_DOWN: dbgrd1.SetFocus;
  end;
end;

end.
