class CustomerEntity {
  static const String tableName = 'customer';
  static const String columnId = '_id';
  static const String columnNama = 'nama';
  static const String columnJk = 'jk';
  static const String columnNoTelp = 'no_telp';
  static const String columnAlamat = 'alamat';
  static const String columnDeletedAt = 'deleted_at';

  int? id;
  String? nama;
  String? jk;
  String? noTelp;
  String? alamat;
  int? deletedAt;

  CustomerEntity({
    this.id,
    this.nama,
    this.jk,
    this.noTelp,
    this.alamat,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnNama: nama,
      columnJk: jk,
      columnNoTelp: noTelp,
      columnAlamat: alamat,
      columnDeletedAt: deletedAt,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      columnNama: nama,
      columnJk: jk,
      columnNoTelp: noTelp,
      columnAlamat: alamat,
      columnDeletedAt: deletedAt,
    };
  }

  CustomerEntity.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int?;
    nama = map[columnNama] as String?;
    jk = map[columnJk] as String?;
    noTelp = map[columnNoTelp] as String?;
    alamat = map[columnAlamat] as String?;
    deletedAt = map[columnDeletedAt] as int?;
  }
}