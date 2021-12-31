import 'package:kasir_app/src/config/entity/transaksi_stok_entity.dart';
import 'package:sqflite/sqflite.dart';

class TransaksiStokProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    await db?.execute('''
        create table ${TransaksiStokEntity.tableName} ( 
          ${TransaksiStokEntity.columnId} integer primary key, 
          ${TransaksiStokEntity.columnTanggal} integer not null,
          ${TransaksiStokEntity.columnKeterangan} text,
          ${TransaksiStokEntity.columnPrice} integer not null)
          ''');
  }

  Future close() async => await db?.close();

  Future<List<TransaksiStokEntity>> getAllTransaksi() async {
    List<Map<String, Object?>>? allTransaksi = await db?.query(
      TransaksiStokEntity.tableName,
      columns: [
        TransaksiStokEntity.columnId,
        TransaksiStokEntity.columnTanggal,
        TransaksiStokEntity.columnKeterangan,
        TransaksiStokEntity.columnPrice,
      ],
    );

    if (allTransaksi != null) {
      return allTransaksi
          .map((transaksi) => TransaksiStokEntity.fromMap(transaksi))
          .toList();
    }

    return [];
  }

  Future<int> insert(TransaksiStokEntity transaksi) async {
    int? idTransaksi = await db?.insert(
      TransaksiStokEntity.tableName,
      transaksi.toMapWithoutId(),
    );

    if (idTransaksi != null) {
      return idTransaksi;
    }

    return -1;
  }

  Future<int> update(TransaksiStokEntity transaksi) async {
    int? countUpdated = await db?.update(
      TransaksiStokEntity.tableName,
      transaksi.toMapWithoutId(),
      where: '${TransaksiStokEntity.columnId} = ?',
      whereArgs: [
        transaksi.id,
      ],
    );

    if (countUpdated != null) {
      return countUpdated;
    }

    return -1;
  }

  Future<int> delete(int id) async {
    int? deleteResult = await db?.delete(
      TransaksiStokEntity.tableName,
      where: '${TransaksiStokEntity.columnId} = ?',
      whereArgs: [id],
    );

    if (deleteResult != null && deleteResult > 0) {
      return deleteResult;
    }

    return -1;
  }
}
