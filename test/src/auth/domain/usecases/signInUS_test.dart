import 'package:dartz/dartz.dart';
import 'package:eduction_app/src/auth/domain/entites/local_user.dart';
import 'package:eduction_app/src/auth/domain/usecases/signInUS.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  group('SignInUS', () {
    late SignInUS usecase;
    late MockAuthRepo repo;

    setUp(() {
      repo = MockAuthRepo();
      usecase = SignInUS(repo);
    });

    const tEmail = 'test@example.com';
    const tPassword = 'password';
    const signInParams = SignInParams(email: tEmail, password: tPassword);
    final expectedLocalUser = LocalUser.empty();

    test(
        'should sign in with provided '
        'email and password and return the LocalUser'
        ' from AuthRepo', () async {
      when(() => repo.signIn(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => Right(expectedLocalUser));

      final result = await usecase(signInParams);

      expect(result, equals(Right<dynamic, LocalUser>(expectedLocalUser)));
      verify(() => repo.signIn(email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(repo);
    });
  });
}
