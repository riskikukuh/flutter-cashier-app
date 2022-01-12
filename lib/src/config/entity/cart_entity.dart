class CartEntity {
  static const String tableName = 'cart';
  static const String columnId = '_id';
  static const String columnDate = 'date';
  static const String columnProduk = 'id_produk';
  static const String columnQuantity = 'quantity';

  int? id;
  int? date;
  int? produk;
  int? quantity;

  CartEntity({
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

  CartEntity.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int?;
    date = map[columnDate] as int?;
    produk = map[columnProduk] as int?;
    quantity = map[columnQuantity] as int?;
  }
}