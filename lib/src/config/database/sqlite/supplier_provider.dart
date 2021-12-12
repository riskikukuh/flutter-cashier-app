import 'package:kasir_app/src/config/entity/supplier_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class SupplierProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    await db?.execute('''
        create table ${SupplierEntity.tableName} ( 
          ${SupplierEntity.columnId} integer primary key autoincrement, 
          ${SupplierEntity.columnNama} text not null,
          ${SupplierEntity.columnNoTelp} text not null,
          ${SupplierEntity.columnAlamat} text not null,
          ${SupplierEntity.columnDeletedAt} int)
          ''');

    await db?.insert(
      SupplierEntity.tableName,
      SupplierEntity(id: -1, nama: 'guest', alamat: 'guest', noTelp: 'guest')
          .toMapWithoutId(),
    );
  }

  Future close() async => await db?.close();

  Future<List<SupplierEntity>> getAllSupplier() async {
    List<Map<String, Object?>>? allSupplier = await db?.query(
      SupplierEntity.tableName,
      columns: [
        SupplierEntity.columnId,
        SupplierEntity.columnNama,
        SupplierEntity.columnNoTelp,
        SupplierEntity.columnAlamat,
        SupplierEntity.columnDeletedAt,
      ],
      where: '${SupplierEntity.columnDeletedAt} IS NULL',
    );

    if (allSupplier != null) {
      return allSupplier
          .map((mapSupplier) => SupplierEntity.fromMap(mapSupplier))
          .toList();
    } else {
      return List.empty(growable: false);
    }
  }

  Future<SupplierEntity?> getSupplierById(int supplierId) async {
    List<Map<String, Object?>>? allSupplier = await db?.query(
      SupplierEntity.tableName,
      columns: [
        SupplierEntity.columnId,
        SupplierEntity.columnNama,
        SupplierEntity.columnNoTelp,
        SupplierEntity.columnAlamat,
      ],
      where:
          '${SupplierEntity.columnDeletedAt} IS NULL AND ${SupplierEntity.columnId} = ?',
      whereArgs: [
        supplierId,
      ],
    );
    if (allSupplier != null && allSupplier.isNotEmpty) {
      return SupplierEntity.fromMap(allSupplier.first);
    } else {
      return null;
    }
  }

  Future<int> insert(SupplierEntity supplier) async {
    int? id =
        await db?.insert(SupplierEntity.tableName, supplier.toMapWithoutId());

    if (id != null && id > 0) {
      return id;
    } else {
      return -1;
    }
  }

  Future<int> update(SupplierEntity supplier) async {
    int? resultUpdate = await db?.update(
        SupplierEntity.tableName, supplier.toMapWithoutId(),
        where: '${SupplierEntity.columnId} = ?',
        whereArgs: [
          supplier.id,
        ]);

    if (resultUpdate != null && resultUpdate > 0) {
      return resultUpdate;
    } else {
      return -1;
    }
  }

  Future<int> delete(SupplierEntity supplier) async {
    // int? resultDelete = await db?.delete(
    //   SupplierEntity.tableName,
    //   where: '${SupplierEntity.columnId} = ?',
    //   whereArgs: [
    //     supplier.id,
    //   ],
    // );
    int? resultDelete = await db?.update(
      SupplierEntity.tableName,
      {
        SupplierEntity.columnDeletedAt: DateTime.now().millisecondsSinceEpoch,
      },
      where: '${SupplierEntity.columnId} = ?',
      whereArgs: [
        supplier.id,
      ],
    );

    if (resultDelete != null && resultDelete > 0) {
      return resultDelete;
    } else {
      return -1;
    }
  }
}
