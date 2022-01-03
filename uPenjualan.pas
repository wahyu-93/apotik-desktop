unit uPenjualan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, Grids, DBGrids, ExtCtrls;

type
  TFpenjualan = class(TForm)
    grp2: TGroupBox;
    bvl1: TBevel;
    dbgrd1: TDBGrid;
    btnTambah: TBitBtn;
    btnKeluar: TBitBtn;
    grp1: TGroupBox;
    lbl6: TLabel;
    lbl1: TLabel;
    lbl3: TLabel;
    dtpTanggalBeli: TDateTimePicker;
    edtFaktur: TEdit;
    edtKode: TEdit;
    btnBantuObat: TBitBtn;
    btnSimpan: TBitBtn;
    btnHapus: TBitBtn;
    btnSelesai: TBitBtn;
    edtIdObat: TEdit;
    edtIdPembelian: TEdit;
    lbl8: TLabel;
    grp3: TGroupBox;
    lblItem: TLabel;
    grp4: TGroupBox;
    lblTotalHarga: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fpenjualan: TFpenjualan;

implementation

{$R *.dfm}

end.
