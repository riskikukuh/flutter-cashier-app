import 'package:kasir_app/src/config/entity/produk_entity.dart';
import 'package:sqflite/sqflite.dart';

class ProductProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    await db?.execute('''
        create table ${ProdukEntity.tableName} ( 
          ${ProdukEntity.columnId} integer primary key autoincrement, 
          ${ProdukEntity.columnNama} text not null,
          ${ProdukEntity.columnHargaJual} integer default 0 not null,
          ${ProdukEntity.columnHargaStok} integer default 0 not null,
          ${ProdukEntity.columnStok} integer default 0 not null,
          ${ProdukEntity.columnSupplier} integer, 
          ${ProdukEntity.columnDeletedAt} integer)
          ''');
  }

  Future close() async => await db?.close();

  Future<List<ProdukEntity>> getProduk() async {
    List<Map<String, Object?>>? allProduk = await db?.query(
      ProdukEntity.tableName,
      columns: [
        ProdukEntity.columnId,
        ProdukEntity.columnNama,
        ProdukEntity.columnHargaJual,
        ProdukEntity.columnHargaStok,
        ProdukEntity.columnStok,
        ProdukEntity.columnSupplier,
        ProdukEntity.columnDeletedAt,
      ],
      where: '${ProdukEntity.columnDeletedAt} IS NULL',
    );
    if (allProduk != null) {
      return allProduk
          .map((mapProduk) => ProdukEntity.fromMap(mapProduk))
          .toList();
    } else {
      return List.empty(growable: false);
    }
  }

  Future<ProdukEntity?> getProdukById(int id) async {
    List<Map<String, Object?>>? responseProduk = await db?.query(
      ProdukEntity.tableName,
      columns: [
        ProdukEntity.columnId,
        ProdukEntity.columnNama,
        ProdukEntity.columnHargaJual,
        ProdukEntity.columnHargaStok,
        ProdukEntity.columnStok,
        ProdukEntity.columnSupplier,
      ],
      where: '${ProdukEntity.columnDeletedAt} IS NULL AND ${ProdukEntity.columnId} = ?',
      whereArgs: [id],
    );

    if (responseProduk != null && responseProduk.isNotEmpty) {
      return ProdukEntity.fromMap(responseProduk.first);
    } else {
      return null;
    }
  }

  Future<int> insert(ProdukEntity produk) async {
    int? id = await db?.insert(ProdukEntity.tableName, produk.toMapWithoutId());

    if (id != null && id > 0) {
      return id;
    } else {
      return -1;
    }
  }

  Future<int> update(ProdukEntity produk) async {
    int? count = await db?.update(
        ProdukEntity.tableName, produk.toMapWithoutId(),
        where: '${ProdukEntity.columnId} = ?', whereArgs: [produk.id]);
    if (count != null && count > 0) {
      return count;
    }
    return -1;
  }

  Future<int> delete(int id) async {
    int? deleteResult = await db?.update(
      ProdukEntity.tableName,
      {
        ProdukEntity.columnDeletedAt: DateTime.now().millisecondsSinceEpoch,
      },
      where: '${ProdukEntity.columnId} = ?',
      whereArgs: [
        id,
      ],
    );
    if (deleteResult != null && deleteResult > 0) {
      return deleteResult;
    }
    return -1;
  }

  Future<bool> verifyStok(int produkId, int qty) async {
    List<Map<String, Object?>>? result = await db?.query(
      ProdukEntity.tableName,
      columns: [
        ProdukEntity.columnStok,
      ],
      where: '${ProdukEntity.columnId} = ?',
      whereArgs: [produkId],
    );

    if (result != null) {
      int? stok = result.first[ProdukEntity.columnStok] as int?;
      if (stok != null && stok - qty >= 0) {
        return true;
      }
    }

    throw Exception('Stok tidak mencukupi');
  }
}
