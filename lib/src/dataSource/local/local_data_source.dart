import 'package:kasir_app/src/config/database/sqlite/database_helper.dart';
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
import 'package:kasir_app/src/resources/mapper.dart';
import 'package:kasir_app/src/resources/result.dart';

class LocalDataSource {
  final DatabaseHelper dbHelper;
  LocalDataSource({
    required this.dbHelper,
  });

  /*
    Produk Section
  */

  Future<Result<ProdukModel>> getProdukById(int id) async {
    try {
      ProdukEntity? responseProduk =
          await dbHelper.productProvider.getProdukById(id);
      if (responseProduk != null) {
        SupplierEntity? supplier = await dbHelper.supplierProvider
            .getSupplierById(responseProduk.supplier!);
        ProdukModel produkModel =
            mapProdukEntityToProdukModel(responseProduk, supplier);
        return Success(
          data: produkModel,
        );
      } else {
        return Error(
          message: 'Produk tidak ditemukan',
        );
      }
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<ProdukModel>> addProduk(ProdukModel produk) async {
    try {
      int insertedId = await dbHelper.productProvider
          .insert(mapProdukModelToProdukEntity(produk));

      if (insertedId > 0) {
        ProdukModel newProduk = produk.copyWith(id: insertedId);
        return Success(data: newProduk);
      } else {
        return Error(message: 'Gagal menambahkan produk');
      }
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<bool>> editProduk(ProdukModel produk) async {
    try {
      int resultUpdate = await dbHelper.productProvider
          .update(mapProdukModelToProdukEntity(produk));

      return Success(data: resultUpdate > 0);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }
  
  Future<void> closeProdukProvider() async {
    await dbHelper.productProvider.close();
  }

  Future<Result<List<ProdukModel>>> getAllProduk() async {
    try {
      List<ProdukModel> allProduk = [];
      List<ProdukEntity> responseAllproduk =
          await dbHelper.productProvider.getProduk();
      await Future.forEach<ProdukEntity>(responseAllproduk, (produk) async {
        if (produk.supplier != null) {
          SupplierEntity? supplier =
              await dbHelper.supplierProvider.getSupplierById(produk.supplier!);
          allProduk.add(mapProdukEntityToProdukModel(produk, supplier));
        } else {
          allProduk.add(mapProdukEntityToProdukModel(produk, null));
        }
      });
      return Success(data: allProduk);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<bool>> deleteProduk(int id) async {
    try {
      int resultDelete = await dbHelper.productProvider.delete(id);
      return Success(data: resultDelete > 0);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  /* 
    Cart Order Section
  */

  Future<void> closeCartProvider() async {
    await dbHelper.orderProvider.close();
  }

  Future<Result<bool>> clearCart() async {
    try {
      int resultDeleteAll = await dbHelper.orderProvider.deleteAll();
      return Success(data: resultDeleteAll > 0);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<List<OrderModel>>> getAllOrder() async {
    try {
      List<OrderEntity> order = await dbHelper.orderProvider.getAllOrder();
      List<OrderModel> allOrder = [];
      await Future.forEach(order, (singleOrder) async {
        if (singleOrder != null) {
          singleOrder as OrderEntity;
          if (singleOrder.produk != null) {
            Result<ProdukModel> produkResult =
                await getProdukById(singleOrder.produk!);
            if (produkResult is Success) {
              ProdukModel produk = (produkResult as Success<ProdukModel>).data;
              allOrder.add(mapOrderEntityToOrderModel(singleOrder, produk));
            }
          }
        }
      });
      return Success(data: allOrder);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<OrderModel>> addOrder(OrderModel order) async {
    try {
      OrderEntity? checkAlreadyOrder =
          await dbHelper.orderProvider.getOrderByProdukId(order.produk.id);
      if (checkAlreadyOrder != null) {
        OrderEntity updateOrder = checkAlreadyOrder;
        int currentQty = updateOrder.quantity ?? 1;
        int newQty = currentQty + order.quantity;
        if (newQty > order.produk.stok) {
          return Error(message: 'Order tidak boleh melebihi jumlah stok !');
        } else {
          updateOrder.quantity = newQty;
        }
        int resultUpdateOrder =
            await dbHelper.orderProvider.update(updateOrder);
        if (resultUpdateOrder > 0) {
          return Success(
              data: mapOrderEntityToOrderModel(updateOrder, order.produk));
        } else {
          return Error(message: 'Gagal mengubah pesanan');
        }
      } else {
        int insertedOrderId = await dbHelper.orderProvider
            .insert(mapOrderModelToOrderEntity(order));
        if (insertedOrderId > 0) {
          OrderModel newOrder = order.copyWith(id: insertedOrderId);
          return Success(data: newOrder);
        } else {
          return Error(message: 'Gagal menambahkan pesanan');
        }
      }
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<OrderModel>> editOrder(OrderModel order) async {
    try {
      int orderResult = await dbHelper.orderProvider
          .update(mapOrderModelToOrderEntity(order));
      if (orderResult > 0) {
        return Success(data: order);
      } else {
        return Error(message: 'Gagal menambahkan pesanan');
      }
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<bool>> deleteOrder(OrderModel order) async {
    try {
      int resultDeleteOrder = await dbHelper.orderProvider
          .delete(mapOrderModelToOrderEntity(order));
      if (resultDeleteOrder > 0) {
        return Success(data: true);
      } else {
        return Success(data: false);
      }
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  /*
    Customer Section
  */

  Future<void> closeCustomerProvider() async {
    await dbHelper.customerProvider.close();
  }

  Future<Result<List<CustomerModel>>> getAllCustomer() async {
    try {
      List<CustomerEntity> resultAllCustomer =
          await dbHelper.customerProvider.getAllCustomer();
      return Success(
          data: resultAllCustomer
              .map((customer) => mapCustomerEntityToCustomerModel(customer))
              .toList());
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<CustomerModel>> getCustomerById(int customerId) async {
    try {
      CustomerEntity? resultCustomer =
          await dbHelper.customerProvider.getCustomerById(customerId);
      if (resultCustomer != null) {
        return Success(data: mapCustomerEntityToCustomerModel(resultCustomer));
      } else {
        return Error(message: 'Customer tidak ditemukan');
      }
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<CustomerModel>> addCustomer(CustomerModel customer) async {
    try {
      int resultInsert = await dbHelper.customerProvider
          .insert(mapCustomerModelToCustomerEntity(customer));
      if (resultInsert > 0) {
        customer.id = resultInsert;
        return Success(data: customer);
      } else {
        return Error(message: 'Gagal menambahkan customer');
      }
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<bool>> editCustomer(CustomerModel customer) async {
    try {
      int resultUpdate = await dbHelper.customerProvider
          .update(mapCustomerModelToCustomerEntity(customer));
      return Success(data: resultUpdate > 0);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<bool>> deleteCustomer(CustomerModel customer) async {
    try {
      int resultDelete = await dbHelper.customerProvider
          .delete(mapCustomerModelToCustomerEntity(customer));
      return Success(data: resultDelete > 0);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  /* 
    Supplier Section
  */

  Future<void> closeSupplierProvider() async {
    await dbHelper.supplierProvider.close();
  }

  Future<Result<List<SupplierModel>>> getAllSupplier() async {
    try {
      List<SupplierEntity> allSupplier =
          await dbHelper.supplierProvider.getAllSupplier();
      return Success(
          data: allSupplier
              .map((supplier) => mapSupplierEntityToSupplierModel(supplier))
              .toList());
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<SupplierModel>> getSupplierByid(int supplierId) async {
    try {
      SupplierEntity? supplier =
          await dbHelper.supplierProvider.getSupplierById(supplierId);
      if (supplier != null) {
        return Success(data: mapSupplierEntityToSupplierModel(supplier));
      } else {
        return Error(message: 'Supplier tidak ditemukan');
      }
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<SupplierModel>> addSupplier(SupplierModel supplier) async {
    try {
      int supplierInsertedId = await dbHelper.supplierProvider
          .insert(mapSupplierModelToSupplierEntity(supplier));
      if (supplierInsertedId > 0) {
        SupplierModel sm = supplier.copyWith(id: supplierInsertedId);
        return Success(
          data: sm,
        );
      } else {
        return Error(message: 'Gagal menambahkan supplier');
      }
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<bool>> editSupplier(SupplierModel supplier) async {
    try {
      int resultUpdateSupplier = await dbHelper.supplierProvider
          .update(mapSupplierModelToSupplierEntity(supplier));
      return Success(
        data: resultUpdateSupplier > 0,
      );
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<bool>> deleteSupplier(SupplierModel supplier) async {
    try {
      int resultDeleteSupplier = await dbHelper.supplierProvider
          .delete(mapSupplierModelToSupplierEntity(supplier));
      return Success(data: resultDeleteSupplier > 0);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  /* 
    Transaksi Section
  */

  Future<void> closeTransaksiProvider() async {
    await dbHelper.transaksiProvider.close();
    await dbHelper.transaksiOrderProvider.close();
  }

  Future<Result<List<TransaksiModel>>> getAllTransaksi() async {
    try {
      List<TransaksiModel> resultAllTransaksi = [];
      List<TransaksiEntity> allTransaksi =
          await dbHelper.transaksiProvider.getAllTransaksi();
      await Future.forEach<TransaksiEntity>(allTransaksi, (transaksi) async {
        if (transaksi.id != null) {
          List<TransaksiOrderModel> resultAllOrder = [];
          List<TransaksiOrderEntity> listOrder = await dbHelper
              .transaksiOrderProvider
              .getAllOrderByTransaksiId(transaksi.id!);
          await Future.forEach<TransaksiOrderEntity>(listOrder, (order) async {
            if (order.id != null) {
              ProdukEntity? produk =
                  await dbHelper.productProvider.getProdukById(order.idProduk!);
              if (produk != null) {
                SupplierEntity? supplier = await dbHelper.supplierProvider
                    .getSupplierById(produk.supplier ?? 0);
                resultAllOrder.add(TransaksiOrderModel(
                  id: order.id!,
                  idTransaksi: transaksi.id!,
                  produk: mapProdukEntityToProdukModel(produk, supplier),
                  quantity: order.quantity ?? -1,
                ));
              }
            }
          });
          CustomerEntity? customer = await dbHelper.customerProvider
              .getCustomerById(transaksi.idPembeli!);
          if (customer != null) {
            resultAllTransaksi.add(
              mapTransaksiEntityToTransaksiModel(
                transaksi,
                resultAllOrder,
                mapCustomerEntityToCustomerModel(customer),
              ),
            );
          }
        }
      });

      return Success(
        data: resultAllTransaksi,
      );
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<TransaksiModel>> addTransaksi(TransaksiModel transaksi) async {
    try {
      await Future.forEach<TransaksiOrderModel>(transaksi.orders,
          (order) async {
        await dbHelper.productProvider
            .verifyStok(order.produk.id, order.quantity);
      });
      int idTransaksi = await dbHelper.transaksiProvider
          .insert(mapTransaksiModelToTransaksiEntity(transaksi));
      if (idTransaksi > 0) {
        List<TransaksiOrderModel> orders = [];
        await Future.forEach<TransaksiOrderModel>(
          transaksi.orders,
          (order) async {
            int newStok = order.produk.stok - order.quantity;
            if (newStok >= 0) {
              int idTransaksiOrder =
                  await dbHelper.transaksiOrderProvider.insert(
                mapTransaksiOrderModelToTransaksiOrderEntity(
                    idTransaksi, order),
              );
              if (idTransaksiOrder > 0) {
                Result<bool> resultEditProduk =
                    await editProduk(order.produk.copyWith(stok: newStok));
                if (resultEditProduk is Success<bool>) {
                  if (resultEditProduk.data) {
                    orders.add(order.copyWith(id: idTransaksiOrder));
                  }
                }
              }
            }
          },
        );
        return Success(
          data: transaksi.copyWith(
            id: idTransaksi,
            orders: orders,
          ),
        );
      }
      return Error(message: 'Gagal menambahkan transaksi');
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }
}
