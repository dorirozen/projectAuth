import 'package:equatable/equatable.dart';

abstract class OnBoardingCubitState extends Equatable {
  const OnBoardingCubitState();
  @override
  List<Object?> get props => [];
}

///initial
class OnBoardingInitialState extends OnBoardingCubitState {
  const OnBoardingInitialState();
}

///cacheFirstTimer
class CachingFirstTimerState extends OnBoardingCubitState {
  const CachingFirstTimerState();
}

class UserCachedState extends OnBoardingCubitState {
  const UserCachedState();
}

///CheckIfUserFirstTimer
class CheckingIfUserIsFirstTimerState extends OnBoardingCubitState {
  const CheckingIfUserIsFirstTimerState();
}

class OnBoardingStatusState extends OnBoardingCubitState {
  const OnBoardingStatusState({required this.isFirstTimer});
  final bool isFirstTimer;

  @override
  List<bool> get props => [isFirstTimer];
}

/// Global State Error
class OnBoardingErrorState extends OnBoardingCubitState {
  const OnBoardingErrorState({required this.message});
  final String message;

  @override
  List<String> get props => [message];
}
