part of 'supplier_bloc.dart';

@immutable
abstract class SupplierEvent {}

class GetAllSupplier extends SupplierEvent {}

class AddSupplier extends SupplierEvent {
  final String nama;
  final String noTelp;
  final String alamat;
  AddSupplier({
    required this.nama,
    required this.noTelp,
    required this.alamat,
  });
}

class EditSupplier extends SupplierEvent {
  final SupplierModel supplier;
  EditSupplier({
    required this.supplier,
  });
}

class DeleteSupplier extends SupplierEvent {
  final SupplierModel supplier;
  DeleteSupplier({
    required this.supplier,
  });
}

class GetSupplierById extends SupplierEvent {
  final int supplierId;
  GetSupplierById({
    required this.supplierId,
  });
}
