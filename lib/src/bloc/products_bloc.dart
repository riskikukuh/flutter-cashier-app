import 'package:bloc/bloc.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/models/supplier_model.dart';
import 'package:kasir_app/src/repository/products_repository.dart';
import 'package:kasir_app/src/resources/result.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsRepository productsRepository;
  ProductsBloc({
    required this.productsRepository,
  }) : super(ProductsInitial()) {
    on<GetAllProduct>((event, emit) async {
      emit(ProductsLoading());
      Result<List<ProdukModel>> response =
          await productsRepository.getAllProduk();

      if (response is Success<List<ProdukModel>>) {
        emit(ProductsLoadSuccess(allProduk: response.data));
      } else {
        Error error = response as Error;
        emit(ProductsError(message: error.message));
      }
    });

    on<AddProduct>((event, emit) async {
      if (state is ProductsLoadSuccess) {
        List<ProdukModel> oldProduk = (state as ProductsLoadSuccess).allProduk;
        emit(ProductsLoading());
        ProdukModel produk = ProdukModel(
          id: -1,
          nama: event.nama,
          harga: int.parse(event.harga),
          stok: int.parse(event.stok),
          supplier: event.supplier,
        );
        await Future.delayed(const Duration(seconds: 1));
        Result<ProdukModel> responseAddProduk =
            await productsRepository.addProduk(produk);

        if (responseAddProduk is Success<ProdukModel>) {
          emit(ProductsLoadSuccess(
              allProduk: oldProduk..add(responseAddProduk.data)));
        } else {
          ProductsError error = responseAddProduk as ProductsError;
          emit(ProductsError(message: error.message));
        }
      } else {
        print('AddProduct : $state');
      }
    });

    on<EditProduct>((event, emit) async {
      List<ProdukModel> allProduk = [];
      if (state is ProductsLoadSuccess) {
        allProduk.addAll((state as ProductsLoadSuccess).allProduk);
      }

      await Future.delayed(const Duration(seconds: 1));

      Result<bool> resultEditProduk =
          await productsRepository.editProduk(event.produk);
      if (resultEditProduk is Success<bool>) {
        if (resultEditProduk.data) {
          emit(ProductsNotifSuccess(
            produk: event.produk,
            message: 'Berhasil mengubah produk',
          ));
          emit(ProductsLoadSuccess(
            allProduk: allProduk
                .map((produk) =>
                    produk.id == event.produk.id ? event.produk : produk)
                .toList(),
          ));
        } else {
          emit(ProductsNotifError(message: 'Gagal mengedit produk'));
          emit(ProductsLoadSuccess(allProduk: allProduk));
        }
      } else {
        Error error = resultEditProduk as Error;
        emit(ProductsError(message: error.message));
      }
    });

    on<DeleteProduct>((event, emit) async {
      List<ProdukModel> allProduk = [];
      if (state is ProductsLoadSuccess) {
        allProduk.addAll((state as ProductsLoadSuccess).allProduk);
      }
      await Future.delayed(const Duration(seconds: 1));
      Result<bool> resultDeleteProduk =
          await productsRepository.deleteProduk(event.produk);
      if (resultDeleteProduk is Success<bool>) {
        emit(ProductsLoadSuccess(
          allProduk: allProduk
              .where((produk) => produk.id != event.produk.id)
              .toList(),
        ));
      } else {
        Error error = resultDeleteProduk as Error;
        emit(ProductsError(message: error.message));
      }
    });
  }

  @override
  Future<void> close() async {
    await productsRepository.close();
    return super.close();
  }
}
