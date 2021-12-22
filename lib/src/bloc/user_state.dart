part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class NotLoggedIn extends UserState {}

class UserLoading extends UserState {}

class SuccessLogin extends UserState {
  final UserModel user;
  SuccessLogin({
    required this.user,
  });
}

class AlreadyLogin extends UserState {
  final UserModel user;
  AlreadyLogin({
    required this.user,
  });
}

class CredentialFailure extends UserState {
  final String message;
  CredentialFailure({
    required this.message,
  });
}

class UserError extends UserState {
  final String message;
  UserError({
    required this.message,
  });
}
