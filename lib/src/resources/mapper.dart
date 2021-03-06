import 'package:kasir_app/src/config/entity/cart_stok_entity.dart';
import 'package:kasir_app/src/config/entity/customer_entity.dart';
import 'package:kasir_app/src/config/entity/detail_transaksi_stok_entity.dart';
import 'package:kasir_app/src/config/entity/cart_entity.dart';
import 'package:kasir_app/src/config/entity/produk_entity.dart';
import 'package:kasir_app/src/config/entity/supplier_entity.dart';
import 'package:kasir_app/src/config/entity/transaksi_entity.dart';
import 'package:kasir_app/src/config/entity/detail_transaksi_entity.dart';
import 'package:kasir_app/src/config/entity/transaksi_stok_entity.dart';
import 'package:kasir_app/src/config/entity/user_entity.dart';
import 'package:kasir_app/src/models/cart_stok_model.dart';
import 'package:kasir_app/src/models/customer_model.dart';
import 'package:kasir_app/src/models/detail_transaksi_stok_model.dart';
import 'package:kasir_app/src/models/cart_model.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/models/supplier_model.dart';
import 'package:kasir_app/src/models/transaksi_model.dart';
import 'package:kasir_app/src/models/detail_transaksi_model.dart';
import 'package:kasir_app/src/models/transaksi_stok_model.dart';
import 'package:kasir_app/src/models/user_model.dart';

ProdukModel mapProdukEntityToProdukModel(
    ProdukEntity produk, SupplierEntity? supplier) {
  return ProdukModel(
    id: produk.id ?? -1,
    nama: produk.nama ?? 'Unknown',
    hargaJual: produk.hargaJual ?? -1,
    hargaStok: produk.hargaStok ?? -1,
    stok: produk.stok ?? -1,
    supplier: mapSupplierEntityToSupplierModel(supplier),
  );
}

ProdukEntity mapProdukModelToProdukEntity(ProdukModel produk) {
  return ProdukEntity(
    id: produk.id,
    hargaJual: produk.hargaJual,
    hargaStok: produk.hargaStok,
    nama: produk.nama,
    stok: produk.stok,
    supplier: produk.supplier?.id,
  );
}

UserModel mapUserEntityToUserModel(UserEntity user) {
  return UserModel(
    id: user.id ?? -1,
    nama: user.nama ?? 'Unknown',
    username: user.username ?? 'Unknown',
  );
}

UserEntity mapUserModelToUserEntity(UserModel user) {
  return UserEntity(
    id: user.id,
    nama: user.nama,
    username: user.username,
  );
}

CartEntity mapCartModelToCartEntity(CartModel order) {
  return CartEntity(
    id: order.id,
    date: order.date,
    produk: order.produk.id,
    quantity: order.quantity,
  );
}

CartModel mapCartEntityToCartModel(CartEntity order, ProdukModel produk) {
  return CartModel(
    id: order.id ?? -1,
    date: order.date ?? -1,
    quantity: order.quantity ?? -1,
    produk: produk,
  );
}

CustomerModel mapCustomerEntityToCustomerModel(CustomerEntity customer) {
  return CustomerModel(
    id: customer.id ?? -1,
    nama: customer.nama ?? 'Unknown',
    jk: customer.jk ?? 'L',
    noTelp: customer.noTelp ?? 'Unknown',
    alamat: customer.alamat ?? 'Unknown',
  );
}

CustomerEntity mapCustomerModelToCustomerEntity(CustomerModel customer) {
  return CustomerEntity(
    id: customer.id,
    nama: customer.nama,
    jk: customer.jk,
    noTelp: customer.noTelp,
    alamat: customer.alamat,
  );
}

SupplierModel mapSupplierEntityToSupplierModel(SupplierEntity? supplier) {
  return SupplierModel(
    id: supplier?.id ?? -1,
    nama: supplier?.nama ?? 'Unknown',
    noTelp: supplier?.noTelp ?? 'Unknown',
    alamat: supplier?.alamat ?? 'Unknown',
  );
}

