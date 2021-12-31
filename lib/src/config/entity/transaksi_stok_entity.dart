class TransaksiStokEntity {
  static const String tableName = 'transaksi_stok';
  static const String columnId = '_id';
  static const String columnAliasId = 'id_transaksi_stok';
  static const String columnTanggal = 'tanggal';
  static const String columnKeterangan = 'keterangan';
  static const String columnPrice = 'price';

  int? id;
  int? tanggal;
  String? keterangan;
  int? price;

  TransaksiStokEntity({
    this.id,
    this.tanggal,
    this.keterangan,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnTanggal: tanggal,
      columnKeterangan: keterangan,
      columnPrice: price,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      columnTanggal: tanggal,
      columnKeterangan: keterangan,
      columnPrice: price,
    };
  }

  TransaksiStokEntity.fromMap(Map<String, Object?> map) {
    id = (map[columnId] as int?);
    tanggal = (map[columnTanggal] as int?);
    keterangan = (map[columnKeterangan] as String?);
    price = (map[columnPrice] as int?);
  }
}