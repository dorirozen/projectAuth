import 'package:dartz/dartz.dart';
import 'package:eduction_app/core/error/failures.dart';
import 'package:eduction_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:eduction_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

///לא סיימתי !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
void main() {
  late OnBoardingRepo repo;
  late CheckIfUserFirstTimer usecase;
  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CheckIfUserFirstTimer(repo);
  });
  group('checking all', () {
    test(
        'should call the [ MockOnBoardingRepo , CacheFirstTimer ] and return the right data',
        () async {
      //arrange
      when(() => repo.checkIfUserIsFirstTimer())
          .thenAnswer((_) async => const Right(true));
      //act
      final result = await usecase();
      //check
      expect(result, equals(const Right<dynamic, bool>(true)));
      verify(() => repo.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(repo);
    });

    test(
        'should call the [ MockOnBoardingRepo , CacheFirstTimer ] and return the right data bool is false',
        () async {
      //arrange
      when(() => repo.checkIfUserIsFirstTimer())
          .thenAnswer((_) async => const Right(false));
      //act
      final result = await usecase();
      //check
      expect(result, equals(const Right<dynamic, bool>(false)));
      verify(() => repo.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(repo);
    });

    test(
        'should call the [ MockOnBoardingRepo , CacheFirstTimer ] and return the right data',
        () async {
      when(() => repo.checkIfUserIsFirstTimer()).thenAnswer(
        (_) async => Left(
          ServerFailure(
            message: 'UnKnown Error Occured',
            statusCode: 500,
          ),
        ),
      );

      final result = await usecase();
      //The argument type 'Future> function()' cant be assigned to the parameter type 'Futura> Function() Function(Invocation)'.
      expect(
          result,
          equals(Left(ServerFailure(
              message: 'UnKnown Error Occured', statusCode: 500))));
      verify(() => repo.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(repo);
    });
  });
}
