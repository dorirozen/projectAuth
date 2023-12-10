import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduction_app/core/enums/update_user.dart';
import 'package:eduction_app/core/error/exceptions.dart';
import 'package:eduction_app/core/utils/constans.dart';
import 'package:eduction_app/core/utils/typedef.dart';
import 'package:eduction_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:eduction_app/src/auth/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';
  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;
  late UserCredential userCredential;
  late DocumentReference<DataMap> documentReference;
  late MockUser mockUser;
  //late StreamController streamController;
  const tUser = LocalUserModel.empty();
  const tPassword = 'Test Password';
  const tFullName = 'Test Full Name';
  const tEmail = 'Testemail@gmail.com';
  final fireBaseException = FirebaseAuthException(code: '1');
  const serverException = ServerException(message: 'some', statusCode: '1');
  final exception = Exception('error occurred');
  setUpAll(() async {
    //streamController = StreamController<MockUser?>();
    authClient = MockFirebaseAuth();
    cloudStoreClient = FakeFirebaseFirestore();
    dbClient = MockFirebaseStorage();
    dataSource = AuthRemoteDataSourceImpl(
        authClient: authClient,
        cloudStoreClient: cloudStoreClient,
        dbClient: dbClient);

    ///
    ///
    documentReference = cloudStoreClient.collection('users').doc();
    await documentReference
        .set(tUser.copyWith(uid: documentReference.id).toMap());
    mockUser = MockUser()
      ..uid = documentReference
          .id; // = mockUser = MockUser(); mockUser.uid = documentReference.id;
    userCredential = MockUserCredential(mockUser);

    ///
    ///
    when(() => authClient.currentUser).thenReturn(mockUser);
  });
  group('forgotPassword', () {
    test('should complete when no FirebaseException is thrown', () async {
      when(() => authClient.sendPasswordResetEmail(email: any(named: 'email')))
          .thenAnswer((_) async => Future.value());
      final call = dataSource.forgotPassword;
      expect(call(tEmail), completes);
      verify(() => authClient.sendPasswordResetEmail(email: tEmail)).called(1);
      verifyNoMoreInteractions(authClient);
    });
    test('should throw a [FirebaseException] when failed', () async {
      when(() => authClient.sendPasswordResetEmail(email: tEmail))
          .thenThrow(fireBaseException);
      final call = dataSource.forgotPassword;
      expect(() => call(tEmail), throwsA(isA<ServerException>()));
      verify(() => authClient.sendPasswordResetEmail(email: tEmail)).called(1);
      verifyNoMoreInteractions(authClient);
    });
  });
  group('signIn', () {
    test('should return [LocalUserModel] when no [Exception] is thrown',
        () async {
      when(() => authClient.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => userCredential);

      final res = await dataSource.signIn(email: tEmail, password: tPassword);
      expect(res, isA<LocalUserModel>());
      expect(res.uid, userCredential.user!.uid);
      expect(res.points, 0);
      verify(() => authClient.signInWithEmailAndPassword(
          email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(authClient);
    });

    test('should throw a [ServerException] when [FirebaseException] is thrown',
        () async {
      when(() => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'))).thenThrow(fireBaseException);
      final call = dataSource.signIn;
      expect(() => call(email: tEmail, password: tPassword),
          throwsA(isA<ServerException>()));
      verify(() => authClient.signInWithEmailAndPassword(
          email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(authClient);
    });
    test('should throw a [ServerException] when return value is null',
        () async {
      final emptyUser = MockUserCredential();
      when(() => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'))).thenAnswer((_) async => emptyUser);
      final res = dataSource.signIn(email: tEmail, password: tPassword);
      expect(res, throwsA(isA<ServerException>()));
      verify(() => authClient.signInWithEmailAndPassword(
          email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(authClient);
    });
  });
  group('signUp', () {
    test('should complete succesfully when no [Exception] is thrown', () async {
      when(() => authClient.createUserWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => userCredential);
      when(() => userCredential.user?.updateDisplayName(any()))
          .thenAnswer((_) => Future.value());
      when(() => userCredential.user?.updatePhotoURL(any()))
          .thenAnswer((_) => Future.value());

      final call = dataSource.signUp(
          email: tEmail, fullName: tFullName, password: tPassword);
      expect(call, completes);
      verify(() => authClient.createUserWithEmailAndPassword(
          email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(authClient);
      await untilCalled(() => userCredential.user?.updateDisplayName(any()));
      await untilCalled(() => userCredential.user?.updatePhotoURL(any()));
      verify(() => userCredential.user?.updateDisplayName(tFullName)).called(1);
      verify(() => userCredential.user?.updatePhotoURL(kDefualtAvatar))
          .called(1);
    });
    test('should throw [ServerException] when [FireBaseAuthException] is trown',
        () async {
      when(() => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'))).thenThrow(fireBaseException);
      final call = dataSource.signUp;
      // when the invocation happen , will expect to throw !
      expect(
          () => call(email: tEmail, fullName: tFullName, password: tPassword),
          throwsA(isA<ServerException>()));
      verify(() => authClient.createUserWithEmailAndPassword(
          email: tEmail, password: tPassword)).called(1);
    });
  });

  group('updateUser', () {
    /*
    The registerFallbackValue function in the mocktail library in Flutter is used
    to register a fallback value for a given type, which is necessary for tests
    to call before using [any] or [captureAny] on parameters of that type.
    This function is important for creating effective unit tests in Flutter,
    especially when using mock objects and dependency injection. It ensures
    that the tests have a fallback value to use when a specific type is required,
    allowing the tests to run successfully and provide meaningful results
     */
    setUp(() {
      registerFallbackValue(MockAuthCredential());
    });
    test('should update user displayname when no [Exception] is thrown',
        () async {
      when(() => mockUser.updateDisplayName(any()))
          .thenAnswer((_) async => Future.value());
      await dataSource.updateUser(
          action: UpdateUserAction.displayName, userData: tFullName);
      verify(() => mockUser.updateDisplayName(tFullName)).called(1);
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updatePassword(any()));
      final userData =
          await cloudStoreClient.collection('users').doc(mockUser.uid).get();
      expect(userData.data()!['fullName'], tFullName);
    });
    test('should update user email when no [Exception] is thrown', () async {
      when(() => mockUser.updateEmail(any()))
          .thenAnswer((_) async => Future.value());
      await dataSource.updateUser(
          action: UpdateUserAction.email, userData: tEmail);
      verify(() => mockUser.updateEmail(tEmail)).called(1);

      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));
      verifyNever(() => mockUser.updatePassword(any()));
      final userData =
          await cloudStoreClient.collection('users').doc(mockUser.uid).get();
      expect(userData.data()!['email'], tEmail);
    });

    test('should update user bio when no [Exception] is thrown', () async {
      const tBio = 'asd';
      await dataSource.updateUser(action: UpdateUserAction.bio, userData: tBio);
      final userData = await cloudStoreClient
          .collection('users')
          .doc(documentReference.id)
          .get();
      expect(userData.data()!['bio'], tBio);
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updatePassword(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));
    });
    test('should update user password when no [Exception] is thrown', () async {
      when(() => mockUser.updatePassword(any()))
          .thenAnswer((_) async => Future.value());
      when(() => mockUser.reauthenticateWithCredential(any()))
          .thenAnswer((_) async => userCredential);
      when(() => mockUser.email).thenReturn(tEmail);
      await dataSource.updateUser(
        action: UpdateUserAction.password,
        userData: jsonEncode(
            {'oldPassword': 'oldPassword', 'newPassword': tPassword}),
      );
      verify(() => mockUser.updatePassword(tPassword)).called(1);

      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));
      verifyNever(() => mockUser.updateEmail(any()));
      final userData = await cloudStoreClient
          .collection('users')
          .doc(documentReference.id)
          .get();
      expect(userData.data()!['password'], null);
    });

    test('should update user profilePic when no [Exception] is thrown',
        () async {
      final newProfileImage = File('assets/images/pexels-mo-eid-9454915.jpg');
      when(() => mockUser.updatePhotoURL(any()))
          .thenAnswer((_) async => Future.value());

      await dataSource.updateUser(
          action: UpdateUserAction.profilePic, userData: newProfileImage);
      verify(() => mockUser.updatePhotoURL(any())).called(1);

      verifyNever(() => mockUser.updateDisplayName(any()));
      verifyNever(() => mockUser.updatePassword(any()));
      verifyNever(() => mockUser.updateEmail(any()));

      expect(dbClient.storedFilesMap.isNotEmpty, isTrue);
    });
  });
  /*
  group('AuthStateChanges and CurrentUser', () {
    test('emits user when auth state changes', () async {
      when(() => authClient.idTokenChanges())
          .thenAnswer((_) => Stream.value(mockUser));

      // Start listening to the stream
      final subscription = dataSource.authStateChanges.listen((event) async {
        //streamController.add(mockUser);
        //expect(event, equals(mockUser));
        final mockNewUser = MockUser()..uid = 'NewTestUid';
        streamController.add(mockNewUser);
        await expectLater(
            event?.uid.toString(), equals(mockNewUser.uid.toString()));
      });
      // Cancel the subscription to avoid memory leaks
      subscription.cancel();
    });

    test('returns current user', () {
      when(() => authClient.currentUser).thenReturn(mockUser);

      // Retrieve the current user
      final currentUser = dataSource.currentUser;

      // Your assertion here, for example:
      expect(currentUser, equals(mockUser));
    });
  });
   */
}
