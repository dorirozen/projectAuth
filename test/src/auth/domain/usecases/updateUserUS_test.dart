import 'package:dartz/dartz.dart';
import 'package:eduction_app/core/enums/update_user.dart';
import 'package:eduction_app/src/auth/domain/repos/auth_repo.dart';
import 'package:eduction_app/src/auth/domain/usecases/updateUserUS.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late UpdateUserUS usecase;
  late AuthRepo repo;

  setUp(() {
    repo = MockAuthRepo();
    usecase = UpdateUserUS(repo);
  });

  const action = UpdateUserAction.displayName;
  const userData = 'New Display Name';
  const updateUserParams = UpdateUserParams(action: action, userData: userData);
  group('UpdateUserUS', () {
    test('should update user with provided action and user data successfully',
        () async {
      when(() => repo.updateUser(
            action: action,
            userData: userData,
          )).thenAnswer((_) async => const Right(null));
      final result = await usecase(updateUserParams);

      // Assert
      expect(result, equals(const Right(null)));
      verify(() => repo.updateUser(
            action: action,
            userData: userData,
          )).called(1);
      verifyNoMoreInteractions(repo);
    });
  });
}
