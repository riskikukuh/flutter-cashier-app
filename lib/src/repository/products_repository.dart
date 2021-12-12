import 'package:kasir_app/src/dataSource/local/local_data_source.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/resources/result.dart';

class ProductsRepository {
  late final LocalDataSource _localDataSource;

  ProductsRepository({
    required final LocalDataSource localDataSource,
  }) {
    _localDataSource = localDataSource;
  }

  Future<void> close() {
    return _localDataSource.closeProdukProvider();
  }

  Future<Result<ProdukModel>> addProduk(ProdukModel produk) async {
    return await _localDataSource.addProduk(produk);
  }

  Future<Result<List<ProdukModel>>> getAllProduk() async {
    return await _localDataSource.getAllProduk();
  }

  Future<Result<ProdukModel>> getProdukById(int id) async {
    return await _localDataSource.getProdukById(id);
  }

  Future<Result<bool>> editProduk(ProdukModel produk) {
    return _localDataSource.editProduk(produk);
  }

  Future<Result<bool>> deleteProduk(ProdukModel produk) {
    return _localDataSource.deleteProduk(produk.id);
  }
}
