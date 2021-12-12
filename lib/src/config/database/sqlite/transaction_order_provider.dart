import 'package:kasir_app/src/config/entity/transaksi_order_entity.dart';
import 'package:sqflite/sqflite.dart';

class TransaksiOrderProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    this.db = db;
    await db?.execute('''
        create table ${TransaksiOrderEntity.tableName} (
          ${TransaksiOrderEntity.columnId} integer primary key autoincrement,
          ${TransaksiOrderEntity.columnIdTransaksi} integer not null,
          ${TransaksiOrderEntity.columnIdProduk} integer not null,
          ${TransaksiOrderEntity.columnQuantity} integer not null
        )''');
  }

  Future close() async => await db?.close();

  Future<List<TransaksiOrderEntity>> getAllOrderByTransaksiId(
      int transaksiId) async {
    List<Map<String, Object?>>? resultAllOrderByTransaksiId = await db?.query(
      TransaksiOrderEntity.tableName,
      columns: [
        TransaksiOrderEntity.columnId,
        TransaksiOrderEntity.columnIdProduk,
        TransaksiOrderEntity.columnQuantity,
      ],
      where: '${TransaksiOrderEntity.columnIdTransaksi} = ?',
      whereArgs: [
        transaksiId,
      ],
    );
    if (resultAllOrderByTransaksiId != null) {
      return resultAllOrderByTransaksiId
          .map((transaksiOrder) => TransaksiOrderEntity.fromMap(transaksiOrder))
          .toList();
    } else {
      return [];
    }
  }

  Future<int> insert(TransaksiOrderEntity transaksiOrder) async {
    int? resultInsert = await db?.insert(
        TransaksiOrderEntity.tableName, transaksiOrder.toMapWithoutId());
    if (resultInsert != null && resultInsert > 0) {
      return resultInsert;
    } else {
      return -1;
    }
  }

  Future<int> editTransaksiOrder(TransaksiOrderEntity transaksiOrder) async {
    int? resultUpdate = await db?.update(
        TransaksiOrderEntity.tableName, transaksiOrder.toMap());
    if (resultUpdate != null && resultUpdate > 0) {
      return resultUpdate;
    } else {
      return -1;
    }
  }

  Future<bool> deleteTransaksiOrder(TransaksiOrderEntity transaksiOrder) async {
    int? resultDelete = await db?.delete(
      TransaksiOrderEntity.tableName,
      where: '${TransaksiOrderEntity.columnId} = ?',
      whereArgs: [
        transaksiOrder.id,
      ],
    );
    if (resultDelete != null && resultDelete > 0) {
      return true;
    } else {
      return false;
    }
  }
}
