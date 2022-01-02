import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_app/src/bloc/filteredproducts_bloc.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/resources/enums.dart';
import 'package:kasir_app/src/screen/produk/detail_product_screen.dart';

class SearchProductsScreen extends SearchDelegate {
  final ProductsPriceType priceType;
  final NumberFormat _formatter = NumberFormat();
  SearchProductsScreen({
    this.priceType = ProductsPriceType.jual,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text(
              "Keyword harus minimal 3 huruf",
            ),
          )
        ],
      );
    }
    context.read<FilteredproductsBloc>().add(SearchProducts(keyword: query));
    return BlocBuilder<FilteredproductsBloc, FilteredproductsState>(
      builder: (context, state) {
        if (state is FilteredProductsLoadSuccess) {
          if (state.allProduk.isEmpty) {
            return const Center(
              child: Text('Produk tidak ditemukan'),
            );
          }
          return viewProducts(context, state.allProduk);
        }
        return const SizedBox();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text(
              "Keyword harus minimal 3 huruf",
            ),
          )
        ],
      );
    }
    context.read<FilteredproductsBloc>().add(SearchProducts(keyword: query));
    return BlocBuilder<FilteredproductsBloc, FilteredproductsState>(
      builder: (context, state) {
        if (state is FilteredProductsLoadSuccess) {
          if (state.allProduk.isEmpty) {
            return const Center(
              child: Text('Produk tidak ditemukan'),
            );
          }
          return viewProducts(context, state.allProduk);
        }
        return const SizedBox();
      },
    );
  }

  Widget viewProducts(BuildContext context, List<ProdukModel> allProduk) {
    return GridView(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 4,
        mainAxisExtent: 240,
      ),
      children: [
        for (ProdukModel produk in allProduk)
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (contxet) => DetailProductScreen(
                        produk: produk,
                        priceType: priceType,
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
                                  'Rp ' +
                                      _formatter.format(
                                        priceType == ProductsPriceType.jual
                                            ? produk.hargaJual
                                            : produk.hargaStok,
                                  ),
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
          )
      ],
    );
  }
}
