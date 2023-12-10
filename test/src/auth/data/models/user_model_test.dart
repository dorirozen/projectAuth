import 'dart:convert';

import 'package:eduction_app/core/utils/typedef.dart';
import 'package:eduction_app/src/auth/data/models/user_model.dart';
import 'package:eduction_app/src/auth/domain/entites/local_user.dart';
import 'package:test/test.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();
  final tMap = jsonDecode(fixture('user.json')) as DataMap;

  test(
    'should be a sunclass of LocalUser entity..',
    () => expect(tLocalUserModel, isA<LocalUser>()),
  );
  group('fromMap', () {
    test('should return a valid LocalUserModel from map', () {
      final res = LocalUserModel.fromMap(tMap);
      expect(res, isA<LocalUserModel>());
      expect(res, equals(tLocalUserModel));
    });

    test('should throw an error if the map is not match', () {
      final errorMap = DataMap.from(tMap)..remove('uid');
      const call = LocalUserModel.fromMap;
      expect(() => call(errorMap), throwsA(isA<Error>()));
    });
  });
  group('toMap', () {
    test('should return a valid [DataMap] from the model', () {
      final res = tLocalUserModel.toMap();
      expect(res, equals(tMap));
    });
  });
  group('copyWith', () {
    test('should return a valid [LocalUserModel]with updated values', () {
      final res = tLocalUserModel.copyWith(uid: '2');
      expect(res.uid, '2');
    });
  });
}
