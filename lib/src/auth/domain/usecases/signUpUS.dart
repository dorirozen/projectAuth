import 'package:equatable/equatable.dart';
import '../../../../core/common/usecases/usecases.dart';
import '../../../../core/utils/typedef.dart';
import '../repos/auth_repo.dart';

class SignUpUS extends UsecaseWithParams<void, SignUpParams> {
  const SignUpUS(this._authRepo);
  final AuthRepo _authRepo;
  @override
  ResultFuture<void> call(SignUpParams params) => _authRepo.signUp(
      email: params.email,
      fullName: params.fullname,
      password: params.password);
}

class SignUpParams extends Equatable {
  const SignUpParams(
      {required this.email, required this.fullname, required this.password});

  final String email;
  final String fullname;
  final String password;

  const SignUpParams.empty()
      : email = '',
        fullname = '',
        password = '';

  @override
  List<Object?> get props => [email, fullname, password];
}
