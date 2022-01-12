part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartFetched extends CartState {
  final List<CartModel> order;
  CartFetched({
    required this.order,
  });
}

class CartMessage extends CartState {
  final String message;
  CartMessage({
    required this.message,
  });
}

class CartNotifSuccess extends CartMessage {
  CartNotifSuccess({String? message}) : super(message: message ?? 'CartNotifSuccess');
}

class CartNotifError extends CartMessage {
  CartNotifError({String? message}) : super(message: message ?? 'CartNotifSuccess');
}

class CartError extends CartState {
  final String message;
  CartError({
    required this.message,
  });
}

class CartLoading extends CartState {}
