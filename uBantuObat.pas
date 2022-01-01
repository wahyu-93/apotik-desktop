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
    procedure btnKeluarClick(Sender: TObject);
    procedure edtpencarianKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnPilihClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fBantuObat: TfBantuObat;

implementation

uses
  dataModule, uPembelian, DB;

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

procedure TfBantuObat.FormCreate(Sender: TObject);
begin
  edtpencarian.Clear;
end;

procedure TfBantuObat.btnPilihClick(Sender: TObject);
var barcode : string;
begin
  if dbgrd1.Fields[2].AsString = '' then barcode := dbgrd1.Fields[1].AsString else barcode := dbgrd1.Fields[1].AsString+' - '+dbgrd1.Fields[2].AsString;

  fPembelian.edtIdObat.Text := dbgrd1.Fields[0].AsString;
  fPembelian.edtKode.Text := barcode;
  fPembelian.edtNama.Text := dbgrd1.Fields[3].AsString;
  fPembelian.edtJenis.Text := dbgrd1.Fields[8].AsString;
  fPembelian.edtSatuan.Text := dbgrd1.Fields[11].AsString;

  fPembelian.btnSimpan.Enabled := True; fPembelian.btnSimpan.Caption := 'Simpan';
  fPembelian.btnHapus.Enabled := false;

  fPembelian.edtHarga.Enabled := True;
  fPembelian.edtJumlahBeli.Enabled := True;

  Close;
end;

procedure TfBantuObat.dbgrd1DblClick(Sender: TObject);
begin
  btnPilih.Click;
end;

end.
