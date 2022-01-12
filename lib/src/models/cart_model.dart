import 'package:kasir_app/src/models/produk_model.dart';

class CartModel {
  final int id;
  final int quantity;
  final int date;
  final ProdukModel produk;

  CartModel({
    this.id = -1,
    this.quantity = 1,
    this.date = -1,
    required this.produk,
  });

  CartModel copyWith({
    int? id,
    int? quantity,
    int? date,
    ProdukModel? produk,
  }) {
    return CartModel(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
      produk: produk ?? this.produk,
    );
  }
}
