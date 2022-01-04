import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/cart_bloc.dart';
import 'package:kasir_app/src/bloc/cartstok_bloc.dart';
import 'package:kasir_app/src/bloc/customer_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/bloc/supplier_bloc.dart';
import 'package:kasir_app/src/bloc/transaksi_bloc.dart';
import 'package:kasir_app/src/bloc/transaksistok_bloc.dart';
import 'package:kasir_app/src/bloc/user_bloc.dart';
import 'package:kasir_app/src/resources/enums.dart';
import 'package:kasir_app/src/resources/util.dart';
import 'package:kasir_app/src/screen/report/report_transaction.dart';
import 'package:kasir_app/src/screen/report/report_date_picker.dart';

class CashierDrawer extends StatelessWidget {
  const CashierDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Cashier Apps',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              int countProduk = 0;
              if (state is ProductsLoadSuccess) {
                countProduk = state.allProduk.length;
              }
              return ListTile(
                title: const Text('Produk'),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    countProduk.toString(),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/produk');
                },
              );
            },
          ),
          BlocBuilder<SupplierBloc, SupplierState>(
            builder: (context, state) {
              int countSupplier = 0;
              if (state is SupplierLoadSuccess) {
                countSupplier = state.allSupplier.length;
              }
              return ListTile(
                title: const Text('Supplier'),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    countSupplier.toString(),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/supplier');
                },
              );
            },
          ),
          BlocBuilder<CustomerBloc, CustomerState>(
            builder: (context, state) {
              String countCustomer = '';
              if (state is CustomerLoadSuccess) {
                countCustomer = state.allCustomer.length.toString();
              }
              return ListTile(
                title: const Text('Customer'),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    countCustomer.toString(),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/customer');
                },
              );
            },
          ),
          const Divider(),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              String countCustomer = '0';
              if (state is CartFetched) {
                countCustomer = state.order.length.toString();
              }
              return ListTile(
                title: const Text('Keranjang Pembelian'),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    countCustomer.toString(),
                  ),
                ),
                onTap: () {
                  context.read<CartBloc>().add(GetAllCart());
                  Navigator.of(context).pushNamed('/cart');
                },
              );
            },
          ),
          BlocBuilder<CartstokBloc, CartstokState>(
            builder: (context, state) {
              String countCustomer = '0';
              if (state is CartStokLoadSuccess) {
                countCustomer = state.cartStok.length.toString();
              }
              return ListTile(
                title: const Text('Keranjang Stok'),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    countCustomer.toString(),
                  ),
                ),
                onTap: () {
                  context.read<CartstokBloc>().add(GetAllCartStok());
                  Navigator.of(context).pushNamed('/cartStok');
                },
              );
            },
          ),
          const Divider(),
          BlocBuilder<TransaksiBloc, TransaksiState>(
            builder: (context, state) {
              String countCustomer = '0';
              if (state is TransaksiLoadSuccess) {
                countCustomer = state.allTransaksi.length.toString();
              }
              return ListTile(
                title: const Text('Transaksi Pembelian'),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    countCustomer.toString(),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/transaksi');
                },
              );
            },
          ),
          BlocBuilder<TransaksistokBloc, TransaksistokState>(
            builder: (context, state) {
              String countCustomer = '0';
              if (state is TransaksiStokLoadSuccess) {
                countCustomer = state.allTransaksiStok.length.toString();
              }
              return ListTile(
                title: const Text('Transaksi Stok'),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    countCustomer.toString(),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/transaksiStok');
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Laporan Transaksi Penjualan'),
            onTap: () {
              Navigator.of(context).pushNamed('/reportTransactionScreen',
                  arguments: ReportDatePickerType.transaksi);
            },
          ),
          ListTile(
            title: const Text('Laporan Laba Rugi'),
            onTap: () {
              Navigator.of(context).pushNamed('/reportTransactionScreen',
                  arguments: ReportDatePickerType.labaRugi);
            },
          ),
          const Divider(),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is NotLoggedIn) {
                Util.showSnackbar(context, 'Berhasil melakukan logout');
                Navigator.of(context).pushReplacementNamed('/login');
              } else if (state is UserError) {
                Util.showSnackbar(context, state.message);
              }
            },
            child: ListTile(
              title: const Text('Logout'),
              // leading: const Icon(Icons.logout),
              onTap: () {
                context.read<UserBloc>().add(Logout());
              },
            ),
          ),
        ],
      ),
    );
  }
}
