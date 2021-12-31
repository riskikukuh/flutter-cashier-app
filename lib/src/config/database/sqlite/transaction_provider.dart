import 'package:kasir_app/src/config/entity/transaksi_entity.dart';
import 'package:sqflite/sqflite.dart';

class TransaksiProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    await db?.execute('''
        create table ${TransaksiEntity.tableName} ( 
          ${TransaksiEntity.columnId} integer primary key, 
          ${TransaksiEntity.columnIdPembeli} integer not null,
          ${TransaksiEntity.columnTanggal} integer not null,
          ${TransaksiEntity.columnKeterangan} text,
          ${TransaksiEntity.columnPrice} integer not null)
          ''');

    // await db?.execute('''
    //     create table $tableTransaksiProduk (
    //       $columnIdTransaksiProduk integer primary key autoincrement,
    //       $columnIdTransaksi integer not null,
    //       $columnIdProduk integer not null)
    //       ''');
  }

  Future close() async => await db?.close();

  Future<List<TransaksiEntity>> getAllTransaksi() async {
    List<Map<String, Object?>>? allTransaksi = await db?.query(
      TransaksiEntity.tableName,
      columns: [
        TransaksiEntity.columnId,
        TransaksiEntity.columnIdPembeli,
        TransaksiEntity.columnTanggal,
        TransaksiEntity.columnKeterangan,
        TransaksiEntity.columnPrice,
      ],
    );

    if (allTransaksi != null) {
      return allTransaksi
          .map((transaksi) => TransaksiEntity.fromMap(transaksi))
          .toList();
    }

    return [];
  }

  Future<int> insert(TransaksiEntity transaksi) async {
    int? idTransaksi = await db?.insert(
      TransaksiEntity.tableName,
      transaksi.toMapWithoutId(),
    );

    if (idTransaksi != null) {
      return idTransaksi;
    }

    return -1;
  }

  Future<int> update(TransaksiEntity transaksi) async {
    int? countUpdated = await db?.update(
      TransaksiEntity.tableName,
      transaksi.toMapWithoutId(),
      where: '${TransaksiEntity.columnId} = ?',
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
      TransaksiEntity.tableName,
      where: '${TransaksiEntity.columnId} = ?',
      whereArgs: [id],
    );

    if (deleteResult != null && deleteResult > 0) {
      return deleteResult;
    }

    return -1;
  }

  // Future<int?> addTransaksiProduk(ProdukEntity produk) async {
  //   int? result = await db?.insert(tableTransaksiProduk, {
  //     columnIdTransaksiProduk: produk.id,
  //   });

  //   return result;
  // }
}
