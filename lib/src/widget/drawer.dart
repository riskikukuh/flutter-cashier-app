import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/customer_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/bloc/supplier_bloc.dart';
import 'package:kasir_app/src/bloc/transaksi_bloc.dart';
import 'package:kasir_app/src/bloc/user_bloc.dart';
import 'package:kasir_app/src/resources/util.dart';

class CashierDrawer extends StatelessWidget {
  const CashierDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
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
          BlocBuilder<TransaksiBloc, TransaksiState>(
            builder: (context, state) {
              String countCustomer = '0';
              if (state is TransaksiLoadSuccess) {
                countCustomer = state.allTransaksi.length.toString();
              }
              return ListTile(
                title: const Text('Transaksi'),
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
              leading: const Icon(Icons.logout),
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
