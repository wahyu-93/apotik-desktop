unit uForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, Grids, DBGrids, ComCtrls, StdCtrls, jpeg;

type
  TFMenu = class(TForm)
    mm1: TMainMenu;
    Master1: TMenuItem;
    Barang1: TMenuItem;
    Supplier1: TMenuItem;
    ransaksi1: TMenuItem;
    Setting1: TMenuItem;
    Keluar1: TMenuItem;
    Pembelian1: TMenuItem;
    Penjualan1: TMenuItem;
    Obat1: TMenuItem;
    Supplier2: TMenuItem;
    SettingHargaJual1: TMenuItem;
    ListPembelian1: TMenuItem;
    stat1: TStatusBar;
    tmr1: TTimer;
    grp1: TGroupBox;
    grp2: TGroupBox;
    grp3: TGroupBox;
    grp4: TGroupBox;
    grp5: TGroupBox;
    lbl1: TLabel;
    dbgrdPenjualan: TDBGrid;
    dbgrdPembelian: TDBGrid;
    dbgrdItemLaris: TDBGrid;
    dbgrdStok: TDBGrid;
    img1: TImage;
    lblTotalPenjualan: TLabel;
    lblTotalPembelian: TLabel;
    ListPenjualan1: TMenuItem;
    Pengguna1: TMenuItem;
    Apotik1: TMenuItem;
    tmr2: TTimer;
    procedure Keluar1Click(Sender: TObject);
    procedure Barang1Click(Sender: TObject);
    procedure Supplier1Click(Sender: TObject);
    procedure Supplier2Click(Sender: TObject);
    procedure Obat1Click(Sender: TObject);
    procedure Pembelian1Click(Sender: TObject);
    procedure ListPembelian1Click(Sender: TObject);
    procedure Penjualan1Click(Sender: TObject);
    procedure SettingHargaJual1Click(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Pengguna1Click(Sender: TObject);
    procedure Apotik1Click(Sender: TObject);
    procedure tmr2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMenu: TFMenu;

implementation

uses
  uJenisObat, uSatuan, uSupplier, uObat, uPembelian, uPembayaranPembelian, 
  uPenjualan, uSetHarga, dataModule, uPengguna, uSetting;

{$R *.dfm}

procedure TFMenu.Keluar1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFMenu.Barang1Click(Sender: TObject);
begin
  fJenisObat.ShowModal;
end;

procedure TFMenu.Supplier1Click(Sender: TObject);
begin
  FSatuan.ShowModal;
end;

procedure TFMenu.Supplier2Click(Sender: TObject);
begin
  Fsupplier.Show;
end;

procedure TFMenu.Obat1Click(Sender: TObject);
begin
  Fobat.ShowModal;
end;

procedure TFMenu.Pembelian1Click(Sender: TObject);
begin
  fPembelian.ShowModal;
end;

procedure TFMenu.ListPembelian1Click(Sender: TObject);
begin
  fPembayaranPembelian.ShowModal;
end;

procedure TFMenu.Penjualan1Click(Sender: TObject);
begin
  Fpenjualan.ShowModal;
end;

procedure TFMenu.SettingHargaJual1Click(Sender: TObject);
begin
  fSetHarga.ShowModal;
end;

procedure TFMenu.tmr1Timer(Sender: TObject);
begin
  FormShow(Sender);
end;

procedure TFMenu.FormShow(Sender: TObject);
begin
  stat1.Panels[0].Text := 'Pengguna : ' + dm.qryUser.FieldByName('nama').AsString;
  stat1.Panels[1].Text := 'Role : ' + dm.qryUser.fieldByname('role').AsString;

  with dm.qryLaporanPenjualan do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_penjualan left JOIN tbl_pelanggan on tbl_penjualan.id_pelanggan = tbl_pelanggan.id '+
                  'where tbl_penjualan.tgl_penjualan like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%'' order by tbl_penjualan.id asc';
      Open;
    end;

  with dm.qryLaporanPembelian do
    begin
      close;
      SQL.Clear;
      sql.Text := 'select * from tbl_pembelian left join tbl_supplier on tbl_pembelian.supplier_id = tbl_supplier.id '+
                  'where tbl_pembelian.tgl_pembelian = '+QuotedStr(FormatDateTime('yyyy-mm-dd',Now))+' order by tbl_pembelian.id asc';
      Open;
    end;

  with dm.qryLaporanItemLaris do
    begin
      Close;
      SQL.Clear;
      SQL.Text := 'select *, sum(a.jumlah_jual) as jmlItemJual from tbl_penjualan z left join tbl_detail_penjualan a on z.id = a.penjualan_id left join '+
                  'tbl_obat b on a.obat_id = b.id left join tbl_satuan d on d.id = b.kode_satuan where z.tgl_penjualan like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%'' group by a.obat_id order by jmlItemJual desc';
      Open;
    end;

  with dm.qryLaporanStok do
    begin
      close;
      sql.Clear;
      SQL.Text := 'select * from tbl_obat a left join tbl_satuan b on a.kode_satuan = b.id order by a.stok asc';
      Open;
    end;

  //total penjualan
  with dm.qryTotalPenjualan do
    begin
      close;
      sql.Clear;
      sql.Text := 'select sum(total) as total from tbl_penjualan where tgl_penjualan like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%''';
      Open;

      lblTotalPenjualan.Caption := 'Total Penjualan : ' + FormatFloat('Rp. ###,###,###', dm.qryTotalPenjualan.fieldbyname('total').AsFloat)
    end;

    
  //total pembelian
  with dm.qryTotalPembelian do
    begin
      close;
      sql.Clear;
      sql.Text := 'select sum(total) as total from tbl_pembelian where tgl_pembelian like ''%'+FormatDateTime('yyyy-mm-dd',Now)+'%''';
      Open;

      lblTotalPembelian.Caption := 'Total Pembelian : ' + FormatFloat('Rp. ###,###,###', dm.qryTotalPembelian.fieldbyname('total').AsFloat)
    end;


end;

procedure TFMenu.Pengguna1Click(Sender: TObject);
begin
  fPengguna.ShowModal;
end;

procedure TFMenu.Apotik1Click(Sender: TObject);
begin
  fSetting.ShowModal;
end;

procedure TFMenu.tmr2Timer(Sender: TObject);
begin
  stat1.Panels[2].Text := 'Tanggal ' + FormatDateTime('dd-mm-yyyy',Now) + ' : ' + TimeToStr(Now);
end;

end.
