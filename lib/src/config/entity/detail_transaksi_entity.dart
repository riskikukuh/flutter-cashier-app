class DetailTransaksiEntity {
  static const String tableName = 'detail_transaksi';
  static const String columnId = '_id';
  static const String columnIdTransaksi = 'id_transaksi';
  static const String columnIdProduk = 'id_produk';
  static const String columnQuantity = 'quantity';
  
  int? id;
  int? idTransaksi;
  int? idProduk;
  int? quantity;

  DetailTransaksiEntity({
    this.id,
    this.idTransaksi,
    this.idProduk,
    this.quantity,
  });

  DetailTransaksiEntity.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int?;
    idTransaksi = map[columnIdTransaksi] as int?;
    idProduk = map[columnIdProduk] as int?;
    quantity = map[columnQuantity] as int?;
  }

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnIdTransaksi: idTransaksi,
      columnIdProduk: idProduk,
      columnQuantity: quantity,
    };
  }
  
  Map<String, dynamic> toMapWithoutId() {
    return {
      columnIdTransaksi: idTransaksi,
      columnIdProduk: idProduk,
      columnQuantity: quantity,
    };
  }
}