import 'package:dartz/dartz.dart';
import 'package:eduction_app/core/error/failures.dart';
import 'package:eduction_app/src/auth/domain/repos/auth_repo.dart';
import 'package:eduction_app/src/auth/domain/usecases/forgotpasswordUS.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo authRepo;
  late ForgotPasswordUS usecase;

  setUp(() {
    authRepo = MockAuthRepo();
    usecase = ForgotPasswordUS(authRepo);
  });
  const String theEmail = 'theEmail';
  test('', () async {
    when(() => authRepo.forgotPassword(any<String>()))
        .thenAnswer((_) async => const Right(null));
    final res = await usecase(theEmail);
    expect(res, equals(const Right<dynamic, void>(null)));
    verify(() => authRepo.forgotPassword(any())).called(1);
    verifyNoMoreInteractions(authRepo);
  });
}
