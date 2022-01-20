import 'package:kasir_app/src/config/entity/customer_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class CustomerProvider {
  Database? db;

  setup(Database db) {
    this.db = db;
  }

  Future onCreate(Database? db) async {
    await db?.execute('''
        create table ${CustomerEntity.tableName} ( 
          ${CustomerEntity.columnId} integer primary key autoincrement, 
          ${CustomerEntity.columnNama} text not null,
          ${CustomerEntity.columnJk} text not null,
          ${CustomerEntity.columnNoTelp} text not null,
          ${CustomerEntity.columnAlamat} text not null,
          ${CustomerEntity.columnDeletedAt} integer)
          ''');

    await db?.insert(
        CustomerEntity.tableName,
        CustomerEntity(nama: 'guest', jk: 'P', alamat: 'guest', noTelp: 'guest')
            .toMapWithoutId());
  }

  Future close() async => await db?.close();

  Future<List<CustomerEntity>> getAllCustomer() async {
    List<Map<String, Object?>>? allCustomer = await db?.query(
      CustomerEntity.tableName,
      columns: [
        CustomerEntity.columnId,
        CustomerEntity.columnNama,
        CustomerEntity.columnJk,
        CustomerEntity.columnNoTelp,
        CustomerEntity.columnAlamat,
      ],
      where: '${CustomerEntity.columnDeletedAt} IS NULL',
    );

    if (allCustomer != null) {
      return allCustomer
          .map((mapCustomer) => CustomerEntity.fromMap(mapCustomer))
          .toList();
    } else {
      return List.empty(growable: false);
    }
  }

  Future<CustomerEntity?> getCustomerById(int customerId) async {
    List<Map<String, Object?>>? allCustomer = await db?.query(
      CustomerEntity.tableName,
      columns: [
        CustomerEntity.columnId,
        CustomerEntity.columnNama,
        CustomerEntity.columnJk,
        CustomerEntity.columnNoTelp,
        CustomerEntity.columnAlamat,
      ],
      where: '${CustomerEntity.columnDeletedAt} IS NULL AND ${CustomerEntity.columnId} = ?',
      whereArgs: [
        customerId,
      ],
    );
    if (allCustomer != null && allCustomer.isNotEmpty) {
      return CustomerEntity.fromMap(allCustomer.first);
    } else {
      return null;
    }
  }

  Future<int> insert(CustomerEntity customer) async {
    int? id =
        await db?.insert(CustomerEntity.tableName, customer.toMapWithoutId());

    if (id != null && id > 0) {
      return id;
    } else {
      return -1;
    }
  }

  Future<int> update(CustomerEntity customer) async {
    int? resultUpdate = await db?.update(
        CustomerEntity.tableName, customer.toMapWithoutId(),
        where: '${CustomerEntity.columnId} = ?',
        whereArgs: [
          customer.id,
        ]);

    if (resultUpdate != null && resultUpdate > 0) {
      return resultUpdate;
    } else {
      return -1;
    }
  }

  Future<int> delete(CustomerEntity customer) async {
    int? resultDelete = await db?.update(
      CustomerEntity.tableName,
      {
        CustomerEntity.columnDeletedAt: DateTime.now().millisecondsSinceEpoch,
      },
      where: '${CustomerEntity.columnId} = ?',
      whereArgs: [
        customer.id,
      ],
    );
    if (resultDelete != null && resultDelete > 0) {
      return resultDelete;
    }
    return -1;
  }
}
