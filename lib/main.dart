import 'package:kasir_app/src/bloc/cart_bloc.dart';
import 'package:kasir_app/src/bloc/cartstok_bloc.dart';
import 'package:kasir_app/src/bloc/customer_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/bloc/supplier_bloc.dart';
import 'package:kasir_app/src/bloc/transaksi_bloc.dart';
import 'package:kasir_app/src/bloc/transaksistok_bloc.dart';
import 'package:kasir_app/src/bloc/user_bloc.dart';
import 'package:kasir_app/src/config/database/sqlite/cart_stok_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/customer_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/database_helper.dart';
import 'package:kasir_app/src/config/database/sqlite/detail_transaksi_stok_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/order_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/product_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/supplier_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/transaction_order_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/transaction_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/transaksi_stok_provider.dart';
import 'package:kasir_app/src/config/database/sqlite/user_provider.dart';
import 'package:kasir_app/src/config/session/session_helper.dart';
import 'package:kasir_app/src/dataSource/local/local_data_source.dart';
import 'package:kasir_app/src/repository/cart_repository.dart';
import 'package:kasir_app/src/repository/cart_stok_repository.dart';
import 'package:kasir_app/src/repository/customer_repository.dart';
import 'package:kasir_app/src/repository/products_repository.dart';
import 'package:kasir_app/src/repository/supplier_repository.dart';
import 'package:kasir_app/src/repository/transaksi_repository.dart';
import 'package:kasir_app/src/repository/transaksi_stok_repository.dart';
import 'package:kasir_app/src/repository/user_repository.dart';
import 'package:kasir_app/src/resources/enums.dart';
import 'package:kasir_app/src/screen/cart/cart_screen.dart';
import 'package:kasir_app/src/screen/cart_stok/cart_stok_screen.dart';
import 'package:kasir_app/src/screen/checkout/checkout_screen.dart';
import 'package:kasir_app/src/screen/checkout_stok/checkout_stok_screen.dart';
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
import 'package:kasir_app/src/screen/transaksi_stok/transaksi_stok_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ProductProvider productProvider = ProductProvider();
  final TransaksiProvider transaksiProvider = TransaksiProvider();
  final OrderProvider orderProvider = OrderProvider();
  final CustomerProvider customerProvider = CustomerProvider();
  final SupplierProvider supplierProvider = SupplierProvider();
  final TransaksiOrderProvider transaksiOrderProvider =
      TransaksiOrderProvider();
  final UserProvider userProvider = UserProvider();
  final TransaksiStokProvider transaksiStokProvider = TransaksiStokProvider();
  final DetailTransaksiStokProvider detailTransaksiStokProvider =
      DetailTransaksiStokProvider();
  final CartStokProvider cartStokProvider = CartStokProvider();

  final DatabaseHelper dbHelper = DatabaseHelper(
    productProvider,
    transaksiProvider,
    orderProvider,
    customerProvider,
    supplierProvider,
    transaksiOrderProvider,
    transaksiStokProvider,
    detailTransaksiStokProvider,
    userProvider,
    cartStokProvider,
  );
  await dbHelper.setup();
  final SessionHelper sessionHelper = SessionHelper();
  final LocalDataSource localDataSource = LocalDataSource(
    dbHelper: dbHelper,
    sessionHelper: sessionHelper,
  );
  final ProductsRepository productsRepository = ProductsRepository(
    localDataSource: localDataSource,
  );

  final CartRepository cartRepository = CartRepository(
    localDataSource: localDataSource,
  );

  final CustomerRepository customerRepository = CustomerRepository(
    localDataSource: localDataSource,
  );

  final SupplierRepository supplierRepository = SupplierRepository(
    localDataSource: localDataSource,
  );

  final TransaksiRepository transaksiRepository = TransaksiRepository(
    localDataSource: localDataSource,
  );

  final UserRepository userRepository = UserRepository(
    localDataSource: localDataSource,
  );

  final TransaksiStokRepository transaksiStokRepository =
      TransaksiStokRepository(
    localDataSource: localDataSource,
  );

  final CartStokRepository cartStokRepository = CartStokRepository(
    localDataSource: localDataSource,
  );

  runApp(
    MyApp(
      cartRepository: cartRepository,
      productsRepository: productsRepository,
      customerRepository: customerRepository,
      supplierRepository: supplierRepository,
      transaksiRepository: transaksiRepository,
      userRepository: userRepository,
      transaksiStokRepository: transaksiStokRepository,
      cartStokRepository: cartStokRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final CartRepository cartRepository;
  final ProductsRepository productsRepository;
  final CustomerRepository customerRepository;
  final SupplierRepository supplierRepository;
  final TransaksiRepository transaksiRepository;
  final UserRepository userRepository;
  final TransaksiStokRepository transaksiStokRepository;
  final CartStokRepository cartStokRepository;
  const MyApp({
    Key? key,
    required this.cartRepository,
    required this.productsRepository,
    required this.customerRepository,
    required this.supplierRepository,
    required this.transaksiRepository,
    required this.transaksiStokRepository,
    required this.userRepository,
    required this.cartStokRepository,
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
        BlocProvider(
          create: (context) => UserBloc(
            userRepository: userRepository,
          ),
        ),
        BlocProvider(
          create: (context) => CartstokBloc(
            cartStokRepository: cartStokRepository,
          ),
        ),
        BlocProvider(
          create: (context) => TransaksistokBloc(
            cartstokBloc: context.read<CartstokBloc>(),
            productsBloc: context.read<ProductsBloc>(),
            transaksiStokRepository: transaksiStokRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Cashier App',
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/produk': (context) => ProductsScreen(),
          '/produkStok': (context) => ProductsScreen(priceType: ProductsPriceType.stok,),
          '/formProduk': (context) => const FormProductScreen(),
          '/supplier': (context) => const SupplierScreen(),
          '/formSupplier': (context) => const FormSupplierScreen(),
          '/cart': (context) => CartScreen(),
          '/cartStok': (context) => CartStokScreen(),
          '/customer': (context) => const CustomerScreen(),
          '/formCustomer': (context) => const FormCustomerScreen(),
          '/checkout': (context) => CheckoutScreen(),
          '/checkoutStok': (context) => CheckoutStokScreen(),
          '/transaksi': (context) => TransaksiScreen(),
          '/transaksiStok': (context) => TransaksiStokScreen(),
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
