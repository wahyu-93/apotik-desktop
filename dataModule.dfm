object dm: Tdm
  OldCreateOrder = False
  Left = 548
  Top = 249
  Height = 537
  Width = 710
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
    object qryObatid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qryObatkode: TStringField
      FieldName = 'kode'
      Size = 30
    end
    object qryObatbarcode: TStringField
      FieldName = 'barcode'
      Size = 100
    end
    object qryObatnama_obat: TStringField
      FieldName = 'nama_obat'
      Size = 150
    end
    object qryObatkode_jenis: TIntegerField
      FieldName = 'kode_jenis'
    end
    object qryObatkode_satuan: TIntegerField
      FieldName = 'kode_satuan'
    end
    object qryObattgl_obat: TDateField
      FieldName = 'tgl_obat'
    end
    object qryObattgl_exp: TDateField
      FieldName = 'tgl_exp'
    end
    object qryObatstatus: TStringField
      FieldName = 'status'
      Size = 100
    end
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
    object qryObatRelasiid: TIntegerField
      FieldName = 'id'
    end
    object qryObatRelasikodeObat: TStringField
      FieldName = 'kodeObat'
      Size = 30
    end
    object qryObatRelasibarcode: TStringField
      FieldName = 'barcode'
      Size = 100
    end
    object qryObatRelasinama_obat: TStringField
      FieldName = 'nama_obat'
      Size = 150
    end
    object qryObatRelasikode_jenis: TIntegerField
      FieldName = 'kode_jenis'
    end
    object qryObatRelasikode_satuan: TIntegerField
      FieldName = 'kode_satuan'
    end
    object qryObatRelasiid_jenis: TIntegerField
      FieldName = 'id_jenis'
    end
    object qryObatRelasijenisKode: TStringField
      FieldName = 'jenisKode'
    end
    object qryObatRelasijenis: TStringField
      FieldName = 'jenis'
      Size = 100
    end
    object qryObatRelasiid_satuan: TIntegerField
      FieldName = 'id_satuan'
    end
    object qryObatRelasisatuanKode: TStringField
      FieldName = 'satuanKode'
    end
    object qryObatRelasisatuan: TStringField
      FieldName = 'satuan'
      Size = 100
    end
  end
  object qryPembelian: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_pembelian')
    Left = 264
    Top = 96
  end
  object qryDetailPembelian: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_detail_pembelian')
    Left = 352
    Top = 104
  end
  object qryRelasiPembelian: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.id as id_pembelian, a.no_faktur, a.tgl_pembelian, a.jum' +
        'lah_item, a.total, b.id as id_detail_pembelian, b.obat_id, b.jum' +
        'lah_beli, b.harga_beli, c.kode, c.barcode, c.nama_obat, c.tgl_ob' +
        'at, c.tgl_exp, d.jenis, e.satuan from tbl_pembelian a left join ' +
        'tbl_detail_pembelian b on b.pembelian_id = a.id left join tbl_ob' +
        'at c on c.id = b.obat_id left join tbl_jenis d on d.id=c.kode_je' +
        'nis left join tbl_satuan e on e.id = c.kode_satuan '#10)
    Left = 264
    Top = 144
    object qryRelasiPembelianid_pembelian: TAutoIncField
      FieldName = 'id_pembelian'
      ReadOnly = True
    end
    object qryRelasiPembelianno_faktur: TStringField
      FieldName = 'no_faktur'
      Size = 50
    end
    object qryRelasiPembeliantgl_pembelian: TDateField
      FieldName = 'tgl_pembelian'
    end
    object qryRelasiPembelianjumlah_item: TIntegerField
      FieldName = 'jumlah_item'
    end
    object qryRelasiPembeliantotal: TFloatField
      FieldName = 'total'
    end
    object qryRelasiPembelianid_detail_pembelian: TAutoIncField
      FieldName = 'id_detail_pembelian'
      ReadOnly = True
    end
    object qryRelasiPembelianobat_id: TIntegerField
      FieldName = 'obat_id'
    end
    object qryRelasiPembelianjumlah_beli: TIntegerField
      FieldName = 'jumlah_beli'
      DisplayFormat = '#,#0;(#,#0);#,#0'
    end
    object qryRelasiPembelianharga_beli: TFloatField
      FieldName = 'harga_beli'
      DisplayFormat = '#,#0;(#,#0);#,#0'
    end
    object qryRelasiPembeliankode: TStringField
      FieldName = 'kode'
      Size = 30
    end
    object qryRelasiPembelianbarcode: TStringField
      FieldName = 'barcode'
      Size = 100
    end
    object qryRelasiPembeliannama_obat: TStringField
      FieldName = 'nama_obat'
      Size = 150
    end
    object qryRelasiPembeliantgl_obat: TDateField
      FieldName = 'tgl_obat'
    end
    object qryRelasiPembeliantgl_exp: TDateField
      FieldName = 'tgl_exp'
    end
    object qryRelasiPembelianjenis: TStringField
      FieldName = 'jenis'
      Size = 100
    end
    object qryRelasiPembeliansatuan: TStringField
      FieldName = 'satuan'
      Size = 100
    end
  end
  object dsRelasiPembelian: TDataSource
    DataSet = qryRelasiPembelian
    Left = 352
    Top = 160
  end
  object qryListPembelian: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select * from tbl_supplier left join tbl_pembelian on tbl_pembel' +
        'ian.supplier_id = tbl_supplier.id inner join tbl_user on tbl_use' +
        'r.id = tbl_pembelian.user_id order by tbl_pembelian.id desc;')
    Left = 264
    Top = 248
  end
  object dsListPembelian: TDataSource
    DataSet = qryListPembelian
    Left = 328
    Top = 240
  end
end
