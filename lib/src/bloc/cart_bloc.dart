import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kasir_app/src/models/order_model.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/repository/cart_repository.dart';
import 'package:kasir_app/src/resources/result.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;
  CartBloc({
    required this.cartRepository,
  }) : super(CartInitial()) {
    on<GetAllCart>((event, emit) async {
      emit(CartLoading());
      Result<List<OrderModel>> allOrder = await cartRepository.getAllOrder();
      if (allOrder is Success<List<OrderModel>>) {
        emit(CartFetched(order: allOrder.data));
      } else {
        Error error = allOrder as Error;
        emit(CartError(message: error.message));
      }
    });

    on<AddOrder>((event, emit) async {
      List<OrderModel> oldOrder = [];
      if (state is CartFetched) {
        oldOrder.addAll((state as CartFetched).order);
      }
      emit(CartLoading());
      Result<OrderModel> resultInsert =
          await cartRepository.addOrder(event.order);
      if (resultInsert is Success<OrderModel>) {
        bool isAlreadyAdded = oldOrder.where((order) => order.produk.id == resultInsert.data.produk.id).isNotEmpty;
        if (isAlreadyAdded) {
          emit(CartNotifSuccess(message: 'Produk sudah ditambahkan ke keranjang'));
          emit(CartFetched(order: oldOrder));
        } else {
          emit(CartNotifSuccess(message: 'Berhasil menambahkan ke keranjang'));
          emit(CartFetched(order: oldOrder..add(resultInsert.data)));
        }
      } else {
        Error error = resultInsert as Error;
        emit(CartNotifError(message: error.message));
        emit(CartError(
          message: error.message,
        ));
        emit(CartFetched(order: oldOrder));
      }
    });

    on<DeleteOrder>((event, emit) async {
      emit(CartLoading());
      Result<bool> resultDelete = await cartRepository.deleteOrder(event.order);
      if (resultDelete is Success<bool>) {
        add(GetAllCart());
      } else {
        Error error = resultDelete as Error;
        emit(CartError(
          message: error.message,
        ));
      }
    });

    on<EditOrder>((event, emit) async {
      List<OrderModel> allOrder = [];
      if (state is CartFetched) {
        allOrder.addAll((state as CartFetched).order);
      }
      List<OrderModel> oldOrder = (state as CartFetched).order;
      emit(CartLoading());
      Result<OrderModel> editedOrder =
          await cartRepository.editOrder(event.order);
      if (editedOrder is Success<OrderModel>) {
        emit(CartFetched(
          order: oldOrder
              .map(
                (order) =>
                    order.id == editedOrder.data.id ? editedOrder.data : order,
              )
              .toList(),
        ));
      } else {
        Error error = editedOrder as Error;
        emit(CartError(
          message: error.message,
        ));
      }
    });

    on<ClearCart>((event, emit) async {
      List<OrderModel> allOrder = [];
      if (state is CartFetched) {
        allOrder.addAll((state as CartFetched).order);
      }
      Result<bool> resultClearCart = await cartRepository.clearCart();
      if (resultClearCart is Success<bool>) {
        if (resultClearCart.data) {
          emit(CartFetched(order: List.empty()));
        } else {
          emit(CartFetched(order: allOrder));
        }
      } else {
        Error error = resultClearCart as Error;
        emit(CartError(message: error.message));
      }
    });
  }

  @override
  Future<void> close() async {
    await cartRepository.close();
    return super.close();
  }
}
