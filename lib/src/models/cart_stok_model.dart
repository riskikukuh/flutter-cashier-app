import 'package:kasir_app/src/models/produk_model.dart';

class CartStokModel {
  int id;
  int date;
  ProdukModel produk;
  int quantity;

  CartStokModel({
    required this.id,
    required this.date,
    required this.produk,
    required this.quantity,
  });

  CartStokModel copyWith({
    int? id,
    int? date,
    ProdukModel? produk,
    int? quantity,
  }) {
    return CartStokModel(
      id: id ?? this.id,
      date: date ?? this.date,
      produk: produk ?? this.produk,
      quantity: quantity ?? this.quantity,
    );
  }
}
