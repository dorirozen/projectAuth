import 'package:dartz/dartz.dart';
import 'package:eduction_app/core/error/exceptions.dart';
import 'package:eduction_app/core/error/failures.dart';
import 'package:eduction_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:eduction_app/src/on_boarding/data/repos_impl/on_boarding_repo_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'OnBoardingLocalDataSource.mock.dart';

void main() {
  late OnBoardingRepoImpl repoImpl;
  late OnBoardingLocalDataSource localDataSource;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSource();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });
  group('checking all', () {
    group('CacheFirstTimer checking .', () {
      test('checking if datasource sets a bool type', () async {
        when(() => localDataSource.cacheFirstTimer())
            .thenAnswer((_) async => Future.value);
        final res = await repoImpl.cacheFirstTimer();
        expect(res, const Right<dynamic, void>(null));
        verify(() => localDataSource.cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(localDataSource);
      });

      test(
          'should return [CacheFailure] when call to local source is unsccessful',
          () async {
        when(() => localDataSource.cacheFirstTimer())
            .thenThrow(const CacheException(message: 'Insufficient storage'));
        final res = await repoImpl.cacheFirstTimer();

        expect(
            res,
            Left<CacheFailure, dynamic>(CacheFailure(
                message: 'Insufficient storage', statusCode: 500)));
        verify(() => localDataSource.cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(localDataSource);
      });
    });

    group('checkifFirstTimer', () {
      test('should return bool true if all ok  ', () async {
        when(() => localDataSource.checkIfUserFirstTimer())
            .thenAnswer((_) async => Future.value(true));
        final res = await repoImpl.checkIfUserIsFirstTimer();
        expect(res, const Right<dynamic, bool>(true));
        verify(() => localDataSource.checkIfUserFirstTimer()).called(1);
        verifyNoMoreInteractions(localDataSource);
      });

      test('should return bool false if not ok  ', () async {
        when(() => localDataSource.checkIfUserFirstTimer())
            .thenAnswer((_) async => Future.value(false));
        final res = await repoImpl.checkIfUserIsFirstTimer();
        expect(res, const Right<dynamic, bool>(false));
        verify(() => localDataSource.checkIfUserFirstTimer()).called(1);
        verifyNoMoreInteractions(localDataSource);
      });

      test('if error caught will return cacheFailure', () async {
        when(() => localDataSource.checkIfUserFirstTimer())
            .thenThrow(const CacheException(message: 'failed get cached data'));
        final res = await repoImpl.checkIfUserIsFirstTimer();
        expect(
            res,
            Left(CacheFailure(
                message: 'failed get cached data', statusCode: 500)));
        verify(() => localDataSource.checkIfUserFirstTimer()).called(1);
        verifyNoMoreInteractions(localDataSource);
      });
    });
  });
}
