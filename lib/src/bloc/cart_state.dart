part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartFetched extends CartState {
  final List<OrderModel> order;
  CartFetched({
    required this.order,
  });
}

class CartError extends CartState {
  final String message;
  CartError({
    required this.message,
  });
}

class CartLoading extends CartState {}