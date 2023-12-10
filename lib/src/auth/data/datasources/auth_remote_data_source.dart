import 'dart:convert';
import 'dart:io';
import 'package:eduction_app/core/enums/update_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduction_app/core/error/exceptions.dart';
import 'package:eduction_app/core/utils/typedef.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/utils/constans.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<void> forgotPassword(
    String email,
  );
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(
      {required FirebaseAuth authClient,
      required FirebaseFirestore cloudStoreClient,
      required FirebaseStorage dbClient})
      : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;
  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;
  @override
  Stream<User?> get authStateChanges => _authClient.idTokenChanges();
  @override
  User? get currentUser => _authClient.currentUser;
  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error Occurred', statusCode: e.code);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<LocalUserModel> signIn(
      {required String email, required String password}) async {
    try {
      final userCredential = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw const ServerException(
          message: 'please try again later',
          statusCode: 'UnKnown Error',
        );
      }
      var userData = await _getUserData(user.uid);
      if (userData.exists) {
        // .exists is from firestore and helps us to check if doc is exists.
        return LocalUserModel.fromMap(userData.data()!);
      }
      // if data is not written to the doc memory , so we will write it.
      // upload the user
      await _setUserData(user, email);
      userData = await _getUserData(user.uid);
      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error Occured', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> signUp(
      {required String email,
      required String fullName,
      required String password}) async {
    try {
      final userCred = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //.then((value) => value.user);....
      await userCred.user?.updateDisplayName(fullName);
      //await userCred     ?.updateDisplayName(fullName); ...
      await userCred.user?.updatePhotoURL(kDefualtAvatar);
      await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error Occured', statusCode: e.code);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> updateUser(
      {required UpdateUserAction action, required userData}) async {
    try {
      switch (action) {
        case UpdateUserAction.email:
          await _authClient.currentUser?.updateEmail(userData as String); //auth
          await _updateUserData({'email': userData}); //firestore
          break;

        case UpdateUserAction.displayName:
          await _authClient.currentUser
              ?.updateDisplayName(userData as String); //auth
          await _updateUserData({'fullName': userData}); //firestore
          break;

        case UpdateUserAction.profilePic:
          // its a non json / string / map thing that can be written in the firestore.
          // so we will need to put that inside the firebase storage ! (its a png file ! ..)
          ///so .. we gonna save the image to cloud storage
          /// 1. we will get the reference
          /// 2. take the ref and use it to put the file in the bucket (bucket = the storage provided to us.)
          /// note: child = > where we want to save it in the buckect.
          // -------
          final ref = _dbClient
              .ref()
              .child('profiles_pic/${_authClient.currentUser?.uid}');
          await ref.putFile(userData as File);
          // -------  saving the file in the address of the storage !!
          final url = await ref.getDownloadURL();
          await _authClient.currentUser?.updatePhotoURL(url); //auth
          await _updateUserData({'profilePic': url}); //firestore
          break;
        case UpdateUserAction
              .password: // we gonna get an old password , and a new password
          if (_authClient.currentUser!.email == null) {
            throw const ServerException(
                message: 'User does not exist',
                statusCode: 'Insufficient Permission');
          }
          final newData = jsonDecode(userData as String) as DataMap;
          await _authClient.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
                email: _authClient.currentUser!.email!,
                password: newData['oldPassword'] as String),
          );
          await _authClient.currentUser
              ?.updatePassword(newData['newPassword'] as String);
          break;

        case UpdateUserAction.bio:
          await _updateUserData({'bio': userData as String});
          break;
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error Occured', statusCode: e.code);
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStoreClient.collection('users').doc(uid).get();

    /// _cloudStoreClient.collection('users')              -> CollectionReference
    //  Gets a reference to the 'users' collection in Firestore.
    /// _cloudStoreClient.collection('users').doc(?)       -> DocumentReference
    // Gets a reference to a specific document within the 'users' collection.
    /// _cloudStoreClient.collection('users').get()        -> Future<QuerySnapshot>
    // Retrieves all documents within the 'users' collection as a QuerySnapshot.
    /// _cloudStoreClient.collection('users').doc(?).get() -> Future<DocumentSnapshot>
    // Retrieves a specific document (user data) within the 'users' collection as a DocumentSnapshot.
    /// _cloudStoreClient.collection('users').snapshots()  -> Stream<QuerySnapshot>
    // ! Creates ! a stream that listens for changes in the 'users' collection and emits QuerySnapshots.
  }

  // fallbackEmail = if the user dont have an email yet...
  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _cloudStoreClient.collection('users').doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            points: 0,
            fullName: user.displayName ?? '',
            profilePic: user.photoURL ?? '',
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap data) async {
    _cloudStoreClient
        .collection('users')
        .doc(_authClient.currentUser?.uid)
        .update(data);
  }
}
