part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class GetAllProduct extends ProductsEvent {}

class AddProduct extends ProductsEvent {
  final String nama;
  final String hargaJual;
  final String hargaStok;
  final String stok;
  final SupplierModel supplier;
  AddProduct({
    required this.nama,
    required this.hargaJual,
    required this.hargaStok,
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
