import 'package:kasir_app/src/config/database/sqlite/cart_stok_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/customer_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/detail_transaksi_stok_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/cart_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/product_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/supplier_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/detail_transaction_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/transaction_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/transaksi_stok_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/user_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  ProductProvider productProvider;
  TransaksiProvider transaksiProvider;
  CartProvider orderProvider;
  CustomerProvider customerProvider;
  SupplierProvider supplierProvider;
  DetailTransaksiProvider transaksiOrderProvider;
  UserProvider userProvider;
  TransaksiStokProvider transaksiStokProvider;
  DetailTransaksiStokProvider detailTransaksiStokProvider;
  CartStokProvider cartStokProvider;

  final int _databaseVersion = 1;

  DatabaseHelper(
    this.productProvider,
    this.transaksiProvider,
    this.orderProvider,
    this.customerProvider,
    this.supplierProvider,
    this.transaksiOrderProvider,
    this.transaksiStokProvider,
    this.detailTransaksiStokProvider,
    this.userProvider,
    this.cartStokProvider,
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
    await transaksiStokProvider.setup(_database!);
    await detailTransaksiStokProvider.setup(_database!);
    await cartStokProvider.setup(_database!);
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
    await transaksiStokProvider.onCreate(db);
    await detailTransaksiStokProvider.onCreate(db);
    await userProvider.onCreate(db);
    await cartStokProvider.onCreate(db);
  }
}
