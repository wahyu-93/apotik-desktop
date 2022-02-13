unit uBayar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfBayar = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    edtTotalBayar: TEdit;
    btnKeluar: TBitBtn;
    lbl4: TLabel;
    lbl2: TLabel;
    edtBayar: TEdit;
    edtKembalian: TEdit;
    lbl3: TLabel;
    edtTtlBayar: TEdit;
    edtByar: TEdit;
    edtKmbalian: TEdit;
    btnBayar: TBitBtn;
    img1: TImage;
    btnPending: TBitBtn;
    procedure edtBayarKeyPress(Sender: TObject; var Key: Char);
    procedure btnBayarClick(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtBayarKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnPendingClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fBayar: TfBayar;

implementation

uses
  uPenjualan;

{$R *.dfm}

Function Ribuan(Edit : TEdit):String;
var
 NilaiRupiah: string;
 AngkaRupiah: Currency;
begin
  if Edit.Text='' then Exit;
   NilaiRupiah := Edit.text;
   NilaiRupiah := StringReplace(NilaiRupiah,',','',[rfReplaceAll,rfIgnoreCase]);
   NilaiRupiah := StringReplace(NilaiRupiah,'.','',[rfReplaceAll,rfIgnoreCase]);
   AngkaRupiah := StrToCurrDef(NilaiRupiah,0);
   Edit.Text := FormatCurr('#,###',AngkaRupiah);
   Edit.SelStart := length(Edit.text);
end;

procedure TfBayar.edtBayarKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#8,#9,#13]) then key:=#0;
  if Key = #13 then btnBayar.Click;
end;

procedure TfBayar.btnBayarClick(Sender: TObject);
begin
  if edtBayar.Text = '' then
    begin
      exit;
    end;

  if StrToInt(edtBayar.Text) <= 0 then
    begin
      exit;
    end;

  if StrToInt(edtKmbalian.Text) < 0 then
    begin
      MessageDlg('Masukkan Pembayaran Dengan Benar',mtInformation,[mbok],0);
      edtBayar.SetFocus;
      Exit;
    end;

  Fpenjualan.edtBayar.Text := edtByar.Text;
  Fpenjualan.edtKembali.Text := edtKmbalian.Text;
  Fpenjualan.edtStatusPenjualan.Text := 'selesai';
  Fpenjualan.btnProses.Click;

  Close;
end;

procedure TfBayar.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfBayar.FormShow(Sender: TObject);
begin
  edtByar.Enabled := True; edtBayar.SetFocus;
  Ribuan(edtTotalBayar);
end;

procedure TfBayar.edtBayarKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if edtBayar.Text = '' then
    begin
      edtByar.Text := '0';
      edtKembalian.Text := '0';
      Exit;
    end;

  if edtBayar.Text = '0' then
    begin
      edtKmbalian.Text := '0';
      edtByar.Text := '0';
      Exit;
    end;

  edtByar.Text := edtBayar.Text;
  edtKmbalian.Text := IntToStr(StrToInt(edtByar.Text) - StrToInt(edtTtlBayar.Text));

  if (edtKmbalian.Text = '0') or (edtByar.Text='0') then
    edtKembalian.Text := '0'
  else
    begin
      edtKembalian.Text := edtKmbalian.Text;
      Ribuan(edtKembalian);
    end;
end;

procedure TfBayar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F8: btnPending.Click;
    VK_F9: btnBayar.Click;
    VK_f10: btnKeluar.Click;
  end;
end;

procedure TfBayar.btnPendingClick(Sender: TObject);
begin
  edtBayar.Text := '0';
  edtKembalian.Text := '0';

  Fpenjualan.edtStatusPenjualan.Text := 'pending';
  Fpenjualan.btnProses.Click;
  close;
end;

end.
