import 'package:kasir_app/src/config/database/sqlite/database_helper.dart';
import 'package:kasir_app/src/config/entity/cart_stok_entity.dart';
import 'package:kasir_app/src/config/entity/customer_entity.dart';
import 'package:kasir_app/src/config/entity/detail_transaksi_stok_entity.dart';
import 'package:kasir_app/src/config/entity/order_entity.dart';
import 'package:kasir_app/src/config/entity/produk_entity.dart';
import 'package:kasir_app/src/config/entity/supplier_entity.dart';
import 'package:kasir_app/src/config/entity/transaksi_entity.dart';
import 'package:kasir_app/src/config/entity/transaksi_order_entity.dart';
import 'package:kasir_app/src/config/entity/transaksi_stok_entity.dart';
import 'package:kasir_app/src/config/entity/user_entity.dart';
import 'package:kasir_app/src/config/session/session_helper.dart';
import 'package:kasir_app/src/models/cart_stok_model.dart';
import 'package:kasir_app/src/models/customer_model.dart';
import 'package:kasir_app/src/models/detail_transaksi_stok_model.dart';
import 'package:kasir_app/src/models/order_model.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/models/supplier_model.dart';
import 'package:kasir_app/src/models/transaksi_model.dart';
import 'package:kasir_app/src/models/transaksi_order_model.dart';
import 'package:kasir_app/src/models/transaksi_stok_model.dart';
import 'package:kasir_app/src/models/user_model.dart';
import 'package:kasir_app/src/resources/mapper.dart';
import 'package:kasir_app/src/resources/result.dart';
import 'package:kasir_app/src/resources/util.dart';

