import 'package:gbpn_messages/model/user_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthFailedState extends AuthState {
  final String errMsg;

  AuthFailedState({required this.errMsg});
}

class AuthLoggedInState extends AuthState {
  final UserModel user;

  AuthLoggedInState({required this.user});
}

class AuthLoggedOutState extends AuthState {}