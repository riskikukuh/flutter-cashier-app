part of 'filteredproducts_bloc.dart';

@immutable
abstract class FilteredproductsState {}

class FilteredproductsInitial extends FilteredproductsState {}

class FilteredProductsLoadSuccess extends FilteredproductsState {
  final List<ProdukModel> allProduk;
  FilteredProductsLoadSuccess({
    required this.allProduk,
  });
}

class FilteredProductsLoading extends FilteredproductsState {}

class FilteredProductsError extends FilteredproductsState {
  final String message;
  FilteredProductsError({
    required this.message,
  });
}
