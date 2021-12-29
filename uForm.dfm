object FMenu: TFMenu
  Left = 259
  Top = 71
  Width = 1440
  Height = 900
  Caption = 'FMenu'
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object mm1: TMainMenu
    Left = 96
    Top = 64
    object Master1: TMenuItem
      Caption = 'Master'
      object Barang1: TMenuItem
        Caption = 'Jenis Obat'
        OnClick = Barang1Click
      end
      object Supplier1: TMenuItem
        Caption = 'Satuan Obat'
        OnClick = Supplier1Click
      end
      object Obat1: TMenuItem
        Caption = 'Obat'
      end
      object Supplier2: TMenuItem
        Caption = 'Supplier'
      end
    end
    object ransaksi1: TMenuItem
      Caption = 'Transaksi'
      object Pembelian1: TMenuItem
        Caption = 'Pembelian'
      end
      object Penjualan1: TMenuItem
        Caption = 'Penjualan'
      end
    end
    object Laporan1: TMenuItem
      Caption = 'Laporan'
    end
    object Setting1: TMenuItem
      Caption = 'Setting'
    end
    object Keluar1: TMenuItem
      Caption = 'Keluar'
      OnClick = Keluar1Click
    end
  end
end
