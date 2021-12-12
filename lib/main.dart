import 'package:kasir_app/src/bloc/cart_bloc.dart';
import 'package:kasir_app/src/bloc/customer_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/bloc/supplier_bloc.dart';
import 'package:kasir_app/src/bloc/transaksi_bloc.dart';
import 'package:kasir_app/src/config/database/sqlite/customer_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/database_helper.dart';
import 'package:kasir_app/src/config/database/sqlite/order_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/product_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/supplier_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/transaction_order_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/transaction_provider.dart';
import 'package:kasir_app/src/dataSource/local/local_data_source.dart';
import 'package:kasir_app/src/repository/cart_repository.dart';
import 'package:kasir_app/src/repository/customer_repository.dart';
import 'package:kasir_app/src/repository/products_repository.dart';
import 'package:kasir_app/src/repository/supplier_repository.dart';
import 'package:kasir_app/src/repository/transaksi_repository.dart';
import 'package:kasir_app/src/screen/cart/cart_screen.dart';
import 'package:kasir_app/src/screen/checkout/checkout_screen.dart';
import 'package:kasir_app/src/screen/customer/customer_screen.dart';
import 'package:kasir_app/src/screen/customer/form_customer_screen.dart';
import 'package:kasir_app/src/screen/login/login_screen.dart';
import 'package:kasir_app/src/screen/produk/form_product_screen.dart';
import 'package:kasir_app/src/screen/produk/products_screen.dart';
import 'package:kasir_app/src/screen/supplier/form_supplier_screen.dart';
import 'package:kasir_app/src/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:kasir_app/src/screen/home/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/screen/supplier/supplier_screen.dart';
import 'package:kasir_app/src/screen/transaksi/transaksi_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ProductProvider productProvider = ProductProvider();
  TransaksiProvider transaksiProvider = TransaksiProvider();
  OrderProvider orderProvider = OrderProvider();
  CustomerProvider customerProvider = CustomerProvider();
  SupplierProvider supplierProvider = SupplierProvider();
  TransaksiOrderProvider transaksiOrderProvider = TransaksiOrderProvider();

  DatabaseHelper dbHelper = DatabaseHelper(
    productProvider,
    transaksiProvider,
    orderProvider,
    customerProvider,
    supplierProvider,
    transaksiOrderProvider,
  );
  await dbHelper.setup();
  LocalDataSource localDataSource = LocalDataSource(
    dbHelper: dbHelper,
  );
  ProductsRepository productsRepository = ProductsRepository(
    localDataSource: localDataSource,
  );

  CartRepository cartRepository = CartRepository(
    localDataSource: localDataSource,
  );

  CustomerRepository customerRepository = CustomerRepository(
    localDataSource: localDataSource,
  );

  SupplierRepository supplierRepository = SupplierRepository(
    localDataSource: localDataSource,
  );

  TransaksiRepository transaksiRepository = TransaksiRepository(
    localDataSource: localDataSource,
  );
  runApp(
    MyApp(
      cartRepository: cartRepository,
      productsRepository: productsRepository,
      customerRepository: customerRepository,
      supplierRepository: supplierRepository,
      transaksiRepository: transaksiRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final CartRepository cartRepository;
  final ProductsRepository productsRepository;
  final CustomerRepository customerRepository;
  final SupplierRepository supplierRepository;
  final TransaksiRepository transaksiRepository;
  const MyApp({
    Key? key,
    required this.cartRepository,
    required this.productsRepository,
    required this.customerRepository,
    required this.supplierRepository,
    required this.transaksiRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsBloc>(
          create: (BuildContext context) => ProductsBloc(
            productsRepository: productsRepository,
          ),
        ),
        BlocProvider<CartBloc>(
          create: (BuildContext context) => CartBloc(
            cartRepository: cartRepository,
          ),
        ),
        BlocProvider<CustomerBloc>(
          create: (BuildContext context) => CustomerBloc(
            customerRepository: customerRepository,
          ),
        ),
        BlocProvider(
          create: (context) => SupplierBloc(
            supplierRepository: supplierRepository,
          ),
        ),
        BlocProvider(
          create: (context) => TransaksiBloc(
            productsBloc: context.read<ProductsBloc>(),
            cartBloc: context.read<CartBloc>(),
            transaksiRepository: transaksiRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Cashier App',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/produk': (context) => const ProductsScreen(),
          '/formProduk': (context) => const FormProductScreen(),
          '/supplier': (context) => const SupplierScreen(),
          '/formSupplier': (context) => const FormSupplierScreen(),
          '/cart': (context) => CartScreen(),
          '/customer': (context) => const CustomerScreen(),
          '/formCustomer': (context) => const FormCustomerScreen(),
          '/checkout': (context) => CheckoutScreen(),
          '/transaksi': (context) => TransaksiScreen(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
