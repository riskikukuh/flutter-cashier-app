class DetailTransaksiStokEntity {
  static const String tableName = 'detail_transaksi_stok';
  static const String columnId = '_id';
  static const String columnIdTransaksiStok = 'id_transaksi_stok';
  static const String columnIdProduk = 'id_produk';
  static const String columnQuantity = 'quantity';
  
  int? id;
  int? idTransaksiStok;
  int? idProduk;
  int? quantity;

  DetailTransaksiStokEntity({
    this.id,
    this.idTransaksiStok,
    this.idProduk,
    this.quantity,
  });

  DetailTransaksiStokEntity.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int?;
    idTransaksiStok = map[columnIdTransaksiStok] as int?;
    idProduk = map[columnIdProduk] as int?;
    quantity = map[columnQuantity] as int?;
  }

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnIdTransaksiStok: idTransaksiStok,
      columnIdProduk: idProduk,
      columnQuantity: quantity,
    };
  }
  
  Map<String, dynamic> toMapWithoutId() {
    return {
      columnIdTransaksiStok: idTransaksiStok,
      columnIdProduk: idProduk,
      columnQuantity: quantity,
    };
  }
}