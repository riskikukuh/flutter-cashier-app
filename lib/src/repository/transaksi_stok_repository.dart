import 'package:kasir_app/src/dataSource/local/local_data_source.dart';
import 'package:kasir_app/src/models/transaksi_stok_model.dart';
import 'package:kasir_app/src/resources/result.dart';

class TransaksiStokRepository {
  late final LocalDataSource _localDataSource;
  
  TransaksiStokRepository({ required final LocalDataSource localDataSource}) {
    _localDataSource = localDataSource;
  }

  Future<void> close() {
    return _localDataSource.closeTransaksiProvider();
  }

  Future<Result<List<TransaksiStokModel>>> getAllTransaksi() {
    return _localDataSource.getAllTransaksiStok();
  }

  Future<Result<TransaksiStokModel>> addTransaksi(TransaksiStokModel transaksi) {
    return _localDataSource.addTransaksiStok(transaksi);
  }

  Future<Result<bool>> deleteTransaksi(TransaksiStokModel transaksi) {
    return _localDataSource.deleteTransaksiStok(transaksi);
  }
}