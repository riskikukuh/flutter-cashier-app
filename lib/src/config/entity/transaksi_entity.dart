class TransaksiEntity {
  static const String tableName = 'transaksi';
  static const String columnId = '_id';
  static const String columnAliasId = 'id_transaksi';
  static const String columnIdPembeli = 'id_pembeli';
  static const String columnTanggal = 'tanggal';
  static const String columnKeterangan = 'keterangan';
  static const String columnPrice = 'total_price';

  int? id;
  int? idPembeli;
  int? tanggal;
  String? keterangan;
  int? price;

  TransaksiEntity({
    this.id,
    this.idPembeli,
    this.tanggal,
    this.keterangan,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnIdPembeli: idPembeli,
      columnTanggal: tanggal,
      columnKeterangan: keterangan,
      columnPrice: price,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      columnIdPembeli: idPembeli,
      columnTanggal: tanggal,
      columnKeterangan: keterangan,
      columnPrice: price,
    };
  }

  TransaksiEntity.fromMap(Map<String, Object?> map) {
    id = (map[columnId] as int?);
    idPembeli = (map[columnIdPembeli] as int?);
    tanggal = (map[columnTanggal] as int?);
    keterangan = (map[columnKeterangan] as String?);
    price = (map[columnPrice] as int?);
  }
}