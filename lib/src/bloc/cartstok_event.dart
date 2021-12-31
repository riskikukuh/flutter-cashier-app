part of 'cartstok_bloc.dart';

@immutable
abstract class CartstokEvent {}

class GetAllCartStok extends CartstokEvent {}

class AddCartStok extends CartstokEvent {
  final ProdukModel produk;
  final int quantity;
  AddCartStok({
    required this.produk,
    required this.quantity,
  });
}

class EditCartStok extends CartstokEvent {
  final CartStokModel cartStok;
  EditCartStok({
    required this.cartStok,
  });
}

class DeleteCartStok extends CartstokEvent {
  final CartStokModel cartStok;
  DeleteCartStok({
    required this.cartStok,
  });
}

class ClearCartStok extends CartstokEvent {}
