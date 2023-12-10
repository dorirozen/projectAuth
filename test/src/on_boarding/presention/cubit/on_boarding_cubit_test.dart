import 'package:dartz/dartz.dart';
import 'package:eduction_app/core/error/exceptions.dart';
import 'package:eduction_app/core/error/failures.dart';
import 'package:eduction_app/src/on_boarding/domain/usecases/cache_first_timer_US.dart';
import 'package:eduction_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:eduction_app/src/on_boarding/presention/cubit/on_boarding_cubit.dart';
import 'package:eduction_app/src/on_boarding/presention/cubit/on_boarding_cubit_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'on_boarding_cubit.mock.dart';

void main() {
  late CheckIfUserFirstTimer checkIfUserFirstTime;
  late CacheFirstTimer cacheFirstTimer;
  late OnBoardingCubit cubit;

  setUp(() {
    checkIfUserFirstTime = MockCheckIfUserFirstTimer();
    cacheFirstTimer = MockCacheFirstTimer();
    cubit = OnBoardingCubit(
        cacheFirstTimer: cacheFirstTimer,
        checkIfUserFirstTime: checkIfUserFirstTime);
  });

  final cFailure = CacheFailure(
    message: 'message',
    statusCode: 4032,
  );
  group('all checks', () {
    test('initial state should be [OnBoardingInitialState]', () {
      expect(cubit.state, const OnBoardingInitialState());
    });
    group('cacheFirstTimer', () {
      blocTest<OnBoardingCubit, OnBoardingCubitState>(
        'should emit [CachingFirstTimerState,UserCachedState] when successful',
        build: () {
          when(() => cacheFirstTimer()).thenAnswer(
            (_) async => const Right(null),
          );
          return cubit;
        },
        act: (cubit) => cubit.cacheFirstTimer(),
        expect: () => const [CachingFirstTimerState(), UserCachedState()],
        verify: (_) {
          verify(() => cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );

      blocTest<OnBoardingCubit, OnBoardingCubitState>(
        'should emit [CachingFirstTimerState,OnBoardingErrorState] when failed.',
        build: () {
          when(() => cacheFirstTimer()).thenAnswer(
            (_) async => Left(cFailure),
          );
          return cubit;
        },
        act: (cubit) => cubit.cacheFirstTimer(),
        expect: () => [
          const CachingFirstTimerState(),
          OnBoardingErrorState(message: cFailure.errorMessage),
        ],
        verify: (_) {
          verify(() => cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );
    });
    group('checkIfUserFirstTimer', () {
      ///CheckingIfUserIsFirstTimerState OnBoardingStatusState
      blocTest<OnBoardingCubit, OnBoardingCubitState>(
        'should emit [CheckingIfUserIsFirstTimerState,OnBoardingStatusState] when successful',
        build: () {
          when(() => checkIfUserFirstTime()).thenAnswer(
            (_) async => const Right(true),
          );
          return cubit;
        },
        act: (cubit) => cubit.checkIfUserFirstTimer(),
        expect: () => const [
          CheckingIfUserIsFirstTimerState(),
          OnBoardingStatusState(isFirstTimer: true)
        ],
        verify: (_) {
          verify(() => checkIfUserFirstTime()).called(1);
          verifyNoMoreInteractions(checkIfUserFirstTime);
        },
      );
      blocTest<OnBoardingCubit, OnBoardingCubitState>(
        'should emit [CheckingIfUserIsFirstTimerState,OnBoardingStatusState] when failed'
        ' and OnBoardingStatusState is forced to be true',
        build: () {
          when(() => checkIfUserFirstTime()).thenAnswer(
            (_) async => Left(cFailure),
          );
          return cubit;
        },
        act: (cubit) => cubit.checkIfUserFirstTimer(),
        expect: () => const [
          CheckingIfUserIsFirstTimerState(),
          OnBoardingStatusState(isFirstTimer: true)
        ],
        verify: (_) {
          verify(() => checkIfUserFirstTime()).called(1);
          verifyNoMoreInteractions(checkIfUserFirstTime);
        },
      );
    });
  });
}
