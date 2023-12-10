import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eduction_app/src/auth/domain/usecases/forgotpasswordUS.dart';
import 'package:eduction_app/src/auth/domain/usecases/signInUS.dart';
import 'package:eduction_app/src/auth/domain/usecases/signUpUS.dart';
import 'package:eduction_app/src/auth/domain/usecases/updateUserUS.dart';
import 'package:eduction_app/src/auth/presention/bloc/auth_event.dart';
import 'package:eduction_app/src/auth/presention/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
      {required SignInUS signIn,
      required SignUpUS signUp,
      required UpdateUserUS updateUser,
      required ForgotPasswordUS forgotPassowrd})
      : _signIn = signIn,
        _signUp = signUp,
        _updateUser = updateUser,
        _forgotPassowrd = forgotPassowrd,
        super(const AuthStateInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthStateLoading());
    });
    on<AuthEventSignIn>(_activateAuthEventSignIn);
    on<AuthEventSignUp>(_activateAuthEventSignUp);
    on<AuthEventForgotPassword>(_activateAuthEventForgotPassword);
    on<AuthEventUpdateUser>(_activateAuthEventUpdateUser);
  }
  final SignInUS _signIn;
  final SignUpUS _signUp;
  final UpdateUserUS _updateUser;
  final ForgotPasswordUS _forgotPassowrd;

  FutureOr<void> _activateAuthEventSignIn(
      AuthEventSignIn event, Emitter<AuthState> emit) async {
    final res = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (failure) => emit(AuthStateError(failure.errorMessage)),
      (user) => emit(AuthStateSignedIn(user)),
    );
  }

  FutureOr<void> _activateAuthEventSignUp(
      AuthEventSignUp event, Emitter<AuthState> emit) async {
    final res = await _signUp(SignUpParams(
        email: event.email, fullname: event.name, password: event.password));
    res.fold(
      (l) => emit(AuthStateError(l.errorMessage)),
      (_) => emit(const AuthStateSignedUp()),
    );
  }

  FutureOr<void> _activateAuthEventForgotPassword(
      AuthEventForgotPassword event, Emitter<AuthState> emit) async {
    final res = await _forgotPassowrd(event.email);
    res.fold(
      (l) => emit(AuthStateError(l.errorMessage)),
      (_) => emit(const AuthStateForgotPassword()),
    );
  }

  FutureOr<void> _activateAuthEventUpdateUser(
      AuthEventUpdateUser event, Emitter<AuthState> emit) async {
    final res = await _updateUser(
        UpdateUserParams(action: event.action, userData: event.userData));
    res.fold(
      (l) => emit(AuthStateError(l.errorMessage)),
      (_) => emit(const AuthStateUpdateUser()),
    );
  }
}
