object Fpenjualan: TFpenjualan
  Left = 241
  Top = 133
  Width = 1432
  Height = 768
  Caption = 'Fpenjualan'
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
  object grp2: TGroupBox
    Left = 8
    Top = 144
    Width = 1401
    Height = 577
    TabOrder = 0
    object bvl1: TBevel
      Left = 8
      Top = 528
      Width = 1385
      Height = 2
    end
    object dbgrd1: TDBGrid
      Left = 8
      Top = 16
      Width = 1385
      Height = 505
      DataSource = dm.dsRelasiPenjualan
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = dbgrd1DblClick
      OnKeyPress = dbgrd1KeyPress
      Columns = <
        item
          Expanded = False
          FieldName = 'id_penjualan'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'no_faktur'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'tgl_penjualan'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'jumlah_jual'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'total'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'id_detail_penjualan'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'obat_id'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'kode'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'barcode'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'tgl_obat'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'tgl_exp'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'nama_obat'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          ReadOnly = True
          Title.Alignment = taCenter
          Title.Caption = 'Nama Obat'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 619
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'jenis'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          ReadOnly = True
          Title.Alignment = taCenter
          Title.Caption = 'Jenis Obat'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 212
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'satuan'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          ReadOnly = True
          Title.Alignment = taCenter
          Title.Caption = 'Satuan'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 240
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'jumlah_jual'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Caption = 'Jumlah'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 122
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'harga_jual'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          ReadOnly = True
          Title.Alignment = taCenter
          Title.Caption = 'Harga'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 152
          Visible = True
        end>
    end
    object btnTambah: TBitBtn
      Left = 8
      Top = 536
      Width = 121
      Height = 33
      Caption = 'Tambah[F1]'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnTambahClick
    end
    object btnKeluar: TBitBtn
      Left = 1288
      Top = 536
      Width = 105
      Height = 33
      Caption = 'Keluar [F10]'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnKeluarClick
    end
  end
  object grp1: TGroupBox
    Left = 8
    Top = 8
    Width = 1401
    Height = 129
    TabOrder = 1
    object lbl6: TLabel
      Left = 376
      Top = 16
      Width = 118
      Height = 17
      Caption = 'Tanggal Penjualan'
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
      Width = 109
      Height = 17
      Caption = 'Faktur Penjualan'
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
    object lbl2: TLabel
      Left = 536
      Top = 16
      Width = 69
      Height = 17
      Caption = 'Pelanggan'
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
      Width = 153
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
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'edtFaktur'
    end
    object edtKode: TEdit
      Left = 8
      Top = 96
      Width = 361
      Height = 25
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'edtFaktur'
      OnKeyPress = edtKodeKeyPress
    end
    object btnBantuObat: TBitBtn
      Left = 376
      Top = 96
      Width = 41
      Height = 25
      Caption = 'F2'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnBantuObatClick
    end
    object btnSimpan: TBitBtn
      Left = 480
      Top = 88
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
      Visible = False
      OnClick = btnSimpanClick
    end
    object btnHapus: TBitBtn
      Left = 576
      Top = 88
      Width = 89
      Height = 33
      Caption = 'Hapus[F6]'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = btnHapusClick
    end
    object btnSelesai: TBitBtn
      Left = 672
      Top = 88
      Width = 89
      Height = 33
      Caption = 'Selesai[F5]'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object edtIdObat: TEdit
      Left = 168
      Top = 72
      Width = 57
      Height = 21
      TabOrder = 7
      Text = 'edtIdObat'
      Visible = False
    end
    object edtIdPembelian: TEdit
      Left = 128
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 8
      Text = 'edtIdPembelian'
      Visible = False
    end
    object grp3: TGroupBox
      Left = 768
      Top = 24
      Width = 113
      Height = 97
      Caption = 'Jumlah Item'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      object lblItem: TLabel
        Left = 8
        Top = 35
        Width = 96
        Height = 42
        Alignment = taCenter
        Caption = '999999'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -35
        Font.Name = 'Arial Narrow'
        Font.Style = [fsItalic]
        ParentFont = False
        WordWrap = True
      end
    end
    object grp4: TGroupBox
      Left = 896
      Top = 24
      Width = 489
      Height = 97
      Caption = 'Total Harga'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      object lblTotalHarga: TLabel
        Left = 48
        Top = 16
        Width = 388
        Height = 75
        Alignment = taCenter
        Caption = 'Rp. 200.000.000'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -64
        Font.Name = 'Arial Narrow'
        Font.Style = [fsItalic]
        ParentFont = False
      end
    end
    object dblkcbbPelanggan: TDBLookupComboBox
      Left = 536
      Top = 40
      Width = 201
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      KeyField = 'id'
      ListField = 'jenis_pelanggan'
      ListSource = dm.dsPelanggan
      ParentFont = False
      TabOrder = 11
    end
    object edtHarga: TEdit
      Left = 232
      Top = 72
      Width = 57
      Height = 21
      TabOrder = 12
      Text = 'edtHarga'
      Visible = False
    end
  end
end
