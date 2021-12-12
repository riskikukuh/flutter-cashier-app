import 'package:kasir_app/src/config/entity/order_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class OrderProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    await db?.execute('''
        create table ${OrderEntity.tableName} ( 
          ${OrderEntity.columnId} integer primary key autoincrement, 
          ${OrderEntity.columnDate} integer not null,
          ${OrderEntity.columnProduk} integer not null,
          ${OrderEntity.columnQuantity} integer not null)
          ''');
  }

  Future close() async => await db?.close();

  Future<List<OrderEntity>> getAllOrder() async {
    List<Map<String, Object?>>? allOrder =
        await db?.query(OrderEntity.tableName, columns: [
      OrderEntity.columnId,
      OrderEntity.columnDate,
      OrderEntity.columnProduk,
      OrderEntity.columnQuantity,
    ]);

    if (allOrder != null) {
      return allOrder.map((mapOrder) => OrderEntity.fromMap(mapOrder)).toList();
    } else {
      return List.empty(growable: false);
    }
  }

  Future<OrderEntity?> getOrderById(int orderId) async {
    List<Map<String, Object?>>? allOrder =
        await db?.query(OrderEntity.tableName,
            columns: [
              OrderEntity.columnId,
              OrderEntity.columnDate,
              OrderEntity.columnProduk,
              OrderEntity.columnQuantity,
            ],
            where: '${OrderEntity.columnId} = ?',
            whereArgs: [
              orderId,
            ]);
    if (allOrder != null && allOrder.isNotEmpty) {
      return OrderEntity.fromMap(allOrder.first);
    } else {
      return null;
    }
  }

  Future<OrderEntity?> getOrderByProdukId(int produkId) async {
    List<Map<String, Object?>>? allOrder =
        await db?.query(OrderEntity.tableName,
            columns: [
              OrderEntity.columnId,
              OrderEntity.columnDate,
              OrderEntity.columnProduk,
              OrderEntity.columnQuantity,
            ],
            where: '${OrderEntity.columnProduk} = ?',
            whereArgs: [
              produkId,
            ]);
    if (allOrder != null && allOrder.isNotEmpty) {
      return OrderEntity.fromMap(allOrder.first);
    } else {
      return null;
    }
  }

  Future<int> insert(OrderEntity order) async {
    int? id = await db?.insert(OrderEntity.tableName, order.toMapWithoutId());

    if (id != null && id > 0) {
      return id;
    } else {
      return -1;
    }
  }

  Future<int> update(OrderEntity order) async {
    int? resultUpdate = await db?.update(
        OrderEntity.tableName, order.toMapWithoutId(),
        where: '${OrderEntity.columnId} = ?',
        whereArgs: [
          order.id,
        ]);

    if (resultUpdate != null && resultUpdate > 0) {
      return resultUpdate;
    } else {
      return -1;
    }
  }

  Future<int> delete(OrderEntity order) async {
    int? resultDelete = await db?.delete(
      OrderEntity.tableName,
      where: '${OrderEntity.columnId} = ?',
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
    int? resultDeleteAll = await db?.delete(OrderEntity.tableName);
    if (resultDeleteAll != null) {
      return resultDeleteAll;
    }
    return -1;
  }
}
