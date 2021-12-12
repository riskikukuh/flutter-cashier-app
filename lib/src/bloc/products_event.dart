part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class GetAllProduct extends ProductsEvent {}

class AddProduct extends ProductsEvent {
  final String nama;
  final String harga;
  final String stok;
  final SupplierModel supplier;
  AddProduct({
    required this.nama,
    required this.harga,
    required this.stok,
    required this.supplier,
  });
}

class DeleteProduct extends ProductsEvent {
  final ProdukModel produk;
  DeleteProduct({
    required this.produk,
  });
}

class EditProduct extends ProductsEvent {
  final ProdukModel produk;
  EditProduct({
    required this.produk,
  });
}
