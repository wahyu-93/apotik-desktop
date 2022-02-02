unit uSetHarga;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, ComCtrls, jpeg, ExtCtrls, Math;

type
  TfSetHarga = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lblNamaObat: TLabel;
    lblJenis: TLabel;
    lblSatuan: TLabel;
    lblHargaBeli: TLabel;
    lblSupplier: TLabel;
    edtKode: TEdit;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnTambah: TBitBtn;
    btnSimpan: TBitBtn;
    btnHapus: TBitBtn;
    btnKeluar: TBitBtn;
    btnBantuObat: TBitBtn;
    edtIdObat: TEdit;
    img1: TImage;
    bvl1: TBevel;
    grp3: TGroupBox;
    lbl22: TLabel;
    lbl9: TLabel;
    lbl21: TLabel;
    edtHargaBeli: TEdit;
    dtpTglExp: TDateTimePicker;
    edtSupplier: TEdit;
    grp4: TGroupBox;
    lbl23: TLabel;
    edtHarga: TEdit;
    lbl10: TLabel;
    edtHargaGrosir: TEdit;
    lbl11: TLabel;
    edtMaxGrosir: TEdit;
    lbl12: TLabel;
    lbl13: TLabel;
    edtLabaHarga: TEdit;
    edtLabaHargaGrosir: TEdit;
    edtLabaPersenHarga: TEdit;
    edtLabaPersenGrosir: TEdit;
    procedure btnBantuObatClick(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnTambahClick(Sender: TObject);
    procedure btnSimpanClick(Sender: TObject);
    procedure edtHargaKeyPress(Sender: TObject; var Key: Char);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure btnHapusClick(Sender: TObject);
    procedure konek;
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtHargaBeliKeyPress(Sender: TObject; var Key: Char);
    procedure dbgrd1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure edtHargaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtHargaGrosirKeyPress(Sender: TObject; var Key: Char);
    procedure edtHargaGrosirKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtMaxGrosirKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSetHarga: TfSetHarga;
  untung, persentase : real;

implementation

uses
  dataModule, uBantuObat, DB, ADODB, DateUtils;

{$R *.dfm}

procedure TfSetHarga.btnBantuObatClick(Sender: TObject);
begin
  fBantuObat.edt1.Text := 'setHarga';
  fBantuObat.ShowModal;
end;

procedure TfSetHarga.btnKeluarClick(Sender: TObject);
begin
  Close;
end;

procedure TfSetHarga.FormShow(Sender: TObject);
begin
  edtKode.Clear; edtKode.Enabled := false;
  edtHarga.Clear; edtHarga.Enabled := False;
  btnBantuObat.Enabled := false;
  edtpencarian.Enabled := True; edtpencarian.SetFocus; edtpencarian.Clear;

  lblNamaObat.Caption := '-';
  lblJenis.Caption := '-';
  lblSatuan.Caption := '-';
  lblHargaBeli.Caption := '-';
  lblSupplier.Caption := '-';

  btnTambah.Caption := 'Tambah[F1]'; btnTambah.Enabled := True;
  btnSimpan.Enabled := false;
  btnHapus.Enabled := False;
  btnKeluar.Enabled := True;

  dtpTglExp.Enabled := False;
  dtpTglExp.Date := Now;

  edtHargaBeli.Clear; edtHargaBeli.Enabled := false;
  edtSupplier.Clear; edtSupplier.Enabled := false;

  btnSimpan.Caption := 'Simpan';

  edtHargaGrosir.Enabled := False; edtHargaGrosir.Clear;
  edtMaxGrosir.Enabled := false; edtMaxGrosir.Clear;
  edtLabaHarga.Clear; edtLabaHarga.Enabled := false;
  edtLabaHargaGrosir.Clear; edtLabaHargaGrosir.Enabled := false;
  edtLabaPersenHarga.Clear; edtLabaPersenHarga.Enabled := false;
  edtLabaPersenGrosir.Clear; edtLabaPersenGrosir.Enabled := false;
  
  konek;
end;

procedure TfSetHarga.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F1: btnTambah.Click;
    VK_F2: btnBantuObat.Click;
  end;
end;

procedure TfSetHarga.btnTambahClick(Sender: TObject);
begin
  if btnTambah.Caption = 'Tambah[F1]' then
    begin
      btnBantuObat.Enabled := True;
      edtHarga.Enabled := True;
      edtHarga.SetFocus;

      edtpencarian.Enabled := false; edtpencarian.Clear;
      dtpTglExp.Enabled := True;

      btnSimpan.Enabled := True;
      btnTambah.Caption := 'Batal[F1]';

      edtHargaGrosir.Enabled := True; edtHargaGrosir.Text := '0';
      edtMaxGrosir.Enabled := True; edtMaxGrosir.Text := '0';

    end
  else
    begin
      FormShow(Sender);
    end;
end;

procedure TfSetHarga.btnSimpanClick(Sender: TObject);
var hargabeli : string;
    id_set_harga : string;
    hargaGrosir, maxGrosir : Real;
begin
  if btnSimpan.Caption = 'Simpan' then
    begin
      if edtKode.Text = '' then
        begin
          MessageDlg('Obat Belum Dipilih', mtInformation,[mbok],0);
          Exit;
        end;

      if edtHargaBeli.Text = '' then
        begin
          MessageDlg('Harga Beli Belum Diisi' ,mtInformation,[mbOK],0);
          edtHargaBeli.SetFocus;
          Exit;
        end;

      if edtHarga.Text = '' then
        begin
          MessageDlg('Harga Jual Belum Diisi' ,mtInformation,[mbOK],0);
          edtHarga.SetFocus;
          Exit;
        end;

      if edtHargaBeli.Text = '' then hargabeli := '0' else hargabeli := edtHargaBeli.Text;
      if edtHargaGrosir.Text = '' then hargaGrosir := 0 else hargaGrosir := StrToFloat(edtHargaGrosir.Text);
      if edtMaxGrosir.Text = '' then maxGrosir := 0 else maxGrosir := StrToFloat(edtMaxGrosir.Text);

      with dm.qrySetHarga do
        begin
          Close;
          sql.Clear;
          SQL.Text := 'select * from tbl_harga_jual where obat_id = '+QuotedStr(edtIdObat.Text)+'';
          Open;

          id_set_harga := fieldbyname('id').AsString;

          if IsEmpty then
            begin
              Append;
              FieldByName('obat_id').AsString := edtIdObat.Text;
              FieldByName('harga_jual').AsString := edtHarga.Text;
              FieldByName('harga_beli_terakhir').AsString := hargabeli;
              FieldByName('supplier').AsString := lblSupplier.Caption;
              FieldByName('satuan').AsString := lblSatuan.Caption;
              FieldByName('jenis').AsString := lblJenis.Caption;
              FieldByName('harga_jual_grosir').AsFloat := hargaGrosir;
              FieldByName('qty_max_grosir').AsFloat := maxGrosir;
              Post;

              MessageDlg('Data Berhasil Disimpan', mtInformation,[mbOK],0);
            end
          else
            begin
              with dm.qrySetHarga do
                begin
                  close;
                  sql.Clear;
                  SQL.Text := 'update tbl_harga_jual set harga_beli_terakhir = '+QuotedStr(hargabeli)+', harga_jual = '+QuotedStr(edtHarga.Text)+
                              ', harga_jual_grosir = '+QuotedStr(FloatToStr(hargaGrosir))+', qty_max_grosir = '+QuotedStr(FloatToStr(maxGrosir))+' where id = '+QuotedStr(id_set_harga)+'';
                  ExecSQL;

                  MessageDlg('Harga Obat Berhasil Diupdate',mtInformation,[mbok],0);
                end;
            end;
        end;

      with dm.qryObat do
        begin
          close;
          sql.clear;
          SQL.Text := 'update tbl_obat set tgl_exp = '+QuotedStr(FormatDateTime('yyyy-mm-dd',dtpTglExp.Date))+', status='+QuotedStr('1')+' where id = '+QuotedStr(edtIdObat.Text)+'';
          ExecSQL;
        end;

      FormShow(Sender);
    end
  else
    begin
      dtpTglExp.Enabled := True;
      edtHarga.Enabled := True; edtHarga.SetFocus;

      btnTambah.Caption := 'Batal';
      btnSimpan.Caption := 'Simpan';
      btnHapus.Enabled := false;

      edtHargaGrosir.Enabled := True;
      edtMaxGrosir.Enabled := True;

      if edtSupplier.Text = '' then
        edtHargaBeli.Enabled := True
      else
        edtHargaBeli.Enabled := false;

    end;

end;

procedure TfSetHarga.edtHargaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in(['0'..'9',#13,#9,#8])) then Key:=#0;
end;

procedure TfSetHarga.dbgrd1DblClick(Sender: TObject);
begin
  if dm.qryRelasiSetHarga.IsEmpty then Exit;
  
  edtKode.Text := dbgrd1.Fields[1].AsString;
  lblNamaObat.Caption := dbgrd1.Fields[3].AsString;
  lblJenis.Caption := dbgrd1.Fields[17].AsString;
  lblSatuan.Caption := dbgrd1.Fields[16].AsString;
  lblHargaBeli.Caption := 'Rp. ' + FormatFloat('###,###',StrToFloat(dbgrd1.Fields[5].AsString));
  lblSupplier.Caption := dbgrd1.Fields[6].AsString;

  edtHargaBeli.Text := dbgrd1.Fields[5].AsString;
  edtIdObat.Text := dbgrd1.Fields[2].AsString;
  dtpTglExp.Date := dbgrd1.Fields[7].AsDateTime;
  edtHarga.Text := dbgrd1.Fields[4].AsString;

  edtHargaGrosir.Text := dbgrd1.Fields[18].AsString;
  edtMaxGrosir.Text := dbgrd1.Fields[19].AsString;

  edtLabaPersenGrosir.Clear;
  edtLabaHarga.Clear;
  edtLabaPersenHarga.Clear;
  edtLabaHargaGrosir.Clear;

  if edtHarga.Text <> '0' then
    begin
       untung := StrToFloat(edtHarga.Text) - StrToFloat(edtHargaBeli.Text);
       edtLabaHarga.Text := FloatToStr(untung);

       persentase := (untung / StrToFloat(edtHargaBeli.Text)) * (100);
       edtLabaPersenHarga.Text := FloatToStr(Floor(persentase)) + '%';
    end;

  if edtHargaGrosir.Text <> '0' then
    begin
      untung := StrToFloat(edtHargaGrosir.Text) - StrToFloat(edtHargaBeli.Text);
      edtLabaHargaGrosir.Text := FloatToStr(untung);

      persentase := (untung / StrToFloat(edtHargaBeli.Text)) * (100);
      edtLabaPersenGrosir.Text := FloatToStr(Floor(persentase)) + '%';
    end;

  btnTambah.Caption := 'Batal[F1]';
  btnBantuObat.Enabled := false;
  btnHapus.Enabled := false;
  btnHapus.Enabled := true;

  btnSimpan.Caption := 'Edit';
  btnSimpan.Enabled := True;
end;

procedure TfSetHarga.btnHapusClick(Sender: TObject);
begin
  if MessageDlg('Yakin Data Akan Dihapus ?',mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      with dm.qrySetHarga do
        begin
          close;
          SQL.Clear;
          SQL.Text := 'delete from tbl_harga_jual where obat_id = '+QuotedStr(edtIdObat.Text)+'';
          ExecSQL;
        end;

       with dm.qryObat do
        begin
          close;
          SQL.Clear;
          SQL.Text := 'update tbl_obat set status = '+QuotedStr('0')+' where id = '+QuotedStr(edtIdObat.Text)+'';
          ExecSQL;
        end;

      MessageDlg('Data Berhasil Dihapus ?',mtInformation,[mbok],0);
      FormShow(Sender);
    end;
end;

procedure TfSetHarga.konek;
begin
  with dm.qryRelasiSetHarga do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id = b.id order by a.id';
      Open;
    end;
end;

procedure TfSetHarga.edtpencarianKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   with dm.qryRelasiSetHarga do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id = b.id where b.nama_obat like ''%'+edtpencarian.Text+'%'' order by a.id';
      Open;
    end;
end;

procedure TfSetHarga.edtHargaBeliKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in(['0'..'9',#13,#9,#8])) then Key:=#0;
  if Key=#13 then edtHarga.SetFocus;
end;

procedure TfSetHarga.dbgrd1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  datenow, datethen : TDateTime;
  tglNow, bulanNow, tahunNow,
  tglThen, bulanThen, tahunThen : string;
  hasil : Integer;
begin
  tglNow := FormatDateTime('dd',Now);
  bulanNow := FormatDateTime('mm',Now);
  tahunNow := FormatDateTime('yyyy',Now);

  tglThen := FormatDateTime('dd', dbgrd1.Fields[7].AsDateTime);
  bulanThen := FormatDateTime('mm', dbgrd1.Fields[7].AsDateTime);
  tahunThen := FormatDateTime('yyyy',dbgrd1.Fields[7].AsDateTime);

  datenow := EncodeDate(StrToInt(tahunNow), StrToInt(bulanNow), StrToInt(tglNow));
  datethen:= EncodeDate(StrToInt(tahunThen), StrToInt(bulanThen), StrToInt(tglThen));

  hasil := DaysBetween(datenow, datethen);

  if hasil <= 100 then
    begin
      dbgrd1.Canvas.Brush.Color := clRed;
      dbgrd1.Canvas.Font.Color := clBlack;
    end;
  dbgrd1.DefaultDrawColumnCell(rect, datacol, column, state);
end;

procedure TfSetHarga.edtHargaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if edtHargaBeli.Text = '' then
    begin
      edtLabaHarga.Text  := '0';
      edtLabaPersenHarga.Text := '0%';
    end
  else
    begin
      if edtHarga.Text = '' then
        begin
          edtLabaHarga.Text := '0';
          edtLabaPersenHarga.Text := '0';
        end
      else
        begin
          untung := StrToFloat(edtHarga.Text) - StrToFloat(edtHargaBeli.Text);
          edtLabaHarga.Text := FloatToStr(untung);

          persentase := (untung / StrToFloat(edtHargaBeli.Text)) * (100);
          edtLabaPersenHarga.Text := FloatToStr(Floor(persentase)) + '%';
        end;
    end;
end;

procedure TfSetHarga.edtHargaGrosirKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in(['0'..'9',#13,#9,#8])) then Key:=#0;
end;

procedure TfSetHarga.edtHargaGrosirKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if edtHargaBeli.Text = '' then
    begin
      edtLabaHargaGrosir.Text  := '0';
      edtLabaPersenGrosir.Text := '0%';
    end
  else
    begin
      if edtHargaGrosir.Text = '' then
        begin
          edtLabaHargaGrosir.Text := '0';
          edtLabaPersenGrosir.Text := '0';
        end
      else
        begin
          untung := StrToFloat(edtHargaGrosir.Text) - StrToFloat(edtHargaBeli.Text);
          edtLabaHargaGrosir.Text := FloatToStr(untung);

          persentase := (untung / StrToFloat(edtHargaBeli.Text)) * (100);
          edtLabaPersenGrosir.Text := FloatToStr(Floor(persentase)) + '%';
        end;
    end;
end;

procedure TfSetHarga.edtMaxGrosirKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in(['0'..'9',#13,#9,#8])) then Key:=#0;
end;

end.
