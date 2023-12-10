import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../core/enums/update_user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthEventSignIn extends AuthEvent {
  const AuthEventSignIn({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthEventSignUp extends AuthEvent {
  const AuthEventSignUp(
      {required this.email, required this.name, required this.password});
  final String email;
  final String name;
  final String password;

  @override
  List<Object?> get props => [email, name, password];
}

class AuthEventForgotPassword extends AuthEvent {
  const AuthEventForgotPassword({required this.email});
  final String email;
  @override
  List<Object?> get props => [email];
}

class AuthEventUpdateUser extends AuthEvent {
  AuthEventUpdateUser({required this.userData, required this.action})
      : assert(
            userData is String || userData is File,
            'userData have to be [String] or [File]'
            'but given ${userData.runtimeType.toString()}');
  final dynamic userData;
  final UpdateUserAction action;
  @override
  List<Object?> get props => [userData, action];
}
