import 'package:kasir_app/src/dataSource/local/local_data_source.dart';
import 'package:kasir_app/src/models/customer_model.dart';
import 'package:kasir_app/src/resources/result.dart';

class CustomerRepository  {

  late final LocalDataSource _localDataSource;

  CustomerRepository({
    required final LocalDataSource localDataSource,
  }) {
    _localDataSource = localDataSource;
  }

  Future<void> close() {
    return _localDataSource.closeCustomerProvider();
  }

  Future<Result<List<CustomerModel>>> getAllCustomer() async {
    return await _localDataSource.getAllCustomer();
  }

  Future<Result<CustomerModel>> getCustomerById(int customerId) async {
    return await _localDataSource.getCustomerById(customerId);
  }

  Future<Result<CustomerModel>> addCustomer(CustomerModel customer) async {
    return await _localDataSource.addCustomer(customer);
  }

  Future<Result<bool>> editCustomer(CustomerModel customer) {
    return _localDataSource.editCustomer(customer);
  }

  Future<Result<bool>> deleteCustomer(CustomerModel customer) async {
    return await _localDataSource.deleteCustomer(customer);
  }

}