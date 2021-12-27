class ProdukEntity {
  static const String tableName = 'produk';
  static const String columnId = '_id';
  static const String columnAliasId = 'id_produk';
  static const String columnNama = 'nama_produk';
  static const String columnHargaJual = 'harga_jual';
  static const String columnHargaStok = 'harga_stok';
  static const String columnStok = 'stok';
  static const String columnSupplier = 'id_supplier';
  static const String columnDeletedAt = 'deleted_at';

  int? id;
  String? nama;
  int? hargaJual;
  int? hargaStok;
  int? stok;
  int? supplier;
  int? deletedAt;

  ProdukEntity({
    this.id,
    this.nama,
    this.hargaJual,
    this.hargaStok,
    this.stok,
    this.supplier = -1,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnNama: nama,
      columnHargaJual: hargaJual,
      columnHargaStok: hargaStok,
      columnStok: stok,
      columnSupplier: supplier,
      columnDeletedAt: deletedAt,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      columnNama: nama,
      columnHargaJual: hargaJual,
      columnHargaStok: hargaStok,
      columnStok: stok,
      columnSupplier: supplier,
      columnDeletedAt: deletedAt,
    };
  }

  ProdukEntity.fromMap(Map<String, Object?> map) {
    id = (map[columnId] as int?);
    nama = (map[columnNama] as String?);
    hargaJual = (map[columnHargaJual] as int?) ?? -1;
    hargaStok = (map[columnHargaStok] as int?) ?? -1;
    stok = (map[columnStok] as int?) ?? 0;
    supplier = (map[columnSupplier] as int?) ?? -1;
    deletedAt = (map[columnDeletedAt] as int?);
  }
}