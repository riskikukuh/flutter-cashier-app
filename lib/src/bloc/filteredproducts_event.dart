part of 'filteredproducts_bloc.dart';

@immutable
abstract class FilteredproductsEvent {}

class SearchProducts extends FilteredproductsEvent {
  final String keyword;
  SearchProducts({
    required this.keyword,
  });
}

class ProductsUpdated extends FilteredproductsEvent {
  final List<ProdukModel> allProduk;
  ProductsUpdated({
    required this.allProduk,
  });
}
