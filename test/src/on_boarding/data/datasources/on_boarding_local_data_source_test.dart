import 'package:eduction_app/core/error/exceptions.dart';
import 'package:eduction_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'SharedPreferences.mock.dart';

void main() {
  late SharedPreferences pref;
  late OnBoardingLocalDataSource localDataSrcImpl;

  setUp(() {
    pref = MockSharedPreferences();
    localDataSrcImpl = OnBoardingLocalDataSrcImpl(pref);
  });
  group('all', () {
    group('cacheFirstTimer', () {
      test('should call shared_preferences  to cache the data', () async {
        when(() => pref.setBool(any(), any())).thenAnswer((_) async => true);

        await localDataSrcImpl.cacheFirstTimer();
        verify(() => pref.setBool(kFirstTimerKey, false)).called(1);
        verifyNoMoreInteractions(pref);
      });

      test('should throw a cache exception when failed to cache the data ',
          () async {
        when(() => pref.setBool(any(), any())).thenThrow(Exception());
        final method = localDataSrcImpl.cacheFirstTimer();
        expect(method, throwsA(isA<CacheException>()));
        verify(() => pref.setBool(kFirstTimerKey, false)).called(1);
        verifyNoMoreInteractions(pref);
      });
    });

    group('checkIfUserFirstTimer', () {
      test(
          'should call [sharedPreferences] to check if user '
          'is first timer and return the right response from '
          'storage when data exists', () async {
        when(() => pref.getBool(any())).thenReturn(false);

        final res = await localDataSrcImpl.checkIfUserFirstTimer();
        expect(res, false);
        verify(() => pref.getBool(any())).called(1);
        verifyNoMoreInteractions(pref);
      });

      test('should return true if there is no storage', () async {
        when(() => pref.getBool(any())).thenReturn(null);
        final res = await localDataSrcImpl.checkIfUserFirstTimer();
        expect(res, true);
        verify(() => pref.getBool(any())).called(1);
        verifyNoMoreInteractions(pref);
      });

      test('should throw cache exception when failed to check the storage',
          () async {
        when(() => pref.getBool(any())).thenThrow(Exception());
        final res = localDataSrcImpl.checkIfUserFirstTimer();
        expect(res, throwsA(isA<CacheException>()));
        verify(() => pref.getBool(any())).called(1);
        verifyNoMoreInteractions(pref);
      });
    });
  });
}