class LocalDataSource {
  final DatabaseHelper dbHelper;
  final SessionHelper sessionHelper;
  LocalDataSource({
    required this.dbHelper,
    required this.sessionHelper,
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
      return Success(data: resultDeleteOrder > 0);
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

  /* 
    Login Section
  */
  Future<Result<UserModel?>> isAlreadyLogin() async {
    try {
      String? userId = await sessionHelper.isAlreadyLogin();
      if (userId != null) {
        UserEntity? user =
            await dbHelper.userProvider.getUserById(int.parse(userId));
        if (user != null) {
          return Success(data: mapUserEntityToUserModel(user));
        }
      }
      return Success(data: null);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<UserModel?>> login(String username, String password) async {
    try {
      String hashedPassword = Util.hash(password);
      UserEntity? user =
          await dbHelper.userProvider.login(username, hashedPassword);
      if (user != null) {
        await sessionHelper.setUserLogin(
            user.id.toString(), user.nama.toString(), username);
        return Success(data: mapUserEntityToUserModel(user));
      }
      return Success(data: null);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<bool>> logout() async {
    try {
      await sessionHelper.cleaUserLogin();
      String? userId = await sessionHelper.isAlreadyLogin();
      return Success(data: userId == null);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<void> closeUserProvider() {
    return dbHelper.userProvider.close();
  }

  /*
    Cart Stok Section
  */
  Future<Result<List<CartStokModel>>> getAllCartStok() async {
    try {
      List<CartStokModel> allCartStok = [];
      List<CartStokEntity> resultCartStok =
          await dbHelper.cartStokProvider.getAllCartStok();
      await Future.forEach<CartStokEntity>(resultCartStok, (cartStok) async {
        if (cartStok.produk! > 0) {
          Result<ProdukModel> produk = await getProdukById(cartStok.produk!);
          if (produk is Success<ProdukModel>) {
            allCartStok
                .add(mapCartStokEntityToCartStokModel(cartStok, produk.data));
          }
        }
      });
      return Success(data: allCartStok);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<CartStokModel>> addCartStok(CartStokModel cartStok) async {
    try {
      int cartStokId = await dbHelper.cartStokProvider
          .insert(mapCartStokModelToCartStokEntity(cartStok));
      if (cartStokId > 0) {
        return Success(data: cartStok.copyWith(id: cartStokId));
      }
      return Error(message: 'Gagal menambahkan produk ke keranjang stok');
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<CartStokModel>> editCartStok(CartStokModel cartStok) async {
    try {
      int cartStokId = await dbHelper.cartStokProvider
          .update(mapCartStokModelToCartStokEntity(cartStok));
      if (cartStokId > 0) {
        return Success(data: cartStok);
      }
      return Error(message: 'Gagal menambahkan produk ke keranjang stok');
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<bool>> clearCartStok() async {
    try {
      int resultDeleteAll = await dbHelper.cartStokProvider.deleteAll();
      return Success(data: resultDeleteAll > 0);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<bool>> deleteCartStok(CartStokModel cartStok) async {
    try {
      int resultDeleteCartStok = await dbHelper.cartStokProvider
          .delete(mapCartStokModelToCartStokEntity(cartStok));
      return Success(data: resultDeleteCartStok > 0);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<void> closeCartStokProvider() async {
    await dbHelper.cartStokProvider.close();
  }

  /* 
    Transaksi Stok Section
  */

  Future<Result<List<TransaksiStokModel>>> getAllTransaksiStok() async {
    try {
      List<TransaksiStokModel> result = [];
      List<TransaksiStokEntity> allTransaksi =
          await dbHelper.transaksiStokProvider.getAllTransaksi();
      await Future.forEach<TransaksiStokEntity>(allTransaksi,
          (transaksi) async {
        if (transaksi.id != null) {
          List<DetailTransaksiStokEntity> detailTransaksiStokEntity =
              await dbHelper.detailTransaksiStokProvider
                  .getDetailTransaksiByIdTransaksiStok(transaksi.id!);
          List<DetailTransaksiStokModel> detailTransaksiStokModel = [];
          await Future.forEach<DetailTransaksiStokEntity>(
              detailTransaksiStokEntity, (singleDetailTransaksiStok) async {
            if (singleDetailTransaksiStok.idProduk != null) {
              Result<ProdukModel> produk =
                  await getProdukById(singleDetailTransaksiStok.idProduk!);
              if (produk is Success<ProdukModel>) {
                detailTransaksiStokModel.add(
                    mapDetailTransaksiStokEntityToDetailTransaksiStokModel(
                        singleDetailTransaksiStok, produk.data));
              }
            }
          });
          result.add(mapTransaksiStokEntityToTransaksiStokModel(
              transaksi, detailTransaksiStokModel));
        }
      });
      return Success(data: result);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<TransaksiStokModel>> addTransaksiStok(
      TransaksiStokModel transaksi) async {
    try {
      int transaksiStokId = await dbHelper.transaksiStokProvider
          .insert(mapTransaksiStokModelToTransaksiStokEntity(transaksi));
      List<DetailTransaksiStokModel> stoks = [];
      if (transaksiStokId > 0) {
        await Future.forEach<DetailTransaksiStokModel>(transaksi.stok,
            (detailTransaksi) async {
          int resultDetailInsert = await dbHelper.detailTransaksiStokProvider
              .insert(mapDetailTransaksiStokModelToDetailTransaksiStokEntity(
                  detailTransaksi.copyWith(idTransaksiStok: transaksiStokId)));
          int newStok = detailTransaksi.produk.stok + detailTransaksi.quantity;
          if (resultDetailInsert < 0) {
            return Error(message: 'Terjadi kegagalan saat melakukan transaksi');
          } else {
            Result<bool> resultEditProduk = await editProduk(
                detailTransaksi.produk.copyWith(stok: newStok));
            if (resultEditProduk is Success<bool>) {
              if (resultEditProduk.data) {
                stoks.add(detailTransaksi.copyWith(
                  id: resultDetailInsert,
                  idTransaksiStok: transaksiStokId,
                ));
              }
            } 
          }
        });
        return Success(
          data: transaksi.copyWith(
            id: transaksiStokId,
            stok: stoks,
          ),
        );
      }
      return Error(message: 'Gagal menambahkan transaksi stok!');
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }

  Future<Result<bool>> deleteTransaksiStok(TransaksiStokModel transaksi) async {
    try {
      await Future.forEach<DetailTransaksiStokModel>(transaksi.stok,
          (detailTransaksi) async {
        await dbHelper.detailTransaksiStokProvider.delete(detailTransaksi.id);
      });
      int resultDeleteTransaksiStok =
          await dbHelper.transaksiStokProvider.delete(transaksi.id);
      return Success(data: resultDeleteTransaksiStok > 0);
    } on Exception catch (e) {
      return Error(message: e.toString());
    }
  }
}
