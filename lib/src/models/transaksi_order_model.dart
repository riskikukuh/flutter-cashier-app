import 'package:kasir_app/src/models/produk_model.dart';
// import 'package:kasir_app/src/models/transaksi_model.dart';

class TransaksiOrderModel {
  final int id;
  final int idTransaksi;
  final ProdukModel produk;
  final int quantity;

  TransaksiOrderModel({
    required this.id,
    required this.idTransaksi,
    required this.produk,
    required this.quantity,
  });

  TransaksiOrderModel copyWith({
    int? id,
    int? idTransaksi,
    ProdukModel? produk,
    int? quantity,
  }) {
    return TransaksiOrderModel(
      id: id ?? this.id,
      idTransaksi: idTransaksi ?? this.idTransaksi,
      produk: produk ?? this.produk,
      quantity: quantity ?? this.quantity,
    );
  }
}
