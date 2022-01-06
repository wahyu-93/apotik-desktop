object fBayar: TfBayar
  Left = 345
  Top = 228
  AutoScroll = False
  BorderIcons = []
  Caption = 'fBayar'
  ClientHeight = 512
  ClientWidth = 598
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grp1: TGroupBox
    Left = 8
    Top = 8
    Width = 585
    Height = 57
    TabOrder = 0
    object lbl1: TLabel
      Left = 224
      Top = 16
      Width = 125
      Height = 27
      Caption = 'Form Bayar'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edtTtlBayar: TEdit
      Left = 16
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'edtTtlBayar'
    end
    object edtByar: TEdit
      Left = 152
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'edtByar'
    end
    object edtKmbalian: TEdit
      Left = 376
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'edtKmbalian'
    end
  end
  object grp2: TGroupBox
    Left = 8
    Top = 72
    Width = 585
    Height = 433
    TabOrder = 1
    object lbl4: TLabel
      Left = 24
      Top = 16
      Width = 152
      Height = 24
      Caption = 'Total Bayar (Rp)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl2: TLabel
      Left = 24
      Top = 144
      Width = 102
      Height = 24
      Caption = 'Bayar (Rp)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbl3: TLabel
      Left = 24
      Top = 272
      Width = 143
      Height = 24
      Caption = 'Kembalian (Rp)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edtTotalBayar: TEdit
      Left = 24
      Top = 48
      Width = 545
      Height = 83
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -64
      Font.Name = 'Arial Narrow'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 0
      Text = 'edtTotalBayar'
    end
    object btnKeluar: TBitBtn
      Left = 480
      Top = 392
      Width = 89
      Height = 33
      Caption = 'Keluar[F10]'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnKeluarClick
    end
    object edtBayar: TEdit
      Left = 24
      Top = 176
      Width = 545
      Height = 83
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -64
      Font.Name = 'Arial Narrow'
      Font.Style = [fsItalic]
      MaxLength = 8
      ParentFont = False
      TabOrder = 2
      Text = 'edtKode'
      OnKeyPress = edtBayarKeyPress
      OnKeyUp = edtBayarKeyUp
    end
    object edtKembalian: TEdit
      Left = 24
      Top = 304
      Width = 545
      Height = 83
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -64
      Font.Name = 'Arial Narrow'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 3
      Text = 'edtKode'
    end
    object btnBayar: TBitBtn
      Left = 384
      Top = 392
      Width = 89
      Height = 33
      Caption = 'Bayar[F9]'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnBayarClick
    end
  end
end
