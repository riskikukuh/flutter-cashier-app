import 'package:flutter/material.dart';
import 'package:kasir_app/src/resources/enums.dart';
import 'package:kasir_app/src/screen/produk/search_products_screen.dart';

class SearchButton extends StatelessWidget {
  final ProductsPriceType priceType;
  const SearchButton({
    Key? key,
    this.priceType = ProductsPriceType.jual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Cari Produk',
      onPressed: () {
        showSearch(
          context: context,
          delegate: SearchProductsScreen(
            priceType: priceType,
          ),
        );
      },
      icon: const Icon(Icons.search),
    );
  }
}
