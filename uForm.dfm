object FMenu: TFMenu
  Left = 240
  Top = 53
  Width = 1440
  Height = 900
  Caption = 'Kasir Apotik'
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
  object dbgrd1: TDBGrid
    Left = 48
    Top = 328
    Width = 320
    Height = 120
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object dbgrd2: TDBGrid
    Left = 56
    Top = 496
    Width = 320
    Height = 120
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object pnl1: TPanel
    Left = 104
    Top = 88
    Width = 185
    Height = 41
    Caption = 'pnl1'
    TabOrder = 2
  end
  object pnl2: TPanel
    Left = 368
    Top = 80
    Width = 185
    Height = 41
    Caption = 'pnl2'
    TabOrder = 3
  end
  object pnl3: TPanel
    Left = 656
    Top = 88
    Width = 185
    Height = 41
    Caption = 'pnl3'
    TabOrder = 4
  end
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
        OnClick = Obat1Click
      end
      object Supplier2: TMenuItem
        Caption = 'Supplier'
        OnClick = Supplier2Click
      end
    end
    object ransaksi1: TMenuItem
      Caption = 'Transaksi'
      object Pembelian1: TMenuItem
        Caption = 'Pembelian'
        OnClick = Pembelian1Click
      end
      object Penjualan1: TMenuItem
        Caption = 'Penjualan'
        OnClick = Penjualan1Click
      end
      object SettingHargaJual1: TMenuItem
        Caption = 'Set Harga Jual'
        OnClick = SettingHargaJual1Click
      end
      object ListPembelian1: TMenuItem
        Caption = 'List Pembelian'
        OnClick = ListPembelian1Click
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
