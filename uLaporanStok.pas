unit uLaporanStok;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  TfLaporanStok = class(TForm)
    img1: TImage;
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    btnKeluar: TBitBtn;
    dbgrdStok: TDBGrid;
    pnl1: TPanel;
    lblJumlah: TLabel;
    procedure btnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLaporanStok: TfLaporanStok;

implementation

uses dataModule, ADODB;

{$R *.dfm}

procedure TfLaporanStok.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfLaporanStok.FormShow(Sender: TObject);
var a : Integer;
    total : Real;
begin
  with dm.qryLaporanStok do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_obat a left join tbl_satuan b on a.kode_satuan = b.id left join tbl_harga_jual c on c.obat_id = a.id order by a.id;';
      Open;

      total := 0;
      for a:= 1 to RecordCount do
        begin
          RecNo := a;
          total := total + (fieldbyname('harga_beli_terakhir').AsFloat * fieldbyname('stok').AsInteger);
         
          Next;
        end;

      lblJumlah.Caption := 'Jumlah Obat : '+ IntToStr(RecordCount) +' - Jumlah Modal : ' + FormatFloat('Rp. ###,###,###', total);
    end;
end;

end.
