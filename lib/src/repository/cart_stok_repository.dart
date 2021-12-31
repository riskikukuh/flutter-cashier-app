import 'package:kasir_app/src/dataSource/local/local_data_source.dart';
import 'package:kasir_app/src/models/cart_stok_model.dart';
import 'package:kasir_app/src/resources/result.dart';

class CartStokRepository {
  late final LocalDataSource _localDataSource;

  CartStokRepository({
    required final LocalDataSource localDataSource,
  }) {
    _localDataSource = localDataSource;
  }

  Future<void> close() {
    return _localDataSource.closeCartStokProvider();
  }

  Future<Result<List<CartStokModel>>> getAllCartStok() {
    return _localDataSource.getAllCartStok();
  }

  Future<Result<CartStokModel>> addCartStok(CartStokModel cartStok) {
    return _localDataSource.addCartStok(cartStok);
  }

  Future<Result<CartStokModel>> editCartStok(CartStokModel cartStok) {
    return _localDataSource.editCartStok(cartStok);
  }

  Future<Result<bool>> deleteCartStok(CartStokModel cartStok) {
    return _localDataSource.deleteCartStok(cartStok);
  }
  
  Future<Result<bool>> clearCartStok() {
    return _localDataSource.clearCartStok();
  }
}
