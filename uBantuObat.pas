unit uBantuObat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids;

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
    procedure btnKeluarClick(Sender: TObject);
    procedure konek(status : string = 'pembelian');
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnPilihClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure dbgrd1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
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
  with dm.qryObat do
    begin
      DisableControls;
      SQL.Clear;
      SQL.Text := 'select * from tbl_obat where nama_obat like ''%'+edtpencarian.Text+'%''';
      Open;
      EnableControls;
    end;  
end;

procedure TfBantuObat.btnPilihClick(Sender: TObject);
var barcode : string;
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
      if dbgrd1.Fields[2].AsString = '' then barcode := dbgrd1.Fields[1].AsString else barcode := dbgrd1.Fields[1].AsString+' - '+dbgrd1.Fields[2].AsString;

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
          First;
        end;

      fSetHarga.lblHargaBeli.Caption := FormatFloat('Rp. ###,###,###', dm.qryRelasiStok.fieldbyname('harga').AsFloat);
      fSetHarga.lblSupplier.Caption := dm.qryRelasiStok.fieldbyname('nama_supplier').AsString;
      fSetHarga.edtHarga.SetFocus;
      fSetHarga.edtIdObat.Text := dbgrd1.Fields[0].AsString;
      fSetHarga.edtHargaBeli.Text := dm.qryRelasiStok.fieldbyname('harga').AsString;

      if dm.qryRelasiStok.FieldByName('tgl_exp').AsString = '' then
        fSetHarga.dtpTglExp.Date := Now
      else
        fSetHarga.dtpTglExp.Date := dm.qryRelasiStok.fieldbyname('tgl_exp').AsDateTime;

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
          sql.Text := 'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_jenis, b.kode_satuan, a.id as id_jenis, a.kode as jenisKode, a.jenis, c.id as id_satuan, '+
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
          sql.Text := 'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_jenis, b.kode_satuan, a.id as id_jenis, a.kode as jenisKode, a.jenis, c.id as id_satuan, '+
                      'c.kode as satuanKode, c.satuan from tbl_jenis a left join tbl_obat b on a.id = b.kode_jenis INNER join tbl_satuan c on c.id = b.kode_satuan '+
                      'where b.stok > 0 order by b.id';
          Open;
        end;
    end;
end;

procedure TfBantuObat.FormShow(Sender: TObject);
begin
  edtpencarian.Clear;
  konek(edt1.Text);
end;

end.
