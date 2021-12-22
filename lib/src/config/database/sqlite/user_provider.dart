import 'package:kasir_app/src/config/entity/user_entity.dart';
import 'package:kasir_app/src/resources/util.dart';
import 'package:sqflite/sqlite_api.dart';

class UserProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    await db?.execute('''
        create table ${UserEntity.tableName} ( 
          ${UserEntity.columnId} integer primary key autoincrement, 
          ${UserEntity.columnNama} text not null,
          ${UserEntity.columnUsername} text not null,
          ${UserEntity.columnPassword} text not null)
          ''');

    await db?.insert(
        UserEntity.tableName,
        UserEntity(nama: 'administrator', username: 'admin', password: Util.hash('admin'))
            .toMapWithoutId());
  }

  Future close() async => await db?.close();

  Future<List<UserEntity>> getAllUser() async {
    List<Map<String, Object?>>? allUser =
        await db?.query(UserEntity.tableName, columns: [
      UserEntity.columnId,
      UserEntity.columnNama,
      UserEntity.columnUsername,
    ]);

    if (allUser != null) {
      return allUser.map((mapUser) => UserEntity.fromMap(mapUser)).toList();
    } else {
      return List.empty(growable: false);
    }
  }

  Future<UserEntity?> login(String username, String password) async {
    List<Map<String, Object?>>? allUser = await db?.query(
      UserEntity.tableName,
      columns: [
        UserEntity.columnId,
        UserEntity.columnNama,
        UserEntity.columnUsername,
      ],
      where:
          '${UserEntity.columnUsername} = ? AND ${UserEntity.columnPassword} = ?',
      whereArgs: [
        username,
        password,
      ],
    );

    if (allUser != null && allUser.isNotEmpty) {
      return UserEntity.fromMap(allUser.first);
    }
    return null;
  }

  Future<UserEntity?> getUserById(int userId) async {
    List<Map<String, Object?>>? allUser = await db?.query(
      UserEntity.tableName,
      columns: [
        UserEntity.columnId,
        UserEntity.columnNama,
        UserEntity.columnUsername,
      ],
      where: '${UserEntity.columnId} = ?',
      whereArgs: [
        userId,
      ],
    );
    if (allUser != null && allUser.isNotEmpty) {
      return UserEntity.fromMap(allUser.first);
    } else {
      return null;
    }
  }

  Future<int> insert(UserEntity user) async {
    int? id = await db?.insert(UserEntity.tableName, user.toMapWithoutId());

    if (id != null && id > 0) {
      return id;
    } else {
      return -1;
    }
  }

  Future<int> update(UserEntity customer) async {
    int? resultUpdate = await db?.update(
        UserEntity.tableName, customer.toMapWithoutId(),
        where: '${UserEntity.columnId} = ?',
        whereArgs: [
          customer.id,
        ]);

    if (resultUpdate != null && resultUpdate > 0) {
      return resultUpdate;
    } else {
      return -1;
    }
  }

  Future<int> delete(UserEntity customer) async {
    int? resultDelete = await db?.delete(
      UserEntity.tableName,
      where: '${UserEntity.columnId} = ?',
      whereArgs: [
        customer.id,
      ],
    );

    if (resultDelete != null && resultDelete > 0) {
      return resultDelete;
    } else {
      return -1;
    }
  }
}
