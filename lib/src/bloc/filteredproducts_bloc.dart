import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:meta/meta.dart';

part 'filteredproducts_event.dart';
part 'filteredproducts_state.dart';

class FilteredproductsBloc
    extends Bloc<FilteredproductsEvent, FilteredproductsState> {
  final ProductsBloc productsBloc;
  StreamSubscription? productsSubscription;
  FilteredproductsBloc({
    required this.productsBloc,
  }) : super(
          productsBloc.state is ProductsLoadSuccess
              ? FilteredProductsLoadSuccess(
                  allProduk:
                      (productsBloc.state as ProductsLoadSuccess).allProduk)
              : FilteredProductsLoading(),
        ) {
          productsSubscription = productsBloc.stream.listen((state) {
            if (state is ProductsLoadSuccess) {
              add(ProductsUpdated(allProduk: state.allProduk));
            }
          });
    
    on<ProductsUpdated>((event, emit) {
      emit(FilteredProductsLoadSuccess(allProduk: event.allProduk));
    });

    on<SearchProducts>((event, emit) {
      if (state is FilteredProductsLoadSuccess) {
        if (productsBloc.state is ProductsLoadSuccess) {
          List<ProdukModel> allProduk = (productsBloc.state as ProductsLoadSuccess).allProduk;
          if (event.keyword.isNotEmpty) {
            List<ProdukModel> filteredProducts = allProduk.where((produk) => produk.nama.toLowerCase().contains(event.keyword)).toList();
            emit(FilteredProductsLoadSuccess(allProduk: filteredProducts));
          } else {
            emit(FilteredProductsLoadSuccess(allProduk: allProduk));
          }
        }
      }
    });
  }

  @override
  Future<void> close() async {
    await productsSubscription?.cancel();
    return super.close();
  }
}
