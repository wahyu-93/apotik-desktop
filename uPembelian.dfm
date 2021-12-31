object fPembelian: TfPembelian
  Left = 247
  Top = 191
  Width = 1432
  Height = 792
  Caption = 'fPembelian'
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object grp1: TGroupBox
    Left = 8
    Top = 8
    Width = 1401
    Height = 193
    TabOrder = 0
    object lbl6: TLabel
      Left = 376
      Top = 16
      Width = 123
      Height = 17
      Caption = 'Tanggal Pembelian'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl1: TLabel
      Left = 8
      Top = 16
      Width = 114
      Height = 17
      Caption = 'Faktur Pembelian'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl2: TLabel
      Left = 792
      Top = 16
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
    object lbl3: TLabel
      Left = 8
      Top = 72
      Width = 152
      Height = 17
      Caption = 'Kode / Barcode Barang'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl4: TLabel
      Left = 376
      Top = 72
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
    object lbl5: TLabel
      Left = 1088
      Top = 72
      Width = 70
      Height = 17
      Caption = 'Jenis Obat'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl7: TLabel
      Left = 800
      Top = 72
      Width = 82
      Height = 17
      Caption = 'Satuan Obat'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl8: TLabel
      Left = 8
      Top = 128
      Width = 128
      Height = 17
      Caption = 'Tanggal Kadaluarsa'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl9: TLabel
      Left = 376
      Top = 128
      Width = 145
      Height = 17
      Caption = 'Harga Pembelian (Rp)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl10: TLabel
      Left = 800
      Top = 128
      Width = 120
      Height = 17
      Caption = 'Jumlah Pembelian'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object dtpTanggalBeli: TDateTimePicker
      Left = 376
      Top = 40
      Width = 409
      Height = 25
      Date = 44561.580060370370000000
      Time = 44561.580060370370000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edtFaktur: TEdit
      Left = 8
      Top = 40
      Width = 361
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'edtFaktur'
    end
    object dblkcbbSupplier: TDBLookupComboBox
      Left = 792
      Top = 40
      Width = 601
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object edtKode: TEdit
      Left = 8
      Top = 96
      Width = 313
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'edtFaktur'
    end
    object btnBantuObat: TBitBtn
      Left = 328
      Top = 96
      Width = 41
      Height = 25
      Caption = '...'
      TabOrder = 4
    end
    object edtNama: TEdit
      Left = 376
      Top = 96
      Width = 409
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = 'edtFaktur'
    end
    object edtSatuan: TEdit
      Left = 800
      Top = 96
      Width = 281
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Text = 'edtFaktur'
    end
    object edtJenis: TEdit
      Left = 1088
      Top = 96
      Width = 305
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Text = 'edtFaktur'
    end
    object dtpTanggalKadaluarsa: TDateTimePicker
      Left = 8
      Top = 152
      Width = 361
      Height = 25
      Date = 44561.580060370370000000
      Time = 44561.580060370370000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object edtHarga: TEdit
      Left = 376
      Top = 152
      Width = 409
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      Text = 'edtFaktur'
    end
    object edtJumlahBeli: TEdit
      Left = 800
      Top = 152
      Width = 281
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      Text = 'edtFaktur'
    end
    object btnTambah: TBitBtn
      Left = 1104
      Top = 144
      Width = 89
      Height = 33
      Caption = 'Tambah'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
    end
    object btn1: TBitBtn
      Left = 1200
      Top = 144
      Width = 89
      Height = 33
      Caption = 'Tambah'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
    end
    object btn3: TBitBtn
      Left = 1296
      Top = 144
      Width = 89
      Height = 33
      Caption = 'Tambah'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
    end
  end
  object grp2: TGroupBox
    Left = 8
    Top = 208
    Width = 1401
    Height = 537
    TabOrder = 1
    object bvl1: TBevel
      Left = 8
      Top = 472
      Width = 1385
      Height = 2
    end
    object dbgrd1: TDBGrid
      Left = 8
      Top = 16
      Width = 1385
      Height = 345
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object btn2: TBitBtn
      Left = 8
      Top = 488
      Width = 89
      Height = 33
      Caption = 'Tambah'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object btn4: TBitBtn
      Left = 1304
      Top = 488
      Width = 89
      Height = 33
      Caption = 'Tambah'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object grp3: TGroupBox
      Left = 1032
      Top = 368
      Width = 113
      Height = 89
      Caption = 'Jumlah Item'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      object lbl11: TLabel
        Left = 24
        Top = 32
        Width = 52
        Height = 33
        Caption = '9999'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -29
        Font.Name = 'Arial Narrow'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object grp4: TGroupBox
      Left = 1160
      Top = 368
      Width = 233
      Height = 89
      Caption = 'Total Harga'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      object lbl12: TLabel
        Left = 16
        Top = 32
        Width = 177
        Height = 33
        Caption = 'Rp. 200.000.000'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -29
        Font.Name = 'Arial Narrow'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
end
