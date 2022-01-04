program Apoik_app;

uses
  Forms,
  uForm in 'uForm.pas' {FMenu},
  dataModule in 'dataModule.pas' {dm: TDataModule},
  uJenisObat in 'uJenisObat.pas' {fJenisObat},
  uSatuan in 'uSatuan.pas' {FSatuan},
  uSupplier in 'uSupplier.pas' {Fsupplier},
  uObat in 'uObat.pas' {Fobat},
  uPenjualan in 'uPenjualan.pas' {Fpenjualan},
  uPembelian in 'uPembelian.pas' {fPembelian},
  uBantuObat in 'uBantuObat.pas' {fBantuObat},
  uPembayaranPembelian in 'uPembayaranPembelian.pas' {fPembayaranPembelian},
  uSetHarga in 'uSetHarga.pas' {fSetHarga},
  uBantuObatPenjualan in 'uBantuObatPenjualan.pas' {fBantuObatPenjualan};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMenu, FMenu);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfJenisObat, fJenisObat);
  Application.CreateForm(TFSatuan, FSatuan);
  Application.CreateForm(TFsupplier, Fsupplier);
  Application.CreateForm(TFobat, Fobat);
  Application.CreateForm(TFpenjualan, Fpenjualan);
  Application.CreateForm(TfPembelian, fPembelian);
  Application.CreateForm(TfBantuObat, fBantuObat);
  Application.CreateForm(TfPembayaranPembelian, fPembayaranPembelian);
  Application.CreateForm(TfSetHarga, fSetHarga);
  Application.CreateForm(TfBantuObatPenjualan, fBantuObatPenjualan);
  Application.Run;
end.
