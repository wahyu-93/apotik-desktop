unit u_labaPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, jpeg;

type
  TfLabaPenjualan = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    pnl1: TPanel;
    lblJumlah: TLabel;
    dbgrd1: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure btnKeluarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLabaPenjualan: TfLabaPenjualan;
  total, hargaJual, hargaLaba : Real;
  a : Integer;

implementation

uses
  dataModule;

{$R *.dfm}

procedure TfLabaPenjualan.FormShow(Sender: TObject);
begin
  with dm.qryLabaPenjualan do
    begin
      close;
      SQL.Clear;
      SQL.Text := 'select *, (a.harga_jual - a.harga_beli_terakhir) as laba from tbl_harga_jual a left join tbl_obat b on a.obat_id = b.id';
      Open;

      total := 0;
      hargaJual := 0;
      hargaLaba := 0;
      for a:= 1 to RecordCount do
        begin
          RecNo := a;
          total := total + (fieldbyname('harga_beli_terakhir').AsFloat);
          hargaJual := hargaJual + (fieldbyname('harga_jual').AsFloat);
          hargaLaba := hargaLaba + (fieldbyname('laba').AsFloat);

          Next;
        end;

      lblJumlah.Caption := 'Jumlah Total Harga Awal : '+ FormatFloat('Rp. ###,###,###', total)+ ' - ' +'Jumlah Total Harga Jual : '+FormatFloat('Rp. ###,###,###', hargaJual)+' - ' +'Jumlah Laba : '+FormatFloat('Rp. ###,###,###', hargaLaba)+'';
    end;
end;

procedure TfLabaPenjualan.btnKeluarClick(Sender: TObject);
begin
  close;
end;

end.