SupplierEntity mapSupplierModelToSupplierEntity(SupplierModel supplier) {
  return SupplierEntity(
    id: supplier.id,
    nama: supplier.nama,
    noTelp: supplier.noTelp,
    alamat: supplier.alamat,
  );
}

TransaksiModel mapTransaksiEntityToTransaksiModel(TransaksiEntity transaksi,
    List<DetailTransaksiModel> orders, CustomerModel customer) {
  return TransaksiModel(
    id: transaksi.id ?? -1,
    tanggal: transaksi.tanggal ?? -1,
    keterangan: transaksi.keterangan ?? 'Unknown',
    orders: orders,
    pembeli: customer,
    price: transaksi.price ?? -1,
  );
}

TransaksiEntity mapTransaksiModelToTransaksiEntity(TransaksiModel transaksi) {
  return TransaksiEntity(
    id: transaksi.id,
    idPembeli: transaksi.pembeli?.id,
    keterangan: transaksi.keterangan,
    tanggal: transaksi.tanggal,
    price: transaksi.price,
  );
}

DetailTransaksiEntity mapDetailTransaksiModelToDetailTransaksiEntity(
    int transaksiId, DetailTransaksiModel transaksiOrder) {
  return DetailTransaksiEntity(
    id: transaksiOrder.id,
    idProduk: transaksiOrder.produk.id,
    idTransaksi: transaksiId,
    quantity: transaksiOrder.quantity,
  );
}

DetailTransaksiModel mapCartModelToDetailTransaksiModel(CartModel order) {
  return DetailTransaksiModel(
    id: -1,
    idTransaksi: -1,
    produk: order.produk,
    quantity: order.quantity,
  );
}

TransaksiStokModel mapTransaksiStokEntityToTransaksiStokModel(
    TransaksiStokEntity transaksi, List<DetailTransaksiStokModel> stok) {
  return TransaksiStokModel(
    id: transaksi.id ?? -1,
    keterangan: transaksi.keterangan ?? '',
    price: transaksi.price ?? -1,
    tanggal: transaksi.tanggal ?? -1,
    stok: stok,
  );
}

TransaksiStokEntity mapTransaksiStokModelToTransaksiStokEntity(
    TransaksiStokModel transaksi) {
  return TransaksiStokEntity(
    id: transaksi.id,
    keterangan: transaksi.keterangan,
    price: transaksi.price,
    tanggal: transaksi.tanggal,
  );
}

DetailTransaksiStokModel mapDetailTransaksiStokEntityToDetailTransaksiStokModel(DetailTransaksiStokEntity detailTransaksiStok, ProdukModel produk) {
  return DetailTransaksiStokModel(
    id: detailTransaksiStok.id ?? -1,
    idTransaksiStok: detailTransaksiStok.idTransaksiStok ?? -1,
    produk: produk,
    quantity: detailTransaksiStok.quantity ?? -1,
  );
}

DetailTransaksiStokEntity mapDetailTransaksiStokModelToDetailTransaksiStokEntity(DetailTransaksiStokModel detailTransaksiStok) {
  return DetailTransaksiStokEntity(
    id: detailTransaksiStok.id,
    idTransaksiStok: detailTransaksiStok.idTransaksiStok,
    idProduk: detailTransaksiStok.produk.id,
    quantity: detailTransaksiStok.quantity,
  );
}

CartStokModel mapCartStokEntityToCartStokModel(CartStokEntity cartStok, ProdukModel produk) {
  return CartStokModel(
    id: cartStok.id ?? -1,
    date: cartStok.date ?? -1,
    produk: produk,
    quantity: cartStok.quantity ?? -1,
  );
}

CartStokEntity mapCartStokModelToCartStokEntity(CartStokModel cartStok) {
  return CartStokEntity(
    id: cartStok.id,
    date: cartStok.date,
    produk: cartStok.produk.id,
    quantity: cartStok.quantity,
  );
}