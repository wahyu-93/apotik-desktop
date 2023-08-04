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
  uBantuObatPenjualan in 'uBantuObatPenjualan.pas' {fBantuObatPenjualan},
  uBayar in 'uBayar.pas' {fBayar},
  uFormBayarPembelian in 'uFormBayarPembelian.pas' {fBayarPembelian},
  uListPenjualan in 'uListPenjualan.pas' {fListPenjualan},
  uPengguna in 'uPengguna.pas' {fPengguna},
  uSetting in 'uSetting.pas' {fSetting},
  uLogin in 'uLogin.pas' {fLogin},
  uMenuKasir in 'uMenuKasir.pas' {fMenuKasir},
  uListJualObat in 'uListJualObat.pas' {fLaporanPenjualan},
  uLaporanPembelian in 'uLaporanPembelian.pas' {fLaporanPembelian},
  uLaporanStok in 'uLaporanStok.pas' {fLaporanStok},
  uLaporanItemTerjual in 'uLaporanItemTerjual.pas' {fLaporanJumlahItemTerjual},
  uDetailPenjualan in 'uDetailPenjualan.pas' {fDetailPenjualan},
  uDetailPembelian in 'uDetailPembelian.pas' {fDetailPembelian},
  uReturn in 'uReturn.pas' {fReturn},
  uProsesRetur in 'uProsesRetur.pas' {fProsesRetur},
  u_confirmReturAll in 'u_confirmReturAll.pas' {fReturAll},
  uListReturPenjualan in 'uListReturPenjualan.pas' {fListReturPenjualan},
  uDetailReturPenjualan in 'uDetailReturPenjualan.pas' {fDetailReturPenjualan},
  u_bayarPenjualan in 'u_bayarPenjualan.pas' {fBayarPenjualan},
  u_labaPenjualan in 'u_labaPenjualan.pas' {fLabaPenjualan},
  u_dashboardPembelian in 'u_dashboardPembelian.pas' {fDashboardPembelian},
  u_dashboardPenjualan in 'u_dashboardPenjualan.pas' {fDashboardPenjualan},
  u_dashboardSupplier in 'u_dashboardSupplier.pas' {fDashboardSupplier},
  u_dashboardObat in 'u_dashboardObat.pas' {fDashboardObat},
  u_dashboardObatStok in 'u_dashboardObatStok.pas' {fDashboardObatStok},
  u_dashboardExp in 'u_dashboardExp.pas' {fDashboardExp},
  u_dashboardReturPenjualan in 'u_dashboardReturPenjualan.pas' {fDashboardReturPenjualan},
  u_returPembelian in 'u_returPembelian.pas' {fReturPembelian},
  u_returAllPembelian in 'u_returAllPembelian.pas' {fReturAllPembelian},
  u_listReturPembelian in 'u_listReturPembelian.pas' {fListReturPembelian},
  u_detailReturPembelian in 'u_detailReturPembelian.pas' {fDetailReturPembelian},
  u_dashboardReturPembelian in 'u_dashboardReturPembelian.pas' {fDashboardListPembelian},
  u_laporanRetur in 'u_laporanRetur.pas' {fLaporanRetur},
  uBackup in 'uBackup.pas' {fbackup};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFMenu, FMenu);
  Application.Run;
end.
