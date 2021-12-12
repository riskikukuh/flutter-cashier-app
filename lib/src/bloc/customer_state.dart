part of 'customer_bloc.dart';

@immutable
abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoadSuccess extends CustomerState {
  final List<CustomerModel> allCustomer;
  CustomerLoadSuccess({
    required this.allCustomer,
  });
}

class CustomerNotifError extends CustomerMessage {
  CustomerNotifError({
    String? message,
  }) : super(message: message ?? 'CustomerNotifError');
}

class CustomerNotifSuccess extends CustomerMessage {
  CustomerNotifSuccess({
    String? message,
  }) : super(message: message ?? 'CustomerNotifSuccess');
}

class CustomerMessage extends CustomerState {
  final String message;
  CustomerMessage({
    required this.message,
  });
}

class CustomerError extends CustomerState {
  final String message;
  CustomerError({
    required this.message,
  });
}
