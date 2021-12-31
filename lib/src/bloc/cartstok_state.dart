part of 'cartstok_bloc.dart';

@immutable
abstract class CartstokState {}

class CartstokInitial extends CartstokState {}

class CartStokLoadSuccess extends CartstokState {
  final List<CartStokModel> cartStok;
  CartStokLoadSuccess({
    required this.cartStok,
  });
}

class CartStokLoading extends CartstokState {}

class CartStokError extends CartstokState {
  final String message;
  CartStokError({
    required this.message,
  });
}

class CartStokMessage extends CartstokState {
  final String message;
  CartStokMessage({
    required this.message,
  });
}

class CartStokNotifSuccess extends CartStokMessage {
  CartStokNotifSuccess({String? message})
      : super(message: message ?? 'CartStokNotifSuccess');
}

class CartStokNotifError extends CartStokMessage {
  CartStokNotifError({String? message})
      : super(message: message ?? 'CartStokNotifError');
}
