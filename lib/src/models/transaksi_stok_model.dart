import 'package:kasir_app/src/models/detail_transaksi_stok_model.dart';

class TransaksiStokModel {
  int id;
  int tanggal;
  String keterangan;
  List<DetailTransaksiStokModel> stok;
  int price;

  TransaksiStokModel({
    required this.id,
    required this.tanggal,
    required this.keterangan,
    required this.stok,
    required this.price,
  });

  TransaksiStokModel copyWith({
    int? id,
    int? tanggal, 
    String? keterangan, 
    List<DetailTransaksiStokModel>? stok,
    int? price,
  }) {
    return TransaksiStokModel(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      keterangan: keterangan ?? this.keterangan,
      stok: stok ?? this.stok,
      price: price ?? this.price,
    );
  }
}