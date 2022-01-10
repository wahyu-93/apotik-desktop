object dm: Tdm
  OldCreateOrder = False
  Left = 369
  Top = 329
  Height = 456
  Width = 1222
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
  object dsJenis: TDataSource
    DataSet = qryJenis
    Left = 104
    Top = 80
  end
  object qryJenis: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_jenis')
    Left = 56
    Top = 88
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
    Left = 120
    Top = 144
  end
  object qrySatuan: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_satuan')
    Left = 72
    Top = 160
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
    Left = 64
    Top = 216
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
    Left = 112
    Top = 208
  end
  object qryObat: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_obat')
    Left = 72
    Top = 280
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
    object qryObatstok: TIntegerField
      FieldName = 'stok'
    end
  end
  object dsObat: TDataSource
    DataSet = qryObatRelasi
    Left = 128
    Top = 272
  end
  object qryObatRelasi: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_' +
        'jenis, b.kode_satuan, b.stok, a.id as id_jenis, a.kode as jenisK' +
        'ode, a.jenis, c.id as id_satuan, c.kode as satuanKode, c.satuan ' +
        'from tbl_jenis a left join tbl_obat b on a.id = b.kode_jenis INN' +
        'ER join tbl_satuan c on c.id = b.kode_satuan order by b.id;')
    Left = 64
    Top = 336
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
    object qryObatRelasistok: TIntegerField
      FieldName = 'stok'
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
    Left = 256
    Top = 232
    object qryListPembelianid: TIntegerField
      FieldName = 'id'
    end
    object qryListPembeliankode: TStringField
      FieldName = 'kode'
    end
    object qryListPembeliannama_supplier: TStringField
      FieldName = 'nama_supplier'
      Size = 100
    end
    object qryListPembelianalamat_supplier: TMemoField
      FieldName = 'alamat_supplier'
      BlobType = ftMemo
    end
    object qryListPembeliantelp_suplier: TStringField
      FieldName = 'telp_suplier'
      Size = 15
    end
    object qryListPembelianid_1: TIntegerField
      FieldName = 'id_1'
    end
    object qryListPembelianno_faktur: TStringField
      FieldName = 'no_faktur'
      Size = 50
    end
    object qryListPembeliantgl_pembelian: TDateField
      FieldName = 'tgl_pembelian'
    end
    object qryListPembeliansupplier_id: TIntegerField
      FieldName = 'supplier_id'
    end
    object qryListPembelianjumlah_item: TIntegerField
      FieldName = 'jumlah_item'
      DisplayFormat = '#,#0;(#,#0);#,#0'
    end
    object qryListPembeliantotal: TFloatField
      FieldName = 'total'
      DisplayFormat = '#,#0;(#,#0);#,#0'
    end
    object qryListPembelianuser_id: TIntegerField
      FieldName = 'user_id'
    end
    object qryListPembelianstatus: TStringField
      FieldName = 'status'
      Size = 25
    end
    object qryListPembeliantgl_pembayaran: TDateField
      FieldName = 'tgl_pembayaran'
    end
    object qryListPembelianid_2: TIntegerField
      FieldName = 'id_2'
    end
    object qryListPembeliannama: TStringField
      FieldName = 'nama'
      Size = 50
    end
    object qryListPembelianusername: TStringField
      FieldName = 'username'
      Size = 25
    end
    object qryListPembelianpassword: TStringField
      FieldName = 'password'
      Size = 25
    end
    object qryListPembelianrole: TStringField
      FieldName = 'role'
      Size = 50
    end
  end
  object dsListPembelian: TDataSource
    DataSet = qryListPembelian
    Left = 328
    Top = 248
  end
  object qryPenjualan: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_penjualan')
    Left = 488
    Top = 120
  end
  object qryStok: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_stok')
    Left = 248
    Top = 320
    object qryStokid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qryStokno_faktur: TStringField
      FieldName = 'no_faktur'
      Size = 50
    end
    object qryStokobat_id: TIntegerField
      FieldName = 'obat_id'
    end
    object qryStokjumlah: TIntegerField
      FieldName = 'jumlah'
    end
    object qryStokharga: TFloatField
      FieldName = 'harga'
    end
    object qryStokketerangan: TStringField
      FieldName = 'keterangan'
      Size = 25
    end
    object qryStokcreated_at: TDateTimeField
      FieldName = 'created_at'
    end
  end
  object qrySetHarga: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_harga_jual')
    Left = 488
    Top = 192
  end
  object qryRelasiSetHarga: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id' +
        ' = b.id;')
    Left = 488
    Top = 248
    object qryRelasiSetHargaid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qryRelasiSetHargaobat_id: TIntegerField
      FieldName = 'obat_id'
    end
    object qryRelasiSetHargaharga_jual: TFloatField
      FieldName = 'harga_jual'
      DisplayFormat = '#,#0;(#,#0);#,#0'
    end
    object qryRelasiSetHargaharga_beli_terakhir: TIntegerField
      FieldName = 'harga_beli_terakhir'
      DisplayFormat = '#,#0;(#,#0);#,#0'
    end
    object qryRelasiSetHargasupplier: TStringField
      FieldName = 'supplier'
      Size = 50
    end
    object qryRelasiSetHargasatuan: TStringField
      FieldName = 'satuan'
      Size = 100
    end
    object qryRelasiSetHargajenis: TStringField
      FieldName = 'jenis'
      Size = 100
    end
    object qryRelasiSetHargacreated_at: TDateTimeField
      FieldName = 'created_at'
    end
    object qryRelasiSetHargaid_1: TAutoIncField
      FieldName = 'id_1'
      ReadOnly = True
    end
    object qryRelasiSetHargakode: TStringField
      FieldName = 'kode'
      Size = 30
    end
    object qryRelasiSetHargabarcode: TStringField
      FieldName = 'barcode'
      Size = 100
    end
    object qryRelasiSetHarganama_obat: TStringField
      FieldName = 'nama_obat'
      Size = 150
    end
    object qryRelasiSetHargakode_jenis: TIntegerField
      FieldName = 'kode_jenis'
    end
    object qryRelasiSetHargakode_satuan: TIntegerField
      FieldName = 'kode_satuan'
    end
    object qryRelasiSetHargatgl_obat: TDateField
      FieldName = 'tgl_obat'
    end
    object qryRelasiSetHargatgl_exp: TDateField
      FieldName = 'tgl_exp'
    end
    object qryRelasiSetHargastatus: TStringField
      FieldName = 'status'
      Size = 100
    end
    object qryRelasiSetHargastok: TIntegerField
      FieldName = 'stok'
    end
  end
  object dsRelasiSetHarga: TDataSource
    DataSet = qryRelasiSetHarga
    Left = 544
    Top = 208
  end
  object qryRelasiStok: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.nama_supplier, b.id as id_pembelian, b.no_faktur, b.tgl' +
        '_pembelian, b.supplier_id, c.harga, c.keterangan, c.created_at, ' +
        'd.id as id_obat, d.kode, d.barcode, d.nama_obat,d.tgl_exp, d.sto' +
        'k from tbl_supplier a left join tbl_pembelian b on b.supplier_id' +
        ' = a.id inner join tbl_stok c on c.no_faktur = b.no_faktur inner' +
        ' join tbl_obat d on d.id = c.obat_id order by b.id desc')
    Left = 312
    Top = 344
  end
  object qryPelanggan: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_pelanggan')
    Left = 488
    Top = 328
    object qryPelangganid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qryPelangganjenis_pelanggan: TStringField
      FieldName = 'jenis_pelanggan'
      Size = 100
    end
  end
  object dsPelanggan: TDataSource
    DataSet = qryPelanggan
    Left = 552
    Top = 344
  end
  object qryRelasiPenjualan: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.id as id_penjualan, a.no_faktur, a.tgl_penjualan, a.jum' +
        'lah_item, a.total, b.id as id_detail_penjualan, b.obat_id, b.jum' +
        'lah_jual, b.harga_jual, c.kode, c.barcode, c.nama_obat, c.tgl_ob' +
        'at, c.tgl_exp, d.jenis, e.satuan from tbl_penjualan a left join ' +
        'tbl_detail_penjualan b on b.penjualan_id = a.id left join tbl_ob' +
        'at c on c.id = b.obat_id left join tbl_jenis d on d.id=c.kode_je' +
        'nis left join tbl_satuan e on e.id = c.kode_satuan')
    Left = 552
    Top = 104
    object qryRelasiPenjualanid_penjualan: TAutoIncField
      FieldName = 'id_penjualan'
      ReadOnly = True
    end
    object qryRelasiPenjualanno_faktur: TStringField
      FieldName = 'no_faktur'
      Size = 50
    end
    object qryRelasiPenjualantgl_penjualan: TDateTimeField
      FieldName = 'tgl_penjualan'
    end
    object qryRelasiPenjualanjumlah_item: TIntegerField
      FieldName = 'jumlah_item'
    end
    object qryRelasiPenjualantotal: TFloatField
      FieldName = 'total'
    end
    object qryRelasiPenjualanid_detail_penjualan: TAutoIncField
      FieldName = 'id_detail_penjualan'
      ReadOnly = True
    end
    object qryRelasiPenjualanobat_id: TIntegerField
      FieldName = 'obat_id'
    end
    object qryRelasiPenjualanjumlah_jual: TIntegerField
      FieldName = 'jumlah_jual'
    end
    object qryRelasiPenjualanharga_jual: TIntegerField
      FieldName = 'harga_jual'
      DisplayFormat = '#,#;(#,#);#,#'
    end
    object qryRelasiPenjualankode: TStringField
      FieldName = 'kode'
      Size = 30
    end
    object qryRelasiPenjualanbarcode: TStringField
      FieldName = 'barcode'
      Size = 100
    end
    object qryRelasiPenjualannama_obat: TStringField
      FieldName = 'nama_obat'
      Size = 150
    end
    object qryRelasiPenjualantgl_obat: TDateField
      FieldName = 'tgl_obat'
    end
    object qryRelasiPenjualantgl_exp: TDateField
      FieldName = 'tgl_exp'
    end
    object qryRelasiPenjualanjenis: TStringField
      FieldName = 'jenis'
      Size = 100
    end
    object qryRelasiPenjualansatuan: TStringField
      FieldName = 'satuan'
      Size = 100
    end
  end
  object dsRelasiPenjualan: TDataSource
    DataSet = qryRelasiPenjualan
    Left = 616
    Top = 128
  end
  object qryDetailPenjualan: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_detail_penjualan')
    Left = 616
    Top = 80
    object qryDetailPenjualanid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qryDetailPenjualanpenjualan_id: TIntegerField
      FieldName = 'penjualan_id'
    end
    object qryDetailPenjualanobat_id: TIntegerField
      FieldName = 'obat_id'
    end
    object qryDetailPenjualanharga_jual: TIntegerField
      FieldName = 'harga_jual'
    end
    object qryDetailPenjualanjumlah_jual: TIntegerField
      FieldName = 'jumlah_jual'
    end
  end
  object qryLaporanPembelian: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select * from tbl_pembelian left join tbl_supplier on tbl_pembel' +
        'ian.supplier_id = tbl_supplier.id')
    Left = 784
    Top = 64
    object qryLaporanPembelianid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qryLaporanPembelianno_faktur: TStringField
      FieldName = 'no_faktur'
      Size = 50
    end
    object qryLaporanPembeliantgl_pembelian: TDateField
      Alignment = taCenter
      FieldName = 'tgl_pembelian'
    end
    object qryLaporanPembeliansupplier_id: TIntegerField
      FieldName = 'supplier_id'
    end
    object qryLaporanPembelianjumlah_item: TIntegerField
      FieldName = 'jumlah_item'
    end
    object qryLaporanPembeliantotal: TFloatField
      FieldName = 'total'
      DisplayFormat = 'Rp. #,#;(#,#);#,#'
    end
    object qryLaporanPembelianuser_id: TIntegerField
      FieldName = 'user_id'
    end
    object qryLaporanPembelianstatus: TStringField
      FieldName = 'status'
      Size = 25
    end
    object qryLaporanPembeliantgl_pembayaran: TDateField
      Alignment = taCenter
      FieldName = 'tgl_pembayaran'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object qryLaporanPembelianid_1: TAutoIncField
      FieldName = 'id_1'
      ReadOnly = True
    end
    object qryLaporanPembeliankode: TStringField
      FieldName = 'kode'
    end
    object qryLaporanPembeliannama_supplier: TStringField
      FieldName = 'nama_supplier'
      Size = 100
    end
    object qryLaporanPembelianalamat_supplier: TMemoField
      FieldName = 'alamat_supplier'
      BlobType = ftMemo
    end
    object qryLaporanPembeliantelp_suplier: TStringField
      FieldName = 'telp_suplier'
      Size = 15
    end
  end
  object qryLaporanPenjualan: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select * from tbl_penjualan left JOIN tbl_pelanggan on tbl_penju' +
        'alan.id_pelanggan = tbl_pelanggan.id')
    Left = 792
    Top = 128
    object qryLaporanPenjualanid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qryLaporanPenjualanno_faktur: TStringField
      FieldName = 'no_faktur'
      Size = 50
    end
    object qryLaporanPenjualantgl_penjualan: TDateTimeField
      FieldName = 'tgl_penjualan'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object qryLaporanPenjualanid_pelanggan: TIntegerField
      FieldName = 'id_pelanggan'
    end
    object qryLaporanPenjualanjumlah_item: TIntegerField
      FieldName = 'jumlah_item'
    end
    object qryLaporanPenjualantotal: TFloatField
      FieldName = 'total'
      DisplayFormat = 'Rp. #,#;(#,#);#,#'
    end
    object qryLaporanPenjualanuser_id: TIntegerField
      FieldName = 'user_id'
    end
    object qryLaporanPenjualanstatus: TStringField
      FieldName = 'status'
      Size = 15
    end
    object qryLaporanPenjualantgl_bayar: TDateTimeField
      FieldName = 'tgl_bayar'
    end
    object qryLaporanPenjualanid_1: TAutoIncField
      FieldName = 'id_1'
      ReadOnly = True
    end
    object qryLaporanPenjualanjenis_pelanggan: TStringField
      FieldName = 'jenis_pelanggan'
      Size = 100
    end
  end
  object qryLaporanStok: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select * from tbl_obat a left join tbl_satuan b on a.kode_satuan' +
        ' = b.id order by a.id')
    Left = 792
    Top = 192
  end
  object qryLaporanItemLaris: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select *, sum(a.jumlah_jual) as jmlItemJual from tbl_detail_penj' +
        'ualan a left join tbl_obat b on a.obat_id = b.id left join tbl_s' +
        'atuan d on d.id = b.kode_satuan group by a.obat_id')
    Left = 792
    Top = 256
  end
  object dsLaporanPembelian: TDataSource
    DataSet = qryLaporanPembelian
    Left = 856
    Top = 40
  end
  object dslaporanPenjualan: TDataSource
    DataSet = qryLaporanPenjualan
    Left = 864
    Top = 112
  end
  object dsLaporanStok: TDataSource
    DataSet = qryLaporanStok
    Left = 872
    Top = 184
  end
  object dsLaporanItemLaris: TDataSource
    DataSet = qryLaporanItemLaris
    Left = 864
    Top = 240
  end
  object qryTotalPenjualan: TADOQuery
    Connection = con1
    Parameters = <>
    Left = 800
    Top = 312
  end
  object qryTotalPembelian: TADOQuery
    Connection = con1
    Parameters = <>
    Left = 800
    Top = 360
  end
  object qrySetting: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_setting')
    Left = 992
    Top = 48
  end
  object qryUser: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_user')
    Left = 992
    Top = 112
    object qryUserid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qryUsernama: TStringField
      FieldName = 'nama'
      Size = 50
    end
    object qryUserusername: TStringField
      FieldName = 'username'
      Size = 25
    end
    object qryUserpassword: TStringField
      FieldName = 'password'
      Size = 25
    end
    object qryUserrole: TStringField
      FieldName = 'role'
      Size = 50
    end
  end
  object dsUser: TDataSource
    DataSet = qryUser
    Left = 1040
    Top = 128
  end
  object qryListPenjualan: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.id as id_pelanggan, a.jenis_pelanggan, b.id as id_penju' +
        'alan, b.no_faktur, b.tgl_penjualan, b.jumlah_item, b.total, b.st' +
        'atus, b.tgl_bayar, c.id as id_user, c.nama, c.role from tbl_pela' +
        'nggan a left join tbl_penjualan b on b.id_pelanggan = a.id inner' +
        ' JOIN tbl_user c on c.id = b.user_id')
    Left = 488
    Top = 24
    object qryListPenjualanid_pelanggan: TAutoIncField
      FieldName = 'id_pelanggan'
      ReadOnly = True
    end
    object qryListPenjualanjenis_pelanggan: TStringField
      FieldName = 'jenis_pelanggan'
      Size = 100
    end
    object qryListPenjualanid_penjualan: TAutoIncField
      FieldName = 'id_penjualan'
      ReadOnly = True
    end
    object qryListPenjualanno_faktur: TStringField
      FieldName = 'no_faktur'
      Size = 50
    end
    object qryListPenjualantgl_penjualan: TDateTimeField
      FieldName = 'tgl_penjualan'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object qryListPenjualanjumlah_item: TIntegerField
      FieldName = 'jumlah_item'
    end
    object qryListPenjualantotal: TFloatField
      FieldName = 'total'
      DisplayFormat = '#,#;(#,#);#,#'
    end
    object qryListPenjualanstatus: TStringField
      FieldName = 'status'
      Size = 15
    end
    object qryListPenjualantgl_bayar: TDateTimeField
      FieldName = 'tgl_bayar'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object qryListPenjualanid_user: TAutoIncField
      FieldName = 'id_user'
      ReadOnly = True
    end
    object qryListPenjualannama: TStringField
      FieldName = 'nama'
      Size = 50
    end
    object qryListPenjualanrole: TStringField
      FieldName = 'role'
      Size = 50
    end
  end
  object dsListPenjualan: TDataSource
    DataSet = qryListPenjualan
    Left = 560
    Top = 16
  end
end
