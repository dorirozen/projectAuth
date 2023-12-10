import 'package:dartz/dartz.dart';
import 'package:eduction_app/src/auth/domain/repos/auth_repo.dart';
import 'package:eduction_app/src/auth/domain/usecases/signUpUS.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late SignUpUS usecase;
  late AuthRepo repo;

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignUpUS(repo);
  });

  test(
      'should sign up with provided email, fullname, and password successfully',
      () async {
    // Arrange
    const email = 'test@example.com';
    const fullname = 'John Doe';
    const password = 'password';
    const signUpParams =
        SignUpParams(email: email, fullname: fullname, password: password);

    // Mock the behavior of the authRepo.signUp method for a successful case
    when(() => repo.signUp(
          email: email,
          fullName: fullname,
          password: password,
        )).thenAnswer((_) async => const Right(null));

    final result = await usecase(signUpParams);

    expect(result, equals(const Right<dynamic, void>(null)));
    verify(() => repo.signUp(
          email: email,
          fullName: fullname,
          password: password,
        )).called(1);
    verifyNoMoreInteractions(repo);
  });
}
