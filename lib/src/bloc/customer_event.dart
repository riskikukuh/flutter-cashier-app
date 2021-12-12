part of 'customer_bloc.dart';

@immutable
abstract class CustomerEvent {}

class GetAllCustomer extends CustomerEvent {}

class AddCustomer extends CustomerEvent {
  final String nama;
  final String jk;
  final String noTelp;
  final String alamat;

  AddCustomer({
    required this.nama,
    required this.jk,
    required this.noTelp,
    required this.alamat,
  });
}

class EditCustomer extends CustomerEvent {
  final CustomerModel customer;
  EditCustomer({
    required this.customer,
  });
}

class DeleteCustomer extends CustomerEvent {
  final CustomerModel customer;
  DeleteCustomer({
    required this.customer,
  });
}

class GetCustomerById extends CustomerEvent {
  final int customerId;
  GetCustomerById({
    required this.customerId,
  });
}
