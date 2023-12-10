import 'package:dartz/dartz.dart';
import 'package:eduction_app/core/error/failures.dart';
import 'package:eduction_app/core/utils/typedef.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repos/on_boarding_repo.dart';
import '../datasources/on_boarding_local_data_source.dart';

class OnBoardingRepoImpl implements OnBoardingRepo {
  OnBoardingRepoImpl(this._onBoardingLocalDataSource);
  final OnBoardingLocalDataSource _onBoardingLocalDataSource;
  @override
  ResultFuture<void> cacheFirstTimer() async {
    try {
      await _onBoardingLocalDataSource.cacheFirstTimer();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<bool> checkIfUserIsFirstTimer() async {
    try {
      final res = await _onBoardingLocalDataSource.checkIfUserFirstTimer();
      return Right(res);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
