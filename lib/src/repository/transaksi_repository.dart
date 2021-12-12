import 'package:kasir_app/src/dataSource/local/local_data_source.dart';
import 'package:kasir_app/src/models/transaksi_model.dart';
import 'package:kasir_app/src/resources/result.dart';

class TransaksiRepository {
  late final LocalDataSource _localDataSource;
  
  TransaksiRepository({ required final LocalDataSource localDataSource}) {
    _localDataSource = localDataSource;
  }

  Future<void> close() {
    return _localDataSource.closeTransaksiProvider();
  }

  Future<Result<List<TransaksiModel>>> getAllTransaksi() {
    return _localDataSource.getAllTransaksi();
  }

  Future<Result<TransaksiModel>> addTransaksi(TransaksiModel transaksi) {
    return _localDataSource.addTransaksi(transaksi);
  }

  // Future<Result<SupplierModel>> getSupplierById(int supplierId) async {
  //   return _localDataSource.getSupplierByid(supplierId);
  // }

  // Future<Result<SupplierModel>> addSupplier(SupplierModel supplier) async {
  //   return _localDataSource.addSupplier(supplier);
  // }

  // Future<Result<SupplierModel>> editSupplier(SupplierModel supplier) async {
  //   return _localDataSource.editSupplier(supplier);
  // }

  // Future<Result<bool>> deleteSupplier(SupplierModel supplier) async {
  //   return _localDataSource.deleteSupplier(supplier);
  // }
  
}