object fPembayaranPembelian: TfPembayaranPembelian
  Left = 383
  Top = 428
  Width = 1082
  Height = 664
  Caption = 'FPembayaranPembelian'
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
    Width = 1049
    Height = 57
    TabOrder = 0
    object lbl1: TLabel
      Left = 352
      Top = 16
      Width = 281
      Height = 27
      Caption = 'Form List Pembelian Obat'
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
    Width = 1049
    Height = 545
    TabOrder = 1
    object dbgrd1: TDBGrid
      Left = 8
      Top = 16
      Width = 1033
      Height = 449
      DataSource = dm.dsListPembelian
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial Narrow'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'id'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'kode'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'nama_supplier'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'alamat_supplier'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'telp_suplier'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'id_1'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'no_faktur'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'tgl_pembelian'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'supplier_id'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'jumlah_item'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'total'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'user_id'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'status'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'id_2'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'nama'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'username'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'password'
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'role'
          Visible = False
        end>
    end
    object edtpencarian: TEdit
      Left = 8
      Top = 472
      Width = 1033
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
    object btnPilih: TBitBtn
      Left = 856
      Top = 504
      Width = 89
      Height = 33
      Caption = 'Pilih'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object btnKeluar: TBitBtn
      Left = 952
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
      TabOrder = 3
    end
  end
end
