unit uReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfReturn = class(TForm)
    grp1: TGroupBox;
    lbl1: TLabel;
    grp2: TGroupBox;
    edtNama: TEdit;
    lbl3: TLabel;
    lbl2: TLabel;
    lbl4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fReturn: TfReturn;

implementation

{$R *.dfm}

end.
