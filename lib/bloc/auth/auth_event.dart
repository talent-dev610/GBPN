import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {}

class AuthCheckEvent extends AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email, password;

  AuthLoginEvent({required this.email, required this.password});
}

class AuthLogoutEvent extends AuthEvent {}

class AuthSelectCompanyEvent extends AuthEvent {
  final String uuid;

  AuthSelectCompanyEvent({required this.uuid});
}
