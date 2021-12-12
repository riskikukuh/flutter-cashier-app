class SupplierEntity {
  static const String tableName = 'supplier';
  static const String columnId = '_id';
  static const String columnNama = 'nama';
  static const String columnNoTelp = 'no_telp';
  static const String columnAlamat = 'alamat';
  static const String columnDeletedAt = 'deleted_at';

  int? id;
  String? nama;
  String? noTelp;
  String? alamat;
  int? deletedAt;

  SupplierEntity({
    this.id,
    this.nama,
    this.noTelp,
    this.alamat,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnNama: nama,
      columnNoTelp: noTelp,
      columnAlamat: alamat,
      columnDeletedAt: deletedAt,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      columnNama: nama,
      columnNoTelp: noTelp,
      columnAlamat: alamat,
      columnDeletedAt: deletedAt,
    };
  }

  SupplierEntity.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int?;
    nama = map[columnNama] as String?;
    noTelp = map[columnNoTelp] as String?;
    alamat = map[columnAlamat] as String?;
    deletedAt = map[columnDeletedAt] as int?;
  }
}
