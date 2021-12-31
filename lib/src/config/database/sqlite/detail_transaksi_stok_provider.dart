import 'package:kasir_app/src/config/entity/detail_transaksi_stok_entity.dart';
import 'package:sqflite/sqflite.dart';

class DetailTransaksiStokProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    await db?.execute('''
        create table ${DetailTransaksiStokEntity.tableName} ( 
          ${DetailTransaksiStokEntity.columnId} integer primary key, 
          ${DetailTransaksiStokEntity.columnIdTransaksiStok} integer not null,
          ${DetailTransaksiStokEntity.columnIdProduk} integer not null,
          ${DetailTransaksiStokEntity.columnQuantity} integer not null)
          ''');
  }

  Future close() async => await db?.close();

  Future<List<DetailTransaksiStokEntity>> getAllDetailTransaksiStok() async {
    List<Map<String, Object?>>? allTransaksi = await db?.query(
      DetailTransaksiStokEntity.tableName,
      columns: [
        DetailTransaksiStokEntity.columnId,
        DetailTransaksiStokEntity.columnIdTransaksiStok,
        DetailTransaksiStokEntity.columnIdProduk,
        DetailTransaksiStokEntity.columnQuantity,
      ],
    );

    if (allTransaksi != null) {
      return allTransaksi
          .map((transaksi) => DetailTransaksiStokEntity.fromMap(transaksi))
          .toList();
    }

    return [];
  }

  Future<List<DetailTransaksiStokEntity>> getDetailTransaksiByIdTransaksiStok(
      int idTransaksiStok) async {
    List<Map<String, Object?>>? allTransaksi = await db?.query(
      DetailTransaksiStokEntity.tableName,
      columns: [
        DetailTransaksiStokEntity.columnId,
        DetailTransaksiStokEntity.columnIdTransaksiStok,
        DetailTransaksiStokEntity.columnIdProduk,
        DetailTransaksiStokEntity.columnQuantity,
      ],
      where: '${DetailTransaksiStokEntity.columnIdTransaksiStok} = ?',
      whereArgs: [
        idTransaksiStok,
      ],
    );

    if (allTransaksi != null) {
      return allTransaksi
          .map((transaksi) => DetailTransaksiStokEntity.fromMap(transaksi))
          .toList();
    }

    return [];
  }

  Future<int> insert(DetailTransaksiStokEntity transaksi) async {
    int? idTransaksi = await db?.insert(
      DetailTransaksiStokEntity.tableName,
      transaksi.toMapWithoutId(),
    );

    if (idTransaksi != null) {
      return idTransaksi;
    }

    return -1;
  }

  Future<int> update(DetailTransaksiStokEntity transaksi) async {
    int? countUpdated = await db?.update(
      DetailTransaksiStokEntity.tableName,
      transaksi.toMapWithoutId(),
      where: '${DetailTransaksiStokEntity.columnId} = ?',
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
      DetailTransaksiStokEntity.tableName,
      where: '${DetailTransaksiStokEntity.columnId} = ?',
      whereArgs: [id],
    );

    if (deleteResult != null && deleteResult > 0) {
      return deleteResult;
    }

    return -1;
  }
}
