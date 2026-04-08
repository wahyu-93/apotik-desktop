unit UReportItemTerlaris;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls;

type
  TQuickReportJumlahItemTerjual = class(TQuickRep)
    qrbndTitleBand1: TQRBand;
    qrbndDetailBand1: TQRBand;
    qrbndSummaryBand1: TQRBand;
    qrlblNamaApotek: TQRLabel;
    qrlbl2: TQRLabel;
    qrlblLaporanBulanTanggal: TQRLabel;
    qrshp1: TQRShape;
    qrlbl4: TQRLabel;
    qrshp2: TQRShape;
    qrshp3: TQRShape;
    qrshp4: TQRShape;
    qrlbl1: TQRLabel;
    qrlbl3: TQRLabel;
    qrlbl5: TQRLabel;
    qrshp5: TQRShape;
    qrshp6: TQRShape;
    qrshp7: TQRShape;
    qrshp8: TQRShape;
    qrdbtxtnama_obat: TQRDBText;
    qrdbtxtnama_obat1: TQRDBText;
    qrdbtxtnama_obat2: TQRDBText;
    qrshp9: TQRShape;
    qrsysdt1: TQRSysData;
  private

  public

  end;

var
  QuickReportJumlahItemTerjual: TQuickReportJumlahItemTerjual;

implementation

uses
  dataModule;

{$R *.DFM}

end.
