import 'package:kasir_app/src/models/customer_model.dart';
import 'package:kasir_app/src/models/detail_transaksi_model.dart';

class TransaksiModel {
  final int id;
  CustomerModel? pembeli;
  final int tanggal;
  final String keterangan;
  final List<DetailTransaksiModel> orders;
  final int price;

  TransaksiModel({
    required this.id,
    this.pembeli,
    required this.tanggal,
    required this.keterangan,
    required this.orders,
    required this.price,
  });

  TransaksiModel copyWith({
    int? id,
    CustomerModel? pembeli,
    int? tanggal,
    String? keterangan,
    List<DetailTransaksiModel>? orders,
    int? price,
  }) {
    return TransaksiModel(
      id: id ?? this.id,
      pembeli: pembeli ?? this.pembeli,
      tanggal: tanggal ?? this.tanggal,
      keterangan: keterangan ?? this.keterangan,
      orders: orders ?? this.orders,
      price: price ?? this.price,
    );
  }
}
