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

uses dataModule;

{$R *.dfm}

procedure TfLaporanStok.btnKeluarClick(Sender: TObject);
begin
  close;
end;

procedure TfLaporanStok.FormShow(Sender: TObject);
begin
  with dm.qryLaporanStok do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_obat a left join tbl_satuan b on a.kode_satuan = b.id order by a.stok asc';
      Open;
    end;
end;

end.
