import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/resources/util.dart';
import 'package:kasir_app/src/screen/produk/detail_product_screen.dart';
import 'package:kasir_app/src/widget/cart_button.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  Widget _mapProductStateToWidget(ProductsState state) {
    switch (state.runtimeType) {
      case ProductsLoading:
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.2),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const CircularProgressIndicator(),
          ),
        );
      case ProductsLoadSuccess:
        ProductsLoadSuccess newState = state as ProductsLoadSuccess;
        if (newState.allProduk.isEmpty) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            child: const Text(
              'Produk kosong',
            ),
          );
        }
        return GridView.builder(
          itemCount: newState.allProduk.length,
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 4,
            mainAxisExtent: 240,
          ),
          itemBuilder: (context, i) {
            ProdukModel produk = newState.allProduk[i];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (contxet) => DetailProductScreen(
                          produk: produk,
                        )));
              },
              child: Card(
                elevation: 4,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        padding: const EdgeInsets.fromLTRB(5, 12, 5, 12),
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(4.5)),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Icon(
                                Icons.ac_unit,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rp ' + produk.formatHarga(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    produk.nama,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    textWidthBasis: TextWidthBasis.parent,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Sisa ' + produk.stok.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      case ProductsError:
        state as ProductsError;
        return Text(state.message);
      default:
        return const Text(
          'Gagal mengambil produk',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Produk',
        ),
        actions: [
          const CartButton(),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/formProduk');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocConsumer<ProductsBloc, ProductsState>(
            listener: (context, state) {
              if (state is ProductsMessage) {
                Util.showSnackbar(context, state.message);
              }
            },
            builder: (context, state) {
              return _mapProductStateToWidget(state);
            },
          ),
        ],
      ),
    );
  }
}
