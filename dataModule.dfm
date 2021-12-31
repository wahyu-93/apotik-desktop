object dm: Tdm
  OldCreateOrder = False
  Left = 192
  Top = 125
  Height = 506
  Width = 527
  object XPManifest1: TXPManifest
    Left = 128
    Top = 32
  end
  object con1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=apoti' +
      'k;Initial Catalog=db_apotik'
    LoginPrompt = False
    Left = 72
    Top = 32
  end
  object qryBarang: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_barang')
    Left = 40
    Top = 88
  end
  object dsBarang: TDataSource
    DataSet = qryBarang
    Left = 104
    Top = 88
  end
  object dsJenis: TDataSource
    DataSet = qryJenis
    Left = 96
    Top = 160
  end
  object qryJenis: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_jenis')
    Left = 48
    Top = 168
    object qryJenisid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qryJeniskode: TStringField
      FieldName = 'kode'
    end
    object qryJenisjenis: TStringField
      FieldName = 'jenis'
      Size = 100
    end
    object qryJenisketerangan: TMemoField
      FieldName = 'keterangan'
      OnGetText = qryJenisketeranganGetText
      BlobType = ftMemo
    end
  end
  object dsSatuan: TDataSource
    DataSet = qrySatuan
    Left = 112
    Top = 224
  end
  object qrySatuan: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_satuan')
    Left = 64
    Top = 240
    object qrySatuanid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qrySatuankode: TStringField
      FieldName = 'kode'
    end
    object qrySatuansatuan: TStringField
      FieldName = 'satuan'
      Size = 100
    end
  end
  object qrySupplier: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_supplier')
    Left = 56
    Top = 296
    object qrySupplierid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qrySupplierkode: TStringField
      FieldName = 'kode'
    end
    object qrySuppliernama_supplier: TStringField
      FieldName = 'nama_supplier'
      Size = 100
    end
    object qrySupplieralamat_supplier: TMemoField
      FieldName = 'alamat_supplier'
      OnGetText = qrySupplieralamat_supplierGetText
      BlobType = ftMemo
    end
    object qrySuppliertelp_suplier: TStringField
      FieldName = 'telp_suplier'
      Size = 15
    end
  end
  object dsSupplier: TDataSource
    DataSet = qrySupplier
    Left = 104
    Top = 288
  end
  object qryObat: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_obat')
    Left = 64
    Top = 360
  end
  object dsObat: TDataSource
    DataSet = qryObatRelasi
    Left = 120
    Top = 352
  end
  object qryObatRelasi: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_' +
        'jenis, b.kode_satuan, a.id as id_jenis, a.kode as jenisKode, a.j' +
        'enis, c.id as id_satuan, c.kode as satuanKode, c.satuan from tbl' +
        '_jenis a left join tbl_obat b on a.id = b.kode_jenis INNER join ' +
        'tbl_satuan c on c.id = b.kode_satuan order by b.id;')
    Left = 56
    Top = 416
  end
end
