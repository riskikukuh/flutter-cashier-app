part of 'products_bloc.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoadSuccess extends ProductsState {
  final List<ProdukModel> allProduk;
  ProductsLoadSuccess({
    this.allProduk = const [],
  });
}

class ProductsNotifError extends ProductsMessage {
  ProductsNotifError({String? message})
      : super(message: message ?? 'ProductsNotifError');
}

class ProductsNotifSuccess extends ProductsMessage {
  ProductsNotifSuccess({
    String? message,
  }) : super(message: message ?? 'ProductsNotifSuccess');
}

class ProductsMessage extends ProductsState {
  final String message;
  ProductsMessage({
    required this.message,
  });
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError({
    required this.message,
  });
}
