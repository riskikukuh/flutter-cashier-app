class SupplierModel {

  final int id;
  final String nama;
  final String noTelp;
  final String alamat;

  SupplierModel({
    this.id = -1,
    this.nama = 'Unknown',
    this.noTelp = 'Unknown',
    this.alamat = 'Unknown',
  });

  SupplierModel copyWith({
    int? id,
    String? nama,
    String? noTelp,
    String? alamat,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      noTelp: noTelp ?? this.noTelp,
      alamat: alamat ?? this.alamat,
    );
  }
}