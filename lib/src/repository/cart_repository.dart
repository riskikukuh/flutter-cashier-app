import 'package:kasir_app/src/dataSource/local/local_data_source.dart';
import 'package:kasir_app/src/models/order_model.dart';
import 'package:kasir_app/src/resources/result.dart';

class CartRepository {
  late final LocalDataSource _localDataSource;

  CartRepository({
    required final LocalDataSource localDataSource,
  }) {
    _localDataSource = localDataSource;
  }

  Future<void> close() {
    return _localDataSource.closeCartProvider();
  }

  Future<Result<List<OrderModel>>> getAllOrder() {
    return _localDataSource.getAllOrder();
  }

  Future<Result<OrderModel>> addOrder(OrderModel order) {
    return _localDataSource.addOrder(order);
  }

  Future<Result<OrderModel>> editOrder(OrderModel order) {
    return _localDataSource.editOrder(order);
  }

  Future<Result<bool>> deleteOrder(OrderModel order) {
    return _localDataSource.deleteOrder(order);
  }
  
  Future<Result<bool>> clearCart() {
    return _localDataSource.clearCart();
  }
}
