unit uBayar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fBayar: TfBayar;

implementation

{$R *.dfm}

end.
