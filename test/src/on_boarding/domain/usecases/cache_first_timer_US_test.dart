import 'package:dartz/dartz.dart';
import 'package:eduction_app/core/error/failures.dart';
import 'package:eduction_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:eduction_app/src/on_boarding/domain/usecases/cache_first_timer_US.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CacheFirstTimer usecase;
  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CacheFirstTimer(repo);
  });

  test(
      'should call the [ MockOnBoardingRepo , CacheFirstTimer ] and return the right data',
      () async {
    when(() => repo.cacheFirstTimer()).thenAnswer(
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
        equals(Left(
            ServerFailure(message: 'UnKnown Error Occured', statusCode: 500))));
    verify(() => repo.cacheFirstTimer()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
