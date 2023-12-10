import 'package:eduction_app/core/utils/typedef.dart';
import '../../../../core/common/usecases/usecases.dart';
import '../repos/on_boarding_repo.dart';

class CheckIfUserFirstTimer extends UsecaseWithOutParams<bool> {
  // returning bool..
  const CheckIfUserFirstTimer(this._repo);
  final OnBoardingRepo _repo;

  @override
  ResultFuture<bool> call() => _repo.checkIfUserIsFirstTimer();
}
