import 'package:bloc/bloc.dart';
import 'package:kasir_app/src/models/user_model.dart';
import 'package:kasir_app/src/repository/user_repository.dart';
import 'package:kasir_app/src/resources/result.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc({
    required this.userRepository,
  }) : super(NotLoggedIn()) {
    on<Login>((event, emit) async {
      emit(UserLoading());
      Result<UserModel?> user = await userRepository.login(event.username, event.password);
      if (user is Success<UserModel?>) {
        if (user.data != null) {
          emit(SuccessLogin(user: user.data!));
        } else {
          emit(CredentialFailure(message: 'Username atau Pasword tidak ditemukan !'));
        }
      } else {
        Error error = user as Error;
        emit(UserError(message: error.message));
      }
    });

    on<IsAlreadyLogin>((event, emit) async {
      emit(UserLoading());
      Result<UserModel?> user = await userRepository.isAlreadyLogin();
      if (user is Success<UserModel?>) {
        if (user.data != null) {
          emit(AlreadyLogin(user: user.data!));
        } else {
          emit(NotLoggedIn());
        }
      } else {
        Error error = user as Error;
        emit(UserError(message: error.message));
      }
    });

    on<Logout>((event, emit) async {
      emit(UserLoading());
      Result<bool> user = await userRepository.logout();
      if (user is Success<bool>) {
        if (user.data) {
          emit(NotLoggedIn());
        } else {
          emit(UserError(message: 'Gagal melakukan logout !'));
        }
      } else {
        Error error = user as Error;
        emit(UserError(message: error.message));
      }
    });
  }

  @override
  Future<void> close() async {
    await userRepository.close();
    return super.close();
  }
}
