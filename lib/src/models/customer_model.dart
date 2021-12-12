class CustomerModel {
  int id;
  String nama;
  String jk;
  String noTelp;
  String alamat;

  CustomerModel({
    required this.id,
    required this.nama,
    required this.jk,
    required this.noTelp,
    required this.alamat,
  });

  CustomerModel copyWith({
    int? id,
    String? nama,
    String? jk,
    String? noTelp,
    String? alamat,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      jk: jk ?? this.jk,
      noTelp: noTelp ?? this.noTelp,
      alamat: alamat ?? this.alamat,
    );
  }
}
