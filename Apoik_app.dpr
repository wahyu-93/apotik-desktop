program Apoik_app;

uses
  Forms,
  uForm in 'uForm.pas' {FMenu},
  dataModule in 'dataModule.pas' {dm: TDataModule},
  uJenisObat in 'uJenisObat.pas' {fJenisObat},
  uSatuan in 'uSatuan.pas' {FSatuan};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMenu, FMenu);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfJenisObat, fJenisObat);
  Application.CreateForm(TFSatuan, FSatuan);
  Application.Run;
end.