import '../../../../core/common/usecases/usecases.dart';
import '../../../../core/utils/typedef.dart';
import '../repos/on_boarding_repo.dart';

class CacheFirstTimer extends UsecaseWithOutParams<void> {
  const CacheFirstTimer(this._repo);
  final OnBoardingRepo _repo;

  @override
  ResultFuture<void> call() async => _repo.cacheFirstTimer();
}
