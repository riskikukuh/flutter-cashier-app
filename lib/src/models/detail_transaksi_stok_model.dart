import 'package:kasir_app/src/models/produk_model.dart';

class DetailTransaksiStokModel {
  final int id;
  final int idTransaksiStok;
  final ProdukModel produk;
  final int quantity;

  DetailTransaksiStokModel({
    required this.id,
    required this.idTransaksiStok,
    required this.produk,
    required this.quantity,
  });

  DetailTransaksiStokModel copyWith({
    int? id,
    int? idTransaksiStok,
    ProdukModel? produk,
    int? quantity,
  }) {
    return DetailTransaksiStokModel(
      id: id ?? this.id,
      idTransaksiStok: idTransaksiStok ?? this.idTransaksiStok,
      produk: produk ?? this.produk,
      quantity: quantity ?? this.quantity,
    );
  }
}