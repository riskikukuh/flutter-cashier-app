import 'package:kasir_app/src/config/entity/customer_entity.dart';
import 'package:kasir_app/src/config/entity/order_entity.dart';
import 'package:kasir_app/src/config/entity/produk_entity.dart';
import 'package:kasir_app/src/config/entity/supplier_entity.dart';
import 'package:kasir_app/src/config/entity/transaksi_entity.dart';
import 'package:kasir_app/src/config/entity/transaksi_order_entity.dart';
import 'package:kasir_app/src/models/customer_model.dart';
import 'package:kasir_app/src/models/order_model.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/models/supplier_model.dart';
import 'package:kasir_app/src/models/transaksi_model.dart';
import 'package:kasir_app/src/models/transaksi_order_model.dart';

ProdukModel mapProdukEntityToProdukModel(
    ProdukEntity produk, SupplierEntity? supplier) {
  return ProdukModel(
    id: produk.id ?? -1,
    nama: produk.nama ?? 'Unknown',
    harga: produk.harga ?? -1,
    stok: produk.stok ?? -1,
    supplier: mapSupplierEntityToSupplierModel(supplier),
  );
}

ProdukEntity mapProdukModelToProdukEntity(ProdukModel produk) {
  return ProdukEntity(
    id: produk.id,
    harga: produk.harga,
    nama: produk.nama,
    stok: produk.stok,
    supplier: produk.supplier?.id,
  );
}

// TransaksiModel mapTransaksiEntityToTransaksiModel(TransaksiEntity produk) {
//   return TransaksiModel(
//     id: produk.id ?? -1,
//     // idPembeli: produk.idPembeli ?? -1,
//     tanggal: produk.tanggal ?? DateTime.now().millisecondsSinceEpoch,
//     keterangan: produk.keterangan ?? '',
//     orders: [],
//   );
// }

OrderEntity mapOrderModelToOrderEntity(OrderModel order) {
  return OrderEntity(
    id: order.id,
    date: order.date,
    produk: order.produk.id,
    quantity: order.quantity,
  );
}

OrderModel mapOrderEntityToOrderModel(OrderEntity order, ProdukModel produk) {
  return OrderModel(
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
    List<TransaksiOrderModel> orders, CustomerModel customer) {
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

TransaksiOrderEntity mapTransaksiOrderModelToTransaksiOrderEntity(
    int transaksiId, TransaksiOrderModel transaksiOrder) {
  return TransaksiOrderEntity(
    id: transaksiOrder.id,
    idProduk: transaksiOrder.produk.id,
    idTransaksi: transaksiId,
    quantity: transaksiOrder.quantity,
  );
}

TransaksiOrderModel mapOrderModelToTransaksiOrderModel(OrderModel order) {
  return TransaksiOrderModel(
    id: -1,
    idTransaksi: -1,
    produk: order.produk,
    quantity: order.quantity,
  );
}
