object fPembelian: TfPembelian
  Left = 283
  Top = 151
  Width = 1432
  Height = 766
  Caption = '.:: Form Pembelian ::.'
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
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
      Left = 1080
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
      Left = 792
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
      Left = 792
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
      KeyField = 'id'
      ListField = 'nama_supplier'
      ListSource = dm.dsSupplier
      ParentFont = False
      TabOrder = 2
    end
    object edtKode: TEdit
      Left = 8
      Top = 96
      Width = 313
      Height = 25
      Enabled = False
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
      Caption = 'F2'
      TabOrder = 4
      OnClick = btnBantuObatClick
    end
    object edtNama: TEdit
      Left = 376
      Top = 96
      Width = 409
      Height = 25
      Enabled = False
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
      Left = 792
      Top = 96
      Width = 281
      Height = 25
      Enabled = False
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
      Left = 1080
      Top = 96
      Width = 313
      Height = 25
      Enabled = False
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
      OnKeyPress = edtHargaKeyPress
    end
    object edtJumlahBeli: TEdit
      Left = 792
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
      OnKeyPress = edtJumlahBeliKeyPress
    end
    object btnSimpan: TBitBtn
      Left = 1104
      Top = 144
      Width = 89
      Height = 33
      Caption = 'Simpan'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      OnClick = btnSimpanClick
    end
    object btnHapus: TBitBtn
      Left = 1200
      Top = 144
      Width = 89
      Height = 33
      Caption = 'Hapus[F6]'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
      OnClick = btnHapusClick
    end
    object btnSelesai: TBitBtn
      Left = 1296
      Top = 144
      Width = 89
      Height = 33
      Caption = 'Selesai[F5]'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
      OnClick = btnSelesaiClick
    end
    object edtIdObat: TEdit
      Left = 168
      Top = 72
      Width = 121
      Height = 21
      TabOrder = 14
      Text = 'edtIdObat'
      Visible = False
    end
    object edtIdPembelian: TEdit
      Left = 128
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 15
      Text = 'edtIdPembelian'
      Visible = False
    end
  end
  object grp2: TGroupBox
    Left = 8
    Top = 208
    Width = 1401
    Height = 513
    TabOrder = 1
    object bvl1: TBevel
      Left = 8
      Top = 464
      Width = 1385
      Height = 2
    end
    object dbgrd1: TDBGrid
      Left = 8
      Top = 16
      Width = 1385
      Height = 345
      DataSource = dm.dsRelasiPembelian
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = dbgrd1CellClick
      OnKeyPress = dbgrd1KeyPress
      Columns = <
        item
          Expanded = False
          FieldName = 'id_pembelian'
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
          FieldName = 'tgl_pembelian'
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
          FieldName = 'jumlah_item'
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
          FieldName = 'id_detail_pembelian'
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
          FieldName = 'jumlah_beli'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Caption = 'Jumlah Pembelian'
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
          FieldName = 'harga_beli'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = []
          ReadOnly = True
          Title.Alignment = taCenter
          Title.Caption = 'Harga Pembelian'
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
      Top = 472
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
      Top = 472
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
      object lblItem: TLabel
        Left = 8
        Top = 32
        Width = 78
        Height = 33
        Alignment = taCenter
        Caption = '999999'
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
      object lblTotalHarga: TLabel
        Left = 8
        Top = 32
        Width = 177
        Height = 33
        Alignment = taCenter
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
