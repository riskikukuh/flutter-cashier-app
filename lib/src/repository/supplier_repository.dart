import 'package:kasir_app/src/dataSource/local/local_data_source.dart';
import 'package:kasir_app/src/models/supplier_model.dart';
import 'package:kasir_app/src/resources/result.dart';

class SupplierRepository {
  late final LocalDataSource _localDataSource;
  
  SupplierRepository({ required final LocalDataSource localDataSource}) {
    _localDataSource = localDataSource;
  }

  Future<void> close() {
    return _localDataSource.closeSupplierProvider();
  }

  Future<Result<List<SupplierModel>>> getAllSupplier() async {
    return _localDataSource.getAllSupplier();
  }

  Future<Result<SupplierModel>> getSupplierById(int supplierId) async {
    return _localDataSource.getSupplierByid(supplierId);
  }

  Future<Result<SupplierModel>> addSupplier(SupplierModel supplier) async {
    return _localDataSource.addSupplier(supplier);
  }

  Future<Result<bool>> editSupplier(SupplierModel supplier) async {
    return _localDataSource.editSupplier(supplier);
  }

  Future<Result<bool>> deleteSupplier(SupplierModel supplier) async {
    return _localDataSource.deleteSupplier(supplier);
  }
  
}