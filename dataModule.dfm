object dm: Tdm
  OldCreateOrder = False
  Left = 163
  Top = 205
  Height = 456
  Width = 1702
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
        'jenis, b.kode_satuan, b.stok, b.status, a.id as id_jenis, a.kode' +
        ' as jenisKode, a.jenis, c.id as id_satuan, c.kode as satuanKode,' +
        ' c.satuan from tbl_jenis a left join tbl_obat b on a.id = b.kode' +
        '_jenis INNER join tbl_satuan c on c.id = b.kode_satuan order by ' +
        'b.id;')
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
    object qryObatRelasistatus: TStringField
      FieldName = 'status'
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
      
        'select a.id as id_pembelian, a.no_faktur, a.no_faktur_supplier, ' +
        'a.tgl_pembelian, a.jumlah_item, a.total, b.id as id_detail_pembe' +
        'lian, b.obat_id, b.jumlah_beli, b.harga_beli, c.kode, c.barcode,' +
        ' c.nama_obat, c.tgl_obat, c.tgl_exp, d.jenis, e.satuan from tbl_' +
        'pembelian a left join tbl_detail_pembelian b on b.pembelian_id =' +
        ' a.id left join tbl_obat c on c.id = b.obat_id left join tbl_jen' +
        'is d on d.id=c.kode_jenis left join tbl_satuan e on e.id = c.kod' +
        'e_satuan '#10)
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
    object qryRelasiPembelianno_faktur_supplier: TStringField
      FieldName = 'no_faktur_supplier'
      Size = 30
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
      DisplayFormat = 'dd/mm/yyyy'
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
      DisplayFormat = 'dd/mm/yyyy'
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
    object qryListPembelianno_faktur_supplier: TStringField
      FieldName = 'no_faktur_supplier'
      Size = 50
    end
    object qryListPembeliantgl_jatuh_tempo: TDateField
      FieldName = 'tgl_jatuh_tempo'
      DisplayFormat = 'dd/mm/yyyy'
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
    object qryStokalasan: TStringField
      FieldName = 'alasan'
      Size = 200
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
      DisplayFormat = 'dd/mm/yyyy'
    end
    object qryRelasiSetHargastatus: TStringField
      FieldName = 'status'
      Size = 100
    end
    object qryRelasiSetHargastok: TIntegerField
      FieldName = 'stok'
    end
    object qryRelasiSetHargaharga_jual_grosir: TFloatField
      FieldName = 'harga_jual_grosir'
    end
    object qryRelasiSetHargaqty_max_grosir: TIntegerField
      FieldName = 'qty_max_grosir'
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
        'at, c.tgl_exp, d.jenis, e.satuan, b.catatan from tbl_penjualan a' +
        ' left join tbl_detail_penjualan b on b.penjualan_id = a.id left ' +
        'join tbl_obat c on c.id = b.obat_id left join tbl_jenis d on d.i' +
        'd=c.kode_jenis left join tbl_satuan e on e.id = c.kode_satuan')
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
    object qryRelasiPenjualancatatan: TStringField
      FieldName = 'catatan'
      Size = 200
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
    object qryDetailPenjualanstatus: TStringField
      FieldName = 'status'
      Size = 50
    end
    object qryDetailPenjualancatatan: TStringField
      FieldName = 'catatan'
      Size = 200
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
    Left = 720
    Top = 48
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
      DisplayFormat = 'dd/mm/yyyy'
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
    object qryLaporanPembelianno_faktur_supplier: TStringField
      FieldName = 'no_faktur_supplier'
      Size = 50
    end
    object qryLaporanPembeliantgl_jatuh_tempo: TDateField
      FieldName = 'tgl_jatuh_tempo'
      DisplayFormat = 'dd/mm/yyyy'
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
    Left = 728
    Top = 112
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
        ' = b.id left join tbl_harga_jual c on c.obat_id = a.id order by ' +
        'a.id;')
    Left = 728
    Top = 176
    object qryLaporanStokid: TIntegerField
      FieldName = 'id'
    end
    object qryLaporanStokkode: TStringField
      FieldName = 'kode'
      Size = 30
    end
    object qryLaporanStokbarcode: TStringField
      FieldName = 'barcode'
      Size = 100
    end
    object qryLaporanStoknama_obat: TStringField
      FieldName = 'nama_obat'
      Size = 150
    end
    object qryLaporanStokkode_jenis: TIntegerField
      FieldName = 'kode_jenis'
    end
    object qryLaporanStokkode_satuan: TIntegerField
      FieldName = 'kode_satuan'
    end
    object qryLaporanStoktgl_obat: TDateField
      FieldName = 'tgl_obat'
    end
    object qryLaporanStoktgl_exp: TDateField
      FieldName = 'tgl_exp'
    end
    object qryLaporanStokstatus: TStringField
      FieldName = 'status'
      Size = 100
    end
    object qryLaporanStokstok: TIntegerField
      FieldName = 'stok'
    end
    object qryLaporanStokid_1: TIntegerField
      FieldName = 'id_1'
    end
    object qryLaporanStokkode_1: TStringField
      FieldName = 'kode_1'
    end
    object qryLaporanStoksatuan: TStringField
      FieldName = 'satuan'
      Size = 100
    end
    object qryLaporanStokid_2: TIntegerField
      FieldName = 'id_2'
    end
    object qryLaporanStokobat_id: TIntegerField
      FieldName = 'obat_id'
    end
    object qryLaporanStokharga_jual: TFloatField
      FieldName = 'harga_jual'
    end
    object qryLaporanStokharga_beli_terakhir: TIntegerField
      FieldName = 'harga_beli_terakhir'
      DisplayFormat = '#,##;(#,##);#,##'
    end
    object qryLaporanStoksupplier: TStringField
      FieldName = 'supplier'
      Size = 50
    end
    object qryLaporanStoksatuan_1: TStringField
      FieldName = 'satuan_1'
      Size = 100
    end
    object qryLaporanStokjenis: TStringField
      FieldName = 'jenis'
      Size = 100
    end
    object qryLaporanStokcreated_at: TDateTimeField
      FieldName = 'created_at'
    end
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
    Left = 728
    Top = 240
  end
  object dsLaporanPembelian: TDataSource
    DataSet = qryLaporanPembelian
    Left = 792
    Top = 24
  end
  object dslaporanPenjualan: TDataSource
    DataSet = qryLaporanPenjualan
    Left = 800
    Top = 96
  end
  object dsLaporanStok: TDataSource
    DataSet = qryLaporanStok
    Left = 808
    Top = 168
  end
  object dsLaporanItemLaris: TDataSource
    DataSet = qryLaporanItemLaris
    Left = 800
    Top = 224
  end
  object qryTotalPenjualan: TADOQuery
    Connection = con1
    Parameters = <>
    Left = 736
    Top = 296
  end
  object qryTotalPembelian: TADOQuery
    Connection = con1
    Parameters = <>
    Left = 736
    Top = 344
  end
  object qrySetting: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_setting')
    Left = 928
    Top = 32
  end
  object qryUser: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_user')
    Left = 928
    Top = 96
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
    Left = 976
    Top = 112
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
  object qryRetur: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_retur')
    Left = 936
    Top = 200
  end
  object dsRetur: TDataSource
    DataSet = qryRetur
    Left = 968
    Top = 240
  end
  object qryRelasiReturObat: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select * from tbl_stok left join tbl_obat on tbl_obat.id = tbl_s' +
        'tok.obat_id')
    Left = 944
    Top = 328
  end
  object dsRelasiReturObat: TDataSource
    DataSet = qryRelasiReturObat
    Left = 984
    Top = 312
  end
  object qryListRetur: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOI' +
        'N tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keteran' +
        'gan='#39'retur-penjualan'#39' GROUP BY a.kode;')
    Left = 992
    Top = 184
  end
  object dsListRetur: TDataSource
    DataSet = qryListRetur
    Left = 1024
    Top = 176
  end
  object qryDetailRetur: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select * from tbl_retur a LEFT JOIN tbl_stok b ON b.no_faktur = ' +
        'a.faktur_penjualan INNER JOIN tbl_obat c ON c.id = b.obat_id')
    Left = 1024
    Top = 232
    object qryDetailReturid: TAutoIncField
      FieldName = 'id'
      ReadOnly = True
    end
    object qryDetailReturkode: TStringField
      FieldName = 'kode'
      Size = 100
    end
    object qryDetailReturtgl_retur: TDateField
      FieldName = 'tgl_retur'
    end
    object qryDetailReturfaktur_penjualan: TStringField
      FieldName = 'faktur_penjualan'
      Size = 50
    end
    object qryDetailReturjenis_retur: TStringField
      FieldName = 'jenis_retur'
      Size = 50
    end
    object qryDetailReturstatus: TStringField
      FieldName = 'status'
      Size = 50
    end
    object qryDetailReturid_1: TAutoIncField
      FieldName = 'id_1'
      ReadOnly = True
    end
    object qryDetailReturno_faktur: TStringField
      FieldName = 'no_faktur'
      Size = 50
    end
    object qryDetailReturobat_id: TIntegerField
      FieldName = 'obat_id'
    end
    object qryDetailReturjumlah: TIntegerField
      FieldName = 'jumlah'
    end
    object qryDetailReturharga: TFloatField
      FieldName = 'harga'
      DisplayFormat = '#,###;(#,##);#,##'
    end
    object qryDetailReturketerangan: TStringField
      FieldName = 'keterangan'
      Size = 25
    end
    object qryDetailReturalasan: TStringField
      FieldName = 'alasan'
      Size = 200
    end
    object qryDetailReturcreated_at: TDateTimeField
      FieldName = 'created_at'
    end
    object qryDetailReturid_2: TAutoIncField
      FieldName = 'id_2'
      ReadOnly = True
    end
    object qryDetailReturkode_1: TStringField
      FieldName = 'kode_1'
      Size = 30
    end
    object qryDetailReturbarcode: TStringField
      FieldName = 'barcode'
      Size = 100
    end
    object qryDetailReturnama_obat: TStringField
      FieldName = 'nama_obat'
      Size = 150
    end
    object qryDetailReturkode_jenis: TIntegerField
      FieldName = 'kode_jenis'
    end
    object qryDetailReturkode_satuan: TIntegerField
      FieldName = 'kode_satuan'
    end
    object qryDetailReturtgl_obat: TDateField
      FieldName = 'tgl_obat'
    end
    object qryDetailReturtgl_exp: TDateField
      FieldName = 'tgl_exp'
    end
    object qryDetailReturstatus_1: TStringField
      FieldName = 'status_1'
      Size = 100
    end
    object qryDetailReturstok: TIntegerField
      FieldName = 'stok'
    end
  end
  object dsDetailRetur: TDataSource
    DataSet = qryDetailRetur
    Left = 1088
    Top = 248
  end
  object qryDashObat: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_' +
        'jenis, b.kode_satuan, b.stok, b.status, a.id as id_jenis, a.kode' +
        ' as jenisKode, a.jenis, c.id as id_satuan, c.kode as satuanKode,' +
        ' c.satuan from tbl_jenis a left join tbl_obat b on a.id = b.kode' +
        '_jenis INNER join tbl_satuan c on c.id = b.kode_satuan order by ' +
        'b.id;')
    Left = 1192
    Top = 136
  end
  object qryLabaPenjualan: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select b.kode, b.nama_obat, c.harga_beli_terakhir, a.harga_jual,' +
        ' sum(a.jumlah_jual) as jmlItemJual, sum(a.jumlah_jual * a.harga_' +
        'jual) as total_jual, (sum(a.jumlah_jual * a.harga_jual) - c.harg' +
        'a_beli_terakhir) as laba, a.jenis_harga'
      
        'from tbl_penjualan z left join tbl_detail_penjualan a ON z.id = ' +
        'a.penjualan_id'
      
        'left join tbl_obat b on a.obat_id = b.id left join tbl_satuan d ' +
        'on d.id = b.kode_satuan'
      'left join tbl_harga_jual c ON c.obat_id = b.id'
      
        'where date(z.tgl_penjualan)='#39'2022-01-30'#39' AND COALESCE(a.status, ' +
        #39#39') <> '#39'retur'#39
      'group by a.obat_id')
    Left = 1128
    Top = 32
    object qryLabaPenjualankode: TStringField
      FieldName = 'kode'
      Size = 30
    end
    object qryLabaPenjualannama_obat: TStringField
      FieldName = 'nama_obat'
      Size = 150
    end
    object qryLabaPenjualanharga_beli_terakhir: TIntegerField
      FieldName = 'harga_beli_terakhir'
      DisplayFormat = '#,##;(#,##);#,##'
    end
    object qryLabaPenjualanharga_jual: TIntegerField
      FieldName = 'harga_jual'
      DisplayFormat = '#,##;(#,##);#,##'
    end
    object qryLabaPenjualanjmlItemJual: TBCDField
      FieldName = 'jmlItemJual'
      ReadOnly = True
      Precision = 32
      Size = 0
    end
    object qryLabaPenjualantotal_jual: TBCDField
      FieldName = 'total_jual'
      ReadOnly = True
      DisplayFormat = '#,##;(#,##);#,##'
      Precision = 32
      Size = 0
    end
    object qryLabaPenjualanlaba: TBCDField
      FieldName = 'laba'
      ReadOnly = True
      DisplayFormat = '#,##;(#,##);#,##'
      Precision = 32
      Size = 0
    end
    object qryLabaPenjualanjenis_harga: TStringField
      FieldName = 'jenis_harga'
      Size = 100
    end
  end
  object dsLabaPenjualan: TDataSource
    DataSet = qryLabaPenjualan
    Left = 1200
    Top = 72
  end
  object qryDashExp: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id' +
        ' = b.id where (DATEDIFF(b.tgl_exp,now())) < 100')
    Left = 1128
    Top = 128
  end
  object qryHarga: TADOQuery
    Connection = con1
    Parameters = <>
    Left = 552
    Top = 256
  end
  object qryLabaPenjualanGrosir: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select b.kode, b.nama_obat, c.harga_beli_terakhir, a.harga_jual,' +
        ' sum(a.jumlah_jual) as jmlItemJual, sum(a.jumlah_jual * a.harga_' +
        'jual) as total_jual, (sum(a.jumlah_jual * a.harga_jual) - c.harg' +
        'a_beli_terakhir) as laba, a.jenis_harga'
      
        'from tbl_penjualan z left join tbl_detail_penjualan a ON z.id = ' +
        'a.penjualan_id'
      
        'left join tbl_obat b on a.obat_id = b.id left join tbl_satuan d ' +
        'on d.id = b.kode_satuan'
      'left join tbl_harga_jual c ON c.obat_id = b.id'
      
        'where date(z.tgl_penjualan)='#39'2022-01-30'#39' AND COALESCE(a.status, ' +
        #39#39') <> '#39'retur'#39
      'group by a.obat_id')
    Left = 1224
    Top = 16
    object qryLabaPenjualanGrosirkode: TStringField
      FieldName = 'kode'
      Size = 30
    end
    object qryLabaPenjualanGrosirnama_obat: TStringField
      FieldName = 'nama_obat'
      Size = 150
    end
    object qryLabaPenjualanGrosirharga_beli_terakhir: TIntegerField
      FieldName = 'harga_beli_terakhir'
      DisplayFormat = '#,##;(#,##);#,##'
    end
    object qryLabaPenjualanGrosirharga_jual: TIntegerField
      FieldName = 'harga_jual'
      DisplayFormat = '#,##;(#,##);#,##'
    end
    object qryLabaPenjualanGrosirjmlItemJual: TBCDField
      FieldName = 'jmlItemJual'
      ReadOnly = True
      Precision = 32
      Size = 0
    end
    object qryLabaPenjualanGrosirtotal_jual: TBCDField
      FieldName = 'total_jual'
      ReadOnly = True
      DisplayFormat = '#,##;(#,##);#,##'
      Precision = 32
      Size = 0
    end
    object qryLabaPenjualanGrosirlaba: TBCDField
      FieldName = 'laba'
      ReadOnly = True
      DisplayFormat = '#,##;(#,##);#,##'
      Precision = 32
      Size = 0
    end
    object qryLabaPenjualanGrosirjenis_harga: TStringField
      FieldName = 'jenis_harga'
      Size = 100
    end
  end
  object dsLabaPenjualanGrosir: TDataSource
    DataSet = qryLabaPenjualanGrosir
    Left = 1280
    Top = 64
  end
  object qryDashListObat: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select b.id, b.kode as kodeObat, b.barcode, b.nama_obat, b.kode_' +
        'jenis, b.kode_satuan, b.stok, b.status, a.id as id_jenis, a.kode' +
        ' as jenisKode, a.jenis, c.id as id_satuan, c.kode as satuanKode,' +
        ' c.satuan, d.harga_jual, d.harga_jual_grosir, d.qty_max_grosir f' +
        'rom tbl_jenis a left join tbl_obat b on a.id = b.kode_jenis INNE' +
        'R join tbl_satuan c on c.id = b.kode_satuan LEFt JOIN tbl_harga_' +
        'jual d ON d.obat_id = b.id  '
      'ORDER BY `kodeObat` ASC')
    Left = 1208
    Top = 272
    object qryDashListObatid: TIntegerField
      FieldName = 'id'
    end
    object qryDashListObatkodeObat: TStringField
      FieldName = 'kodeObat'
      Size = 30
    end
    object qryDashListObatbarcode: TStringField
      FieldName = 'barcode'
      Size = 100
    end
    object qryDashListObatnama_obat: TStringField
      FieldName = 'nama_obat'
      Size = 150
    end
    object qryDashListObatkode_jenis: TIntegerField
      FieldName = 'kode_jenis'
    end
    object qryDashListObatkode_satuan: TIntegerField
      FieldName = 'kode_satuan'
    end
    object qryDashListObatstok: TIntegerField
      FieldName = 'stok'
    end
    object qryDashListObatstatus: TStringField
      FieldName = 'status'
      Size = 100
    end
    object qryDashListObatid_jenis: TIntegerField
      FieldName = 'id_jenis'
    end
    object qryDashListObatjenisKode: TStringField
      FieldName = 'jenisKode'
    end
    object qryDashListObatjenis: TStringField
      FieldName = 'jenis'
      Size = 100
    end
    object qryDashListObatid_satuan: TIntegerField
      FieldName = 'id_satuan'
    end
    object qryDashListObatsatuanKode: TStringField
      FieldName = 'satuanKode'
    end
    object qryDashListObatsatuan: TStringField
      FieldName = 'satuan'
      Size = 100
    end
    object qryDashListObatharga_jual: TFloatField
      FieldName = 'harga_jual'
      DisplayFormat = '#,##;(#,##);#,##'
    end
    object qryDashListObatharga_jual_grosir: TFloatField
      FieldName = 'harga_jual_grosir'
      DisplayFormat = '#,##;(#,##);#,##'
    end
    object qryDashListObatqty_max_grosir: TIntegerField
      FieldName = 'qty_max_grosir'
      DisplayFormat = '#,##;(#,##);#,##'
    end
  end
  object qryDashhObat: TADOQuery
    Connection = con1
    Parameters = <>
    Left = 1256
    Top = 200
  end
  object qryDashSupplier: TADOQuery
    Connection = con1
    Parameters = <>
    Left = 1280
    Top = 152
  end
  object dsDashListObat: TDataSource
    DataSet = qryDashListObat
    Left = 1280
    Top = 280
  end
  object qryDashListExp: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select * from tbl_harga_jual a left join tbl_obat b on a.obat_id' +
        ' = b.id where (DATEDIFF(b.tgl_exp,now())) < 100')
    Left = 1208
    Top = 336
  end
  object dsDashListExp: TDataSource
    DataSet = qryDashListExp
    Left = 1280
    Top = 344
  end
  object qryDashReturPenjualan: TADOQuery
    Connection = con1
    Parameters = <>
    Left = 1408
    Top = 280
  end
  object qryListDashReturPenjualan: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select *, count(b.obat_id) as jml_item from tbl_retur a LEFT JOI' +
        'N tbl_stok b ON b.no_faktur = a.faktur_penjualan WHERE b.keteran' +
        'gan='#39'retur-penjualan'#39' GROUP BY a.kode;')
    Left = 1480
    Top = 336
  end
  object dsListDashReturPenjulan: TDataSource
    DataSet = qryListDashReturPenjualan
    Left = 1528
    Top = 312
  end
end
