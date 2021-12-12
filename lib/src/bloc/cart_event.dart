part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class GetAllCart extends CartEvent {}

class AddOrder extends CartEvent {
  final OrderModel order;
  AddOrder({
    required this.order,
  });
}

class EditOrder extends CartEvent {
  final OrderModel order;
  EditOrder({
    required this.order,
  });
}

class ClearCart extends CartEvent {}

class DeleteOrder extends CartEvent {
  final OrderModel order;
  DeleteOrder({
    required this.order,
  });
}
