object Fobat: TFobat
  Left = 406
  Top = 209
  Width = 897
  Height = 664
  Caption = 'Fobat'
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object grp1: TGroupBox
    Left = 8
    Top = 8
    Width = 865
    Height = 57
    TabOrder = 0
    object lbl1: TLabel
      Left = 368
      Top = 16
      Width = 116
      Height = 27
      Caption = 'Form Obat'
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
    Width = 865
    Height = 545
    TabOrder = 1
    object lbl2: TLabel
      Left = 8
      Top = 16
      Width = 70
      Height = 17
      Caption = 'Kode Obat'
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
    object lbl4: TLabel
      Left = 8
      Top = 80
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
      Left = 8
      Top = 112
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
    object lbl6: TLabel
      Left = 8
      Top = 144
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
    object edtKode: TEdit
      Left = 104
      Top = 16
      Width = 185
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
    object edtBarcode: TEdit
      Left = 104
      Top = 48
      Width = 377
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'edtKode'
    end
    object dbgrd1: TDBGrid
      Left = 16
      Top = 176
      Width = 841
      Height = 281
      DataSource = dm.dsObat
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = dbgrd1CellClick
      Columns = <
        item
          Expanded = False
          FieldName = 'id'
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
          FieldName = 'kodeObat'
          Title.Alignment = taCenter
          Title.Caption = 'kode Obat'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 76
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'barcode'
          Title.Alignment = taCenter
          Title.Caption = 'Barcode'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 165
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'nama_obat'
          Title.Alignment = taCenter
          Title.Caption = 'Nama Obat'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 135
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'kode_jenis'
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
          FieldName = 'kode_satuan'
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
          FieldName = 'id_jenis'
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
          FieldName = 'jenisKode'
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
          FieldName = 'jenis'
          Title.Alignment = taCenter
          Title.Caption = 'Jenis Obat'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 165
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'id_satuan'
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
          FieldName = 'satuanKode'
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
          FieldName = 'satuan'
          Title.Alignment = taCenter
          Title.Caption = 'Satuan Obat'
          Title.Font.Charset = ANSI_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 179
          Visible = True
        end>
    end
    object edtpencarian: TEdit
      Left = 8
      Top = 464
      Width = 849
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'edtKode'
      OnKeyUp = edtpencarianKeyUp
    end
    object btnTambah: TBitBtn
      Left = 8
      Top = 504
      Width = 89
      Height = 33
      Caption = 'Tambah'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnTambahClick
    end
    object btnSimpan: TBitBtn
      Left = 104
      Top = 504
      Width = 89
      Height = 33
      Caption = 'Simpan'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = btnSimpanClick
    end
    object btnHapus: TBitBtn
      Left = 200
      Top = 504
      Width = 89
      Height = 33
      Caption = 'Hapus'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = btnHapusClick
    end
    object btnKeluar: TBitBtn
      Left = 760
      Top = 504
      Width = 89
      Height = 33
      Caption = 'Keluar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = btnKeluarClick
    end
    object edtNama: TEdit
      Left = 104
      Top = 80
      Width = 745
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      Text = 'edtKode'
    end
    object dblkcbbJenisObat: TDBLookupComboBox
      Left = 104
      Top = 112
      Width = 297
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      KeyField = 'id'
      ListField = 'jenis'
      ListSource = dm.dsJenis
      ParentFont = False
      TabOrder = 9
    end
    object dblkcbbSatuanObat: TDBLookupComboBox
      Left = 104
      Top = 144
      Width = 161
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      KeyField = 'id'
      ListField = 'satuan'
      ListSource = dm.dsSatuan
      ParentFont = False
      TabOrder = 10
    end
  end
end
