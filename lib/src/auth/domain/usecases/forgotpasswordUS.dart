import 'package:eduction_app/core/common/usecases/usecases.dart';
import 'package:eduction_app/core/utils/typedef.dart';
import 'package:eduction_app/src/auth/domain/repos/auth_repo.dart';

class ForgotPasswordUS extends UsecaseWithParams<void, String> {
  final AuthRepo _authRepo;
  const ForgotPasswordUS(this._authRepo);
  @override
  ResultFuture<void> call(String params) => _authRepo.forgotPassword(params);
}
