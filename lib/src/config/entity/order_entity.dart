class OrderEntity {
  static const String tableName = 'ordering';
  static const String columnId = '_id';
  static const String columnDate = 'date';
  static const String columnProduk = 'id_produk';
  static const String columnQuantity = 'quantity';
  static const String columnCountOrder = 'count_order';

  int? id;
  int? date;
  int? produk;
  int? quantity;

  OrderEntity({
    this.id,
    this.date,
    this.produk,
    this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnDate: date,
      columnProduk: produk,
      columnQuantity: quantity,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      columnDate: date,
      columnProduk: produk,
      columnQuantity: quantity,
    };
  }

  OrderEntity.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int?;
    date = map[columnDate] as int?;
    produk = map[columnProduk] as int?;
    quantity = map[columnQuantity] as int?;
  }
}