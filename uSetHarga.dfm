object fSetHarga: TfSetHarga
  Left = 267
  Top = 222
  Width = 701
  Height = 740
  Caption = '.:: Set Harga Jual ::.'
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grp1: TGroupBox
    Left = 8
    Top = 8
    Width = 673
    Height = 57
    TabOrder = 0
    object lbl1: TLabel
      Left = 224
      Top = 16
      Width = 223
      Height = 27
      Caption = 'Form Set Harga Jual'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object grp2: TGroupBox
    Left = 8
    Top = 72
    Width = 673
    Height = 625
    TabOrder = 1
    object lbl2: TLabel
      Left = 8
      Top = 16
      Width = 55
      Height = 17
      Caption = 'Barcode'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl3: TLabel
      Left = 8
      Top = 48
      Width = 75
      Height = 17
      Caption = 'Nama Obat'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl4: TLabel
      Left = 8
      Top = 80
      Width = 34
      Height = 17
      Caption = 'Jenis'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl5: TLabel
      Left = 8
      Top = 112
      Width = 46
      Height = 17
      Caption = 'Satuan'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl6: TLabel
      Left = 96
      Top = 48
      Width = 4
      Height = 17
      Caption = ':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl7: TLabel
      Left = 96
      Top = 80
      Width = 4
      Height = 17
      Caption = ':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl8: TLabel
      Left = 96
      Top = 112
      Width = 4
      Height = 17
      Caption = ':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblNamaObat: TLabel
      Left = 104
      Top = 48
      Width = 67
      Height = 20
      Caption = 'Nama Obat'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object lblJenis: TLabel
      Left = 104
      Top = 80
      Width = 32
      Height = 20
      Caption = 'Jenis'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object lblSatuan: TLabel
      Left = 104
      Top = 112
      Width = 42
      Height = 20
      Caption = 'Satuan'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object lbl21: TLabel
      Left = 8
      Top = 144
      Width = 122
      Height = 17
      Caption = 'Harga Beli Terakhir'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblHargaBeli: TLabel
      Left = 8
      Top = 168
      Width = 68
      Height = 20
      Caption = 'Rp. 200.000'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object lblSupplier: TLabel
      Left = 184
      Top = 168
      Width = 51
      Height = 20
      Caption = 'Supplier'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object lbl22: TLabel
      Left = 184
      Top = 144
      Width = 53
      Height = 17
      Caption = 'Supplier'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl23: TLabel
      Left = 8
      Top = 198
      Width = 102
      Height = 17
      Caption = 'Harga Jual (Rp)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edtKode: TEdit
      Left = 96
      Top = 16
      Width = 513
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'edtKode'
    end
    object dbgrd1: TDBGrid
      Left = 8
      Top = 232
      Width = 649
      Height = 313
      DataSource = dm.dsRelasiSetHarga
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object edtpencarian: TEdit
      Left = 8
      Top = 552
      Width = 649
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'edtKode'
    end
    object btnTambah: TBitBtn
      Left = 8
      Top = 584
      Width = 89
      Height = 33
      Caption = 'Tambah[F1]'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnTambahClick
    end
    object btnSimpan: TBitBtn
      Left = 104
      Top = 584
      Width = 89
      Height = 33
      Caption = 'Simpan'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnSimpanClick
    end
    object btnHapus: TBitBtn
      Left = 200
      Top = 584
      Width = 89
      Height = 33
      Caption = 'Hapus'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object btnKeluar: TBitBtn
      Left = 568
      Top = 584
      Width = 89
      Height = 33
      Caption = 'Keluar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = btnKeluarClick
    end
    object btnBantuObat: TBitBtn
      Left = 616
      Top = 16
      Width = 41
      Height = 25
      Caption = 'F2'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = btnBantuObatClick
    end
    object edtHarga: TEdit
      Left = 120
      Top = 194
      Width = 385
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      Text = 'edtKode'
      OnKeyPress = edtHargaKeyPress
    end
    object edtIdObat: TEdit
      Left = 488
      Top = 48
      Width = 121
      Height = 21
      TabOrder = 9
      Text = 'edtIdObat'
      Visible = False
    end
  end
end
