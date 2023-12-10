import 'package:eduction_app/src/auth/domain/entites/local_user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

//basic helpers
class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateError extends AuthState {
  const AuthStateError(this.message);
  final String message;
  @override
  List<String> get props => [message];
}

// basic return finished states
class AuthStateSignedIn extends AuthState {
  const AuthStateSignedIn(this.user);
  final LocalUser user;
  @override
  List<Object> get props => [user];
}

class AuthStateForgotPassword extends AuthState {
  const AuthStateForgotPassword();
}

class AuthStateSignedUp extends AuthState {
  const AuthStateSignedUp();
}

class AuthStateUpdateUser extends AuthState {
  const AuthStateUpdateUser();
}
