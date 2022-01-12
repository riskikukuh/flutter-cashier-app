import 'package:kasir_app/src/dataSource/local/local_data_source.dart';
import 'package:kasir_app/src/models/cart_model.dart';
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

  Future<Result<List<CartModel>>> getAllCart() {
    return _localDataSource.getAllCart();
  }

  Future<Result<CartModel>> addCart(CartModel cart) {
    return _localDataSource.addCart(cart);
  }

  Future<Result<CartModel>> editCart(CartModel cart) {
    return _localDataSource.editCart(cart);
  }

  Future<Result<bool>> deleteCart(CartModel cart) {
    return _localDataSource.deleteCart(cart);
  }
  
  Future<Result<bool>> clearCart() {
    return _localDataSource.clearCart();
  }
}
