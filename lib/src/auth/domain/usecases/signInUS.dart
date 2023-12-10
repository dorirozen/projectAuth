import 'package:eduction_app/core/common/usecases/usecases.dart';
import 'package:eduction_app/core/utils/typedef.dart';
import 'package:eduction_app/src/auth/domain/entites/local_user.dart';
import 'package:eduction_app/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

/*
class SignInUS extends UsecaseWithParams<LocalUser, List<String>> {
  const SignInUS({required this.authRepo});
  final AuthRepo authRepo;
  @override
  ResultFuture<LocalUser> call(List<String> params) =>
      authRepo.signIn(email: params[0], password: params[1]);
}
 */
///more readable, self-documenting, and less error-prone. It also allows you to
///add more parameters in the future without modifying the method signature.
/// provides better readability with a clear separation of concerns
class SignInUS extends UsecaseWithParams<LocalUser, SignInParams> {
  const SignInUS(this._authRepo);
  final AuthRepo _authRepo;
  @override
  ResultFuture<LocalUser> call(SignInParams params) =>
      _authRepo.signIn(email: params.email, password: params.password);
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});

  final String email;
  final String password;

  const SignInParams.empty()
      : email = '',
        password = '';

  @override
  List<Object?> get props => [email, password];
}
