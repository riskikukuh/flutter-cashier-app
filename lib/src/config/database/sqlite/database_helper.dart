import 'package:kasir_app/src/config/database/sqlite/customer_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/order_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/product_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/supplier_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/transaction_order_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/transaction_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/user_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  ProductProvider productProvider;
  TransaksiProvider transaksiProvider;
  OrderProvider orderProvider;
  CustomerProvider customerProvider;
  SupplierProvider supplierProvider;
  TransaksiOrderProvider transaksiOrderProvider;
  UserProvider userProvider;

  final int _databaseVersion = 1;

  DatabaseHelper(
    this.productProvider,
    this.transaksiProvider,
    this.orderProvider,
    this.customerProvider,
    this.supplierProvider,
    this.transaksiOrderProvider,
    this.userProvider,
  );

  Database? _database;

  Future<Database> setup() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    _setupDatabase();
    return _database!;
  }

  Future<void> _setupDatabase() async {
    await transaksiProvider.setup(_database!);
    await productProvider.setup(_database!);
    await orderProvider.setup(_database!);
    await customerProvider.setup(_database!);
    await supplierProvider.setup(_database!);
    await transaksiOrderProvider.setup(_database!);
    await userProvider.setup(_database!);
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String databaseName = 'cashierApp.db';
    String path = join(databasePath, databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await transaksiProvider.onCreate(db);
    await productProvider.onCreate(db);
    await orderProvider.onCreate(db);
    await customerProvider.onCreate(db);
    await supplierProvider.onCreate(db);
    await transaksiOrderProvider.onCreate(db);
    await userProvider.onCreate(db);
  }
}
