import 'package:eduction_app/core/utils/typedef.dart';

import '../../../../core/enums/update_user.dart';
import '../entites/local_user.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<void> forgotPassword(String email);

  ResultFuture<LocalUser> signIn(
      {required String email, required String password});

  ResultFuture<void> signUp(
      {required String email,
      required String fullName,
      required String password});

  ResultFuture<void> updateUser(
      {required UpdateUserAction action,
      dynamic
          userData}); //i thought about implementing userData will be a map , and then we can do copywith and change the things that are not null..
  //ResultFuture<void> signOut();
}
