import 'package:kasir_app/src/models/supplier_model.dart';

class ProdukModel {
  final int id;
  final String nama;
  final int harga;
  final int stok;
  SupplierModel? supplier;

  ProdukModel({
    this.id = -1,
    this.nama = 'Unknown',
    this.harga = -1,
    this.stok = -1,
    this.supplier,
  });

  String formatHarga() {
    return harga.toString();
  }

  ProdukModel copyWith({
    int? id,
    String? nama,
    int? harga,
    int? stok,
    SupplierModel? supplier,
  }) {
    return ProdukModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      harga: harga ?? this.harga,
      stok: stok ?? this.stok,
      supplier: supplier ?? this.supplier,
    );
  }
}
