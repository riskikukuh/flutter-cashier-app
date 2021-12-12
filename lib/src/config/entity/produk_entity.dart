class ProdukEntity {
  static const String tableName = 'produk';
  static const String columnId = '_id';
  static const String columnAliasId = 'id_produk';
  static const String columnNama = 'nama_produk';
  static const String columnHarga = 'harga';
  static const String columnStok = 'stok';
  static const String columnSupplier = 'id_supplier';
  static const String columnDeletedAt = 'deleted_at';

  int? id;
  String? nama;
  int? harga;
  int? stok;
  int? supplier;
  int? deletedAt;

  ProdukEntity({
    this.id,
    this.nama,
    this.harga,
    this.stok,
    this.supplier = -1,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnNama: nama,
      columnHarga: harga,
      columnStok: stok,
      columnSupplier: supplier,
      columnDeletedAt: deletedAt,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      columnNama: nama,
      columnHarga: harga,
      columnStok: stok,
      columnSupplier: supplier,
      columnDeletedAt: deletedAt,
    };
  }

  ProdukEntity.fromMap(Map<String, Object?> map) {
    id = (map[columnId] as int?);
    nama = (map[columnNama] as String?);
    harga = (map[columnHarga] as int?) ?? -1;
    stok = (map[columnStok] as int?) ?? 0;
    supplier = (map[columnSupplier] as int?) ?? -1;
    deletedAt = (map[columnDeletedAt] as int?);
  }
}