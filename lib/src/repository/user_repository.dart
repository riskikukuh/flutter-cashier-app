import 'package:kasir_app/src/dataSource/local/local_data_source.dart';
import 'package:kasir_app/src/models/user_model.dart';
import 'package:kasir_app/src/resources/result.dart';

class UserRepository {
  late final LocalDataSource _localDataSource;

  UserRepository({ required final LocalDataSource localDataSource}) {
    _localDataSource = localDataSource;
  }

  Future<void> close() {
    return _localDataSource.closeUserProvider();
  }

  Future<Result<UserModel?>> login(String username, String password) {
    return _localDataSource.login(username, password);
  }

  Future<Result<bool>> logout() {
    return _localDataSource.logout();
  }

  Future<Result<UserModel?>> isAlreadyLogin() {
    return _localDataSource.isAlreadyLogin();
  }
}