part of 'supplier_bloc.dart';

@immutable
abstract class SupplierState {}

class SupplierInitial extends SupplierState {}

class SupplierLoadSuccess extends SupplierState {
  final List<SupplierModel> allSupplier;
  SupplierLoadSuccess({
    required this.allSupplier,
  });
}

class SupplierLoading extends SupplierState {}

class SupplierNotifSuccess extends SupplierMessage {
  SupplierNotifSuccess({String? message})
      : super(message: message ?? 'SupplierNotifSuccess');
}

class SupplierNotifError extends SupplierMessage {
  SupplierNotifError({String? message})
      : super(message: message ?? 'SupplierNotifError');
}

class SupplierMessage extends SupplierState {
  final String message;
  SupplierMessage({
    required this.message,
  });
}

class SupplierError extends SupplierState {
  final String message;
  SupplierError({
    required this.message,
  });
}
