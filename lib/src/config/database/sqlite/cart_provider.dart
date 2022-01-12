import 'package:kasir_app/src/config/entity/cart_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class CartProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    await db?.execute('''
        create table ${CartEntity.tableName} ( 
          ${CartEntity.columnId} integer primary key autoincrement, 
          ${CartEntity.columnDate} integer not null,
          ${CartEntity.columnProduk} integer not null,
          ${CartEntity.columnQuantity} integer not null)
          ''');
  }

  Future close() async => await db?.close();

  Future<List<CartEntity>> getAllOrder() async {
    List<Map<String, Object?>>? allOrder =
        await db?.query(CartEntity.tableName, columns: [
      CartEntity.columnId,
      CartEntity.columnDate,
      CartEntity.columnProduk,
      CartEntity.columnQuantity,
    ]);

    if (allOrder != null) {
      return allOrder.map((mapOrder) => CartEntity.fromMap(mapOrder)).toList();
    } else {
      return List.empty(growable: false);
    }
  }

  Future<CartEntity?> getOrderById(int orderId) async {
    List<Map<String, Object?>>? allOrder =
        await db?.query(CartEntity.tableName,
            columns: [
              CartEntity.columnId,
              CartEntity.columnDate,
              CartEntity.columnProduk,
              CartEntity.columnQuantity,
            ],
            where: '${CartEntity.columnId} = ?',
            whereArgs: [
              orderId,
            ]);
    if (allOrder != null && allOrder.isNotEmpty) {
      return CartEntity.fromMap(allOrder.first);
    } else {
      return null;
    }
  }

  Future<CartEntity?> getOrderByProdukId(int produkId) async {
    List<Map<String, Object?>>? allOrder =
        await db?.query(CartEntity.tableName,
            columns: [
              CartEntity.columnId,
              CartEntity.columnDate,
              CartEntity.columnProduk,
              CartEntity.columnQuantity,
            ],
            where: '${CartEntity.columnProduk} = ?',
            whereArgs: [
              produkId,
            ]);
    if (allOrder != null && allOrder.isNotEmpty) {
      return CartEntity.fromMap(allOrder.first);
    } else {
      return null;
    }
  }

  Future<int> insert(CartEntity order) async {
    int? id = await db?.insert(CartEntity.tableName, order.toMapWithoutId());

    if (id != null && id > 0) {
      return id;
    } else {
      return -1;
    }
  }

  Future<int> update(CartEntity order) async {
    int? resultUpdate = await db?.update(
        CartEntity.tableName, order.toMapWithoutId(),
        where: '${CartEntity.columnId} = ?',
        whereArgs: [
          order.id,
        ]);

    if (resultUpdate != null && resultUpdate > 0) {
      return resultUpdate;
    } else {
      return -1;
    }
  }

  Future<int> delete(CartEntity order) async {
    int? resultDelete = await db?.delete(
      CartEntity.tableName,
      where: '${CartEntity.columnId} = ?',
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
    int? resultDeleteAll = await db?.delete(CartEntity.tableName);
    if (resultDeleteAll != null) {
      return resultDeleteAll;
    }
    return -1;
  }
}
