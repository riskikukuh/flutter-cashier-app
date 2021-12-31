import 'package:kasir_app/src/config/entity/cart_stok_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class CartStokProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    await db?.execute('''
        create table ${CartStokEntity.tableName} ( 
          ${CartStokEntity.columnId} integer primary key autoincrement, 
          ${CartStokEntity.columnDate} integer not null,
          ${CartStokEntity.columnProduk} integer not null,
          ${CartStokEntity.columnQuantity} integer not null)
          ''');
  }

  Future close() async => await db?.close();

  Future<List<CartStokEntity>> getAllCartStok() async {
    List<Map<String, Object?>>? allOrder =
        await db?.query(CartStokEntity.tableName, columns: [
      CartStokEntity.columnId,
      CartStokEntity.columnDate,
      CartStokEntity.columnProduk,
      CartStokEntity.columnQuantity,
    ]);

    if (allOrder != null) {
      return allOrder.map((mapOrder) => CartStokEntity.fromMap(mapOrder)).toList();
    } else {
      return List.empty(growable: false);
    }
  }

  Future<CartStokEntity?> getOrderById(int orderId) async {
    List<Map<String, Object?>>? allOrder =
        await db?.query(CartStokEntity.tableName,
            columns: [
              CartStokEntity.columnId,
              CartStokEntity.columnDate,
              CartStokEntity.columnProduk,
              CartStokEntity.columnQuantity,
            ],
            where: '${CartStokEntity.columnId} = ?',
            whereArgs: [
              orderId,
            ]);
    if (allOrder != null && allOrder.isNotEmpty) {
      return CartStokEntity.fromMap(allOrder.first);
    } else {
      return null;
    }
  }

  Future<CartStokEntity?> getOrderByProdukId(int produkId) async {
    List<Map<String, Object?>>? allOrder =
        await db?.query(CartStokEntity.tableName,
            columns: [
              CartStokEntity.columnId,
              CartStokEntity.columnDate,
              CartStokEntity.columnProduk,
              CartStokEntity.columnQuantity,
            ],
            where: '${CartStokEntity.columnProduk} = ?',
            whereArgs: [
              produkId,
            ]);
    if (allOrder != null && allOrder.isNotEmpty) {
      return CartStokEntity.fromMap(allOrder.first);
    } else {
      return null;
    }
  }

  Future<int> insert(CartStokEntity order) async {
    int? id = await db?.insert(CartStokEntity.tableName, order.toMapWithoutId());

    if (id != null && id > 0) {
      return id;
    } else {
      return -1;
    }
  }

  Future<int> update(CartStokEntity order) async {
    int? resultUpdate = await db?.update(
        CartStokEntity.tableName, order.toMapWithoutId(),
        where: '${CartStokEntity.columnId} = ?',
        whereArgs: [
          order.id,
        ]);

    if (resultUpdate != null && resultUpdate > 0) {
      return resultUpdate;
    } else {
      return -1;
    }
  }

  Future<int> delete(CartStokEntity order) async {
    int? resultDelete = await db?.delete(
      CartStokEntity.tableName,
      where: '${CartStokEntity.columnId} = ?',
      whereArgs: [
        order.id,
      ],
    );

    if (resultDelete != null && resultDelete > 0) {
      return resultDelete;
    } else {
      return -1;
    }
  }

  Future<int> deleteAll() async {
    int? resultDeleteAll = await db?.delete(CartStokEntity.tableName);
    if (resultDeleteAll != null) {
      return resultDeleteAll;
    }
    return -1;
  }
}
