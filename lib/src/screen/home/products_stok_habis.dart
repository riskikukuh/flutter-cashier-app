import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/bloc/cartstok_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/resources/enums.dart';
import 'package:kasir_app/src/screen/produk/detail_product_screen.dart';
import 'package:kasir_app/src/widget/cart_stok_button.dart';

class ProductsStokHabisScreen extends StatelessWidget {
  ProductsStokHabisScreen({
    Key? key,
  }) : super(key: key);
  final NumberFormat _formatter = NumberFormat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Produk Stok Habis',
        ),
        actions: const [
          CartStokButton(),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(builder: (context, state) {
        if (state is ProductsLoadSuccess) {
          List<ProdukModel> allProduk =
              state.allProduk.where((produk) => produk.stok <= 5).toList();
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: allProduk.length,
            itemBuilder: (context, i) {
              ProdukModel produk = allProduk[i];
              return Card(
                child: ListTile(
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      context.read<CartstokBloc>().add(AddCartStok(
                            produk: produk,
                            quantity: 1,
                          ));
                    },
                  ),
                  leading: const Icon(Icons.shopping_bag),
                  title: Text(
                    produk.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
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
              );
            },
          );
        }
        return const Center(
          child: Text('Tidak ada produk stok yang habis'),
        );
      }),
    );
  }
}
