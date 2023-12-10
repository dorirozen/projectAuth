import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eduction_app/src/on_boarding/domain/usecases/check_if_user_first_time.dart';
import 'package:eduction_app/src/on_boarding/presention/cubit/on_boarding_cubit_state.dart';

import '../../domain/usecases/cache_first_timer_US.dart';

class OnBoardingCubit extends Cubit<OnBoardingCubitState> {
  OnBoardingCubit(
      {required CacheFirstTimer cacheFirstTimer,
      required CheckIfUserFirstTimer checkIfUserFirstTime})
      : _cacheFirstTimer = cacheFirstTimer,
        _checkIfUserFirstTime = checkIfUserFirstTime,
        super(const OnBoardingInitialState());

  final CacheFirstTimer _cacheFirstTimer;
  final CheckIfUserFirstTimer _checkIfUserFirstTime;

  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimerState());
    final res = await _cacheFirstTimer();
    res.fold(
        (failure) => emit(OnBoardingErrorState(message: failure.errorMessage)),
        (_) => emit(const UserCachedState()));
  }

  Future<void> checkIfUserFirstTimer() async {
    emit(const CheckingIfUserIsFirstTimerState());
    final res = await _checkIfUserFirstTime();

    /// we want to force that if there is an error so the app will not crash and instead
    /// the app can try to set the info from the start.
    res.fold(
      (failure) => emit(const OnBoardingStatusState(isFirstTimer: true)),
      (status) => emit(OnBoardingStatusState(isFirstTimer: status)),
    );
  }
}
