import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/bloc/transaksi_bloc.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/models/transaksi_model.dart';
import 'package:kasir_app/src/resources/enums.dart';
import 'package:kasir_app/src/screen/produk/detail_product_screen.dart';
import 'package:kasir_app/src/widget/cart_button.dart';
import 'package:kasir_app/src/widget/drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _now = DateTime.now();
  final NumberFormat _formatter = NumberFormat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
        actions: const [
          CartButton(),
        ],
      ),
      drawer: const CashierDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          BlocBuilder<TransaksiBloc, TransaksiState>(
            builder: (context, state) {
              if (state is TransaksiLoadSuccess) {
                return showDashboardTransaksi(state.allTransaksi);
              }
              return const SizedBox();
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoadSuccess) {
                List<ProdukModel> allProduk =
                    state.allProduk.where((produk) => produk.stok < 5).toList();
                if (allProduk.isEmpty) return const SizedBox();
                ProdukModel produk = allProduk.first;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${allProduk.length} Produk stok akan habis',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        allProduk.length > 1
                            ? InkWell(
                                child: const Text(
                                  'Lihat Lainnya',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/productsStokHabis',
                                    arguments: allProduk,
                                  );
                                },
                              )
                            : const SizedBox(),
                      ],
                    ),
                    Card(
                      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: ListTile(
                        leading: const Icon(Icons.shopping_bag),
                        title: Text(
                          produk.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(16, 10, 16, 8),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Rp' + _formatter.format(produk.hargaStok),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sisa ' + produk.stok.toString(),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (contxet) => DetailProductScreen(
                                    produk: produk,
                                    priceType: ProductsPriceType.stok,
                                  )));
                        },
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget showDashboardTransaksi(List<TransaksiModel> allTransaksi) {
    List<TransaksiModel> dailyTransaksi = [];
    List<TransaksiModel> weeklyTransaksi = [];
    List<TransaksiModel> monthlyTransaksi = [];

    DateTime startDay = DateTime(_now.year, _now.month, _now.day);
    DateTime endDay =
        DateTime(_now.year, _now.month, _now.day).add(const Duration(days: 1));

    DateTime endWeek = (_now.day + 7 - _now.weekday <=
            DateUtils.getDaysInMonth(_now.year, _now.month))
        ? DateTime(_now.year, _now.month, _now.day + 7 - _now.weekday, 24)
        : DateTime(_now.year, _now.month + 1,
            (_now.day + 7 - _now.weekday) - _now.day);
    DateTime startWeek = endWeek.add(const Duration(days: -7));

    DateTime startMonth = DateTime(_now.year, _now.month, 1);
    DateTime endMonth = DateTime(_now.year, _now.month,
        DateUtils.getDaysInMonth(_now.year, _now.month), 24);

    for (TransaksiModel transaksi in allTransaksi) {
      if (transaksi.tanggal >= startMonth.millisecondsSinceEpoch &&
          transaksi.tanggal <= endMonth.millisecondsSinceEpoch) {
        monthlyTransaksi.add(transaksi);
      }
      if (transaksi.tanggal >= startWeek.millisecondsSinceEpoch &&
          transaksi.tanggal <= endWeek.millisecondsSinceEpoch) {
        weeklyTransaksi.add(transaksi);
      }
      if (transaksi.tanggal > startDay.millisecondsSinceEpoch &&
          transaksi.tanggal < endDay.millisecondsSinceEpoch) {
        dailyTransaksi.add(transaksi);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Transaksi Hari Ini',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  dailyTransaksi.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Transaksi Minggu Ini',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  weeklyTransaksi.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Transaksi Bulan Ini',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  monthlyTransaksi.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
