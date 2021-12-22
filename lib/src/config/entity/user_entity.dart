class UserEntity {
  static const String tableName = 'users';
  static const String columnId = '_id';
  static const String columnNama = 'nama';
  static const String columnUsername = 'username';
  static const String columnPassword = 'password';

  int? id;
  String? nama;
  String? username;
  String? password;

  UserEntity({
    this.id,
    this.nama,
    this.username,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnNama: nama,
      columnUsername: username,
      columnPassword: password,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      columnNama: nama,
      columnUsername: username,
      columnPassword: password,
    };
  }

  UserEntity.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int?;
    nama = map[columnNama] as String?;
    username = map[columnUsername] as String?;
    password = map[columnPassword] as String?;
  }
}