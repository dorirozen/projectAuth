import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:eduction_app/core/error/failures.dart';
import 'package:eduction_app/src/auth/data/models/user_model.dart';
import 'package:eduction_app/src/auth/domain/usecases/forgotpasswordUS.dart';
import 'package:eduction_app/src/auth/domain/usecases/signInUS.dart';
import 'package:eduction_app/src/auth/domain/usecases/signUpUS.dart';
import 'package:eduction_app/src/auth/domain/usecases/updateUserUS.dart';
import 'package:eduction_app/src/auth/presention/bloc/auth_bloc.dart';
import 'package:eduction_app/src/auth/presention/bloc/auth_event.dart';
import 'package:eduction_app/src/auth/presention/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignInUS extends Mock implements SignInUS {}

class MockSignUpUS extends Mock implements SignUpUS {}

class MockForgotPasswordUS extends Mock implements ForgotPasswordUS {}

class MockUpdateUserUS extends Mock implements UpdateUserUS {}

/// for learning purposes
// while we test , if inside what we are testing there is a non normal type
// like .. String , Int etc.. we need to fallBack that ! because the mocktail not mocking that.
// and we need to make sure it will initialize.

void main() {
  late SignInUS signInUS;
  late SignUpUS signUpUS;
  late UpdateUserUS updateUserUS;
  late ForgotPasswordUS forgotPasswordUS;
  late AuthBloc bloc;

  const tSignInParams = SignInParams.empty();
  const tSignUpParams = SignUpParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();
  const tUser = LocalUserModel.empty();
  final tServer = ServerFailure(message: 'message', statusCode: '1');
  setUp(() async {
    signInUS = MockSignInUS();
    signUpUS = MockSignUpUS();
    updateUserUS = MockUpdateUserUS();
    forgotPasswordUS = MockForgotPasswordUS();
    bloc = AuthBloc(
      forgotPassowrd: forgotPasswordUS,
      signIn: signInUS,
      signUp: signUpUS,
      updateUser: updateUserUS,
    );
  });
  tearDown(() =>
      bloc.close()); // so that the bloc state will not leak to the next test

  setUpAll(() {
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tUpdateUserParams);
  });

  test('first state should be [AuthStateInitial]', () {
    expect(bloc.state, const AuthStateInitial());
  });

  group('signIn', () {
    blocTest<AuthBloc, AuthState>(
        'should emit [AuthStateLoading, AuthStateSignedIn] when [AuthEventSignIn] is added',
        build: () {
          when(() => signInUS(any()))
              .thenAnswer((_) async => const Right(tUser));
          return bloc;
        },
        act: (bloc) => bloc.add(AuthEventSignIn(
            email: tSignInParams.email, password: tSignInParams.password)),
        expect: () => const [AuthStateLoading(), AuthStateSignedIn(tUser)],
        verify: (_) {
          verify(() => signInUS(tSignInParams)).called(1);
          verifyNoMoreInteractions(signInUS);
        });
    blocTest<AuthBloc, AuthState>(
        'should emit [AuthStateLoading, AuthStateError] when failed to add',
        build: () {
          when(() => signInUS(any())).thenAnswer((_) async => Left(tServer));
          return bloc;
        },
        act: (bloc) => bloc.add(AuthEventSignIn(
            email: tSignInParams.email, password: tSignInParams.password)),
        expect: () =>
            [const AuthStateLoading(), AuthStateError(tServer.errorMessage)],
        verify: (_) {
          verify(() => signInUS(tSignInParams)).called(1);
          verifyNoMoreInteractions(signInUS);
        });
  });

  group('signUp', () {
    blocTest(
        'should emit [AuthStateLoading,AuthStateSignedUp] when [AuthEventSignUp] is added',
        build: () {
          when(() => signUpUS(any()))
              .thenAnswer((_) async => const Right(null));
          return bloc;
        },
        act: (bloc) => bloc.add(AuthEventSignUp(
            email: tSignUpParams.email,
            name: tSignUpParams.fullname,
            password: tSignUpParams.password)),
        expect: () => const [AuthStateLoading(), AuthStateSignedUp()],
        verify: (_) {
          verify(() => signUpUS(tSignUpParams)).called(1);
          verifyNoMoreInteractions(signUpUS);
        });
    blocTest(
        'should emit [AuthStateLoading,AuthStateError] when [AuthEventSignUp] failed',
        build: () {
          when(() => signUpUS(any())).thenAnswer((_) async => Left(tServer));
          return bloc;
        },
        act: (bloc) => bloc.add(AuthEventSignUp(
            email: tSignUpParams.email,
            name: tSignUpParams.fullname,
            password: tSignUpParams.password)),
        expect: () =>
            [const AuthStateLoading(), AuthStateError(tServer.errorMessage)],
        verify: (_) {
          verify(() => signUpUS(tSignUpParams)).called(1);
          verifyNoMoreInteractions(signUpUS);
        });
  });

  group('forgotPassword', () {
    const tEmail = 'do';
    blocTest(
        'should emit [AuthStateLoading,AuthStateForgotPassword] when [AuthEventForgotPassword] is added',
        build: () {
          when(() => forgotPasswordUS(any()))
              .thenAnswer((_) async => const Right(null));
          return bloc;
        },
        act: (bloc) => bloc.add(const AuthEventForgotPassword(
              email: tEmail,
            )),
        expect: () => const [AuthStateLoading(), AuthStateForgotPassword()],
        verify: (_) {
          verify(() => forgotPasswordUS(tEmail)).called(1);
          verifyNoMoreInteractions(forgotPasswordUS);
        });
    blocTest(
        'should emit [AuthStateLoading,AuthStateError] when [AuthEventForgotPassword] failed',
        build: () {
          when(() => forgotPasswordUS(any()))
              .thenAnswer((_) async => Left(tServer));
          return bloc;
        },
        act: (bloc) => bloc.add(const AuthEventForgotPassword(
              email: tEmail,
            )),
        expect: () =>
            [const AuthStateLoading(), AuthStateError(tServer.errorMessage)],
        verify: (_) {
          verify(() => forgotPasswordUS(tEmail)).called(1);
          verifyNoMoreInteractions(forgotPasswordUS);
        });
  });

  group('updateUser', () {
    blocTest(
        'should emit [AuthStateLoading,AuthStateUpdateUser] when [AuthEventUpdateUser] is added',
        build: () {
          when(() => updateUserUS(any()))
              .thenAnswer((_) async => const Right(null));
          return bloc;
        },
        act: (bloc) => bloc.add(AuthEventUpdateUser(
            userData: tUpdateUserParams.userData,
            action: tUpdateUserParams.action)),
        expect: () => const [AuthStateLoading(), AuthStateUpdateUser()],
        verify: (_) {
          verify(() => updateUserUS(tUpdateUserParams)).called(1);
          verifyNoMoreInteractions(updateUserUS);
        });
    blocTest(
        'should emit [AuthStateLoading,AuthStateError] when [AuthEventUpdateUser] failed',
        build: () {
          when(() => updateUserUS(any()))
              .thenAnswer((_) async => Left(tServer));
          return bloc;
        },
        act: (bloc) => bloc.add(AuthEventUpdateUser(
            action: tUpdateUserParams.action,
            userData: tUpdateUserParams.userData)),
        expect: () =>
            [const AuthStateLoading(), AuthStateError(tServer.errorMessage)],
        verify: (_) {
          verify(() => updateUserUS(tUpdateUserParams)).called(1);
          verifyNoMoreInteractions(updateUserUS);
        });
  });
}
