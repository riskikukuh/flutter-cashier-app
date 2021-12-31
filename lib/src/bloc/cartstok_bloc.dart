import 'package:bloc/bloc.dart';
import 'package:kasir_app/src/models/cart_stok_model.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/repository/cart_stok_repository.dart';
import 'package:kasir_app/src/resources/result.dart';
import 'package:meta/meta.dart';

part 'cartstok_event.dart';
part 'cartstok_state.dart';

class CartstokBloc extends Bloc<CartstokEvent, CartstokState> {
  final CartStokRepository cartStokRepository;
  CartstokBloc({
    required this.cartStokRepository,
  }) : super(CartstokInitial()) {
    on<GetAllCartStok>((event, emit) async {
      emit(CartStokLoading());
      Result<List<CartStokModel>> resultAllCart =
          await cartStokRepository.getAllCartStok();
      if (resultAllCart is Success<List<CartStokModel>>) {
        emit(CartStokLoadSuccess(cartStok: resultAllCart.data));
      } else {
        Error error = resultAllCart as Error;
        emit(CartStokError(message: error.message));
      }
    });

    on<AddCartStok>((event, emit) async {
      List<CartStokModel> allCartStok = [];
      if (state is CartStokLoadSuccess) {
        allCartStok.addAll((state as CartStokLoadSuccess).cartStok);
      }
      emit(CartStokLoading());
      CartStokModel params = CartStokModel(
        id: -1,
        date: DateTime.now().millisecondsSinceEpoch,
        produk: event.produk,
        quantity: event.quantity,
      );
      Result<CartStokModel> resultInsertCartStok =
          await cartStokRepository.addCartStok(params);
      if (resultInsertCartStok is Success<CartStokModel>) {
        emit(CartStokNotifSuccess(
            message: 'Produk berhasil ditambahkan ke keranjang stok'));
        allCartStok.add(resultInsertCartStok.data);
        emit(CartStokLoadSuccess(cartStok: allCartStok));
      } else {
        Error error = resultInsertCartStok as Error;
        emit(CartStokError(message: error.message));
      }
    });

    on<EditCartStok>((event, emit) async {
      List<CartStokModel> allCartStok = [];
      if (state is CartStokLoadSuccess) {
        allCartStok.addAll((state as CartStokLoadSuccess).cartStok);
      }
      emit(CartStokLoading());
      Result<CartStokModel> resultEditCartStok =
          await cartStokRepository.editCartStok(event.cartStok);
      if (resultEditCartStok is Success<CartStokModel>) {
        emit(CartStokNotifSuccess(message: 'Order stok berhasil diubah'));
        emit(CartStokLoadSuccess(
          cartStok: allCartStok
              .map(
                (cartStok) => cartStok.id == resultEditCartStok.data.id
                    ? resultEditCartStok.data
                    : cartStok,
              )
              .toList(),
        ));
      } else {
        Error error = resultEditCartStok as Error;
        emit(CartStokError(message: error.message));
      }
    });

    on<DeleteCartStok>((event, emit) async {
      List<CartStokModel> allCartStok = [];
      if (state is CartStokLoadSuccess) {
        allCartStok.addAll((state as CartStokLoadSuccess).cartStok);
      }
      emit(CartStokLoading());
      Result<bool> resultDeleteCartStok =
          await cartStokRepository.deleteCartStok(event.cartStok);
      if (resultDeleteCartStok is Success<bool>) {
        emit(CartStokNotifSuccess(message: 'Produk berhasil dihapus'));
        emit(CartStokLoadSuccess(
          cartStok: allCartStok
              .where((cartStok) => cartStok.id != event.cartStok.id)
              .toList(),
        ));
      } else {
        Error error = resultDeleteCartStok as Error;
        emit(CartStokError(message: error.message));
      }
    });

    on<ClearCartStok>((event, emit) async {
      emit(CartStokLoading());
      Result<bool> resultClearCartStok =
          await cartStokRepository.clearCartStok();
      if (resultClearCartStok is Success<bool>) {
        emit(CartStokNotifSuccess(message: 'Keranjang stok berhasil dikosongkan'));
        emit(CartStokLoadSuccess(
          cartStok: const [],
        ));
      } else {
        Error error = resultClearCartStok as Error;
        emit(CartStokError(message: error.message));
      }
    });
  }
}
