import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/bloc/cart_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/resources/enums.dart';
import 'package:kasir_app/src/resources/util.dart';
import 'package:kasir_app/src/screen/produk/detail_product_screen.dart';
import 'package:kasir_app/src/widget/cart_button.dart';
import 'package:kasir_app/src/widget/drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

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
                    const SizedBox(height: 8),
                    Card(
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
}
