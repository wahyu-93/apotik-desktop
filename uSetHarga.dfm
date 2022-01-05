object fSetHarga: TfSetHarga
  Left = 403
  Top = 134
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
      Top = 72
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
      Top = 96
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
      Top = 72
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
      Top = 96
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
      Top = 72
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
      Top = 96
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
      Top = 120
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
      Top = 144
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
      Top = 144
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
      Top = 120
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
      Top = 222
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
    object lbl9: TLabel
      Left = 8
      Top = 184
      Width = 115
      Height = 17
      Caption = 'Tanggal Exp Obat'
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
      Top = 248
      Width = 649
      Height = 297
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
      OnDblClick = dbgrd1DblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'id'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'barcode'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Caption = 'Barcode'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'obat_id'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'nama_obat'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Caption = 'Nama Obat'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'harga_jual'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Caption = 'Harga Jual'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'harga_beli_terakhir'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Caption = 'Harga Beli'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'supplier'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Caption = 'Supplier'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'tgl_exp'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Caption = 'Tanggal Exp'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'stok'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Caption = 'Stok'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'created_at'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'id_1'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'kode'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'kode_jenis'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'kode_satuan'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'tgl_obat'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'status'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Title.Alignment = taCenter
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -16
          Title.Font.Name = 'Arial Narrow'
          Title.Font.Style = []
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'satuan'
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'jenis'
          Width = -1
          Visible = False
        end>
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
      OnKeyUp = edtpencarianKeyUp
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
      OnClick = btnHapusClick
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
      Left = 144
      Top = 218
      Width = 193
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
    object edtHargaBeli: TEdit
      Left = 488
      Top = 80
      Width = 121
      Height = 21
      TabOrder = 10
      Text = 'edtHargaBeli'
      Visible = False
    end
    object dtpTglExp: TDateTimePicker
      Left = 144
      Top = 184
      Width = 385
      Height = 25
      Date = 44565.491122905090000000
      Time = 44565.491122905090000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
    end
  end
end
