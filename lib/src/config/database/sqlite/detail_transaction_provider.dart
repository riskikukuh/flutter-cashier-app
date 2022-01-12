import 'package:kasir_app/src/config/entity/detail_transaksi_entity.dart';
import 'package:sqflite/sqflite.dart';

class DetailTransaksiProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    this.db = db;
    await db?.execute('''
        create table ${DetailTransaksiEntity.tableName} (
          ${DetailTransaksiEntity.columnId} integer primary key autoincrement,
          ${DetailTransaksiEntity.columnIdTransaksi} integer not null,
          ${DetailTransaksiEntity.columnIdProduk} integer not null,
          ${DetailTransaksiEntity.columnQuantity} integer not null
        )''');
  }

  Future close() async => await db?.close();

  Future<List<DetailTransaksiEntity>> getAllOrderByTransaksiId(
      int transaksiId) async {
    List<Map<String, Object?>>? resultAllOrderByTransaksiId = await db?.query(
      DetailTransaksiEntity.tableName,
      columns: [
        DetailTransaksiEntity.columnId,
        DetailTransaksiEntity.columnIdProduk,
        DetailTransaksiEntity.columnQuantity,
      ],
      where: '${DetailTransaksiEntity.columnIdTransaksi} = ?',
      whereArgs: [
        transaksiId,
      ],
    );
    if (resultAllOrderByTransaksiId != null) {
      return resultAllOrderByTransaksiId
          .map((transaksiOrder) => DetailTransaksiEntity.fromMap(transaksiOrder))
          .toList();
    } else {
      return [];
    }
  }

  Future<int> insert(DetailTransaksiEntity transaksiOrder) async {
    int? resultInsert = await db?.insert(
        DetailTransaksiEntity.tableName, transaksiOrder.toMapWithoutId());
    if (resultInsert != null && resultInsert > 0) {
      return resultInsert;
    } else {
      return -1;
    }
  }

  Future<int> editTransaksiOrder(DetailTransaksiEntity transaksiOrder) async {
    int? resultUpdate = await db?.update(
        DetailTransaksiEntity.tableName, transaksiOrder.toMap());
    if (resultUpdate != null && resultUpdate > 0) {
      return resultUpdate;
    } else {
      return -1;
    }
  }

  Future<bool> deleteTransaksiOrder(DetailTransaksiEntity transaksiOrder) async {
    int? resultDelete = await db?.delete(
      DetailTransaksiEntity.tableName,
      where: '${DetailTransaksiEntity.columnId} = ?',
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
