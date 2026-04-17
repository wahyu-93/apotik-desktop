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

{procedure TfLaporanStok.FormShow(Sender: TObject);
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
end;   }

procedure TfLaporanStok.FormShow(Sender: TObject);
var 
  totalModal: Double;
  i : Integer;
begin
  with dm.qryLaporanStok do
  begin
    Close;
    CursorLocation := clUseClient; // <--- Tambahkan ini
    SQL.Clear;
    SQL.Add('SELECT a.id, a.nama_obat, b.no_batch, b.tgl_expired, c.satuan, ');
    SQL.Add('CAST(b.jumlah_sisa AS SIGNED) AS jumlah_sisa, ');
    SQL.Add('CAST(COALESCE(NULLIF(b.harga_beli, 0), h.harga_beli_terakhir, 0) AS DECIMAL(18,2)) AS harga_fix ');
    SQL.Add('FROM tbl_obat a ');
    SQL.Add('INNER JOIN tbl_batch b ON a.id = b.obat_id ');
    SQL.Add('LEFT JOIN tbl_harga_jual h ON a.id = h.obat_id ');
    Sql.Add('LEFT JOIN tbl_satuan c ON a.kode_satuan = c.id');
    SQL.Add('WHERE b.jumlah_sisa > 0 ');
    SQL.Add('ORDER BY a.nama_obat ASC');
    try
      Open;
    except
      on E: Exception do
      begin
        ShowMessage('Gagal membuka data: ' + E.Message);
        Exit;
      end;
    end;

    totalModal := 0;
    i := 0;
    while not Eof do
    begin
      i := i+1;
      totalModal := totalModal + (FieldByName('jumlah_sisa').AsFloat * FieldByName('harga_fix').AsFloat);
      Next;
    end;
    lblJumlah.Caption := 'Total Stok Aktif : ' + IntToStr(i) +' Record Batch - '+ 'Nilai Modal : ' + FormatFloat('Rp ###,###,###', totalModal);
  end;
end;

end.
