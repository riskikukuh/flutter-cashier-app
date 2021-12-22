part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class Login extends UserEvent {
  final String username;
  final String password;
  Login({
    required this.username,
    required this.password,
  });
}

class Logout extends UserEvent {}

class IsAlreadyLogin extends UserEvent {}
