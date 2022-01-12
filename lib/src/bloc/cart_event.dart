part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class GetAllCart extends CartEvent {}

class AddOrder extends CartEvent {
  final CartModel order;
  AddOrder({
    required this.order,
  });
}

class EditOrder extends CartEvent {
  final CartModel order;
  EditOrder({
    required this.order,
  });
}

class ClearCart extends CartEvent {}

class DeleteOrder extends CartEvent {
  final CartModel order;
  DeleteOrder({
    required this.order,
  });
}
