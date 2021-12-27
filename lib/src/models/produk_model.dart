import 'package:kasir_app/src/models/supplier_model.dart';

class ProdukModel {
  final int id;
  final String nama;
  final int hargaJual;
  final int hargaStok;
  final int stok;
  SupplierModel? supplier;

  ProdukModel({
    this.id = -1,
    this.nama = 'Unknown',
    this.hargaJual = -1,
    this.hargaStok = -1,
    this.stok = -1,
    this.supplier,
  });

  ProdukModel copyWith({
    int? id,
    String? nama,
    int? hargaJual,
    int? hargaStok,
    int? stok,
    SupplierModel? supplier,
  }) {
    return ProdukModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      hargaJual: hargaJual ?? this.hargaJual,
      hargaStok: hargaStok ?? this.hargaStok,
      stok: stok ?? this.stok,
      supplier: supplier ?? this.supplier,
    );
  }
}
