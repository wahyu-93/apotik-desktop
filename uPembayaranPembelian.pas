unit uPembayaranPembelian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids;

type
  TfPembayaranPembelian = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    dbgrd1: TDBGrid;
    edtpencarian: TEdit;
    btnPilih: TBitBtn;
    btnKeluar: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPembayaranPembelian: TfPembayaranPembelian;

implementation

uses
  dataModule;

{$R *.dfm}

end.
