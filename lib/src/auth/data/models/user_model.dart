import 'package:eduction_app/src/auth/domain/entites/local_user.dart';

import '../../../../core/utils/typedef.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel(
      {required super.uid,
      required super.email,
      required super.points,
      required super.fullName,
      super.groupId,
      super.enrolledCourseIds,
      super.following,
      super.followers,
      super.profilePic,
      super.bio});

  /// will help me when doing tests.
  const LocalUserModel.empty()
      : this(
          email: '',
          fullName: '',
          points: 0,
          uid: '',
        );
  LocalUserModel.fromMap(DataMap map)
      : super(
          uid: map['uid'] as String,
          email: map['email'] as String,
          points: (map['points'] as num).toInt(),
          fullName: map['fullName'] as String,
          profilePic: map['profilePic'] as String?,
          bio: map['bio'] as String?,
          groupId:

              /// good and basic !
              // map['groupId'] as List<String>
              // becuse maybe after it will not be just string..)
              // (we want that to be dynamic !
              /// not good ! map['groupId'] as List<dynamic>
              // it doesn't provide type safety!!
              /// !-good-! List<String>.from(map['groupId'] as List<dynamic>),
              // use the List.from constructor to create a new list with
              //elements from the original list. The List.from
              // constructor allows you to specify the type of the
              // elements in the new list
              /// another way
              // The cast method returns a new iterable with elements of the specified type
              (map['groupId'] as List<dynamic>).cast<String>(),
          enrolledCourseIds:
              (map['enrolledCourseIds'] as List<dynamic>).cast<String>(),
          followers: (map['followers'] as List<dynamic>).cast<String>(),
          following: (map['following'] as List<dynamic>).cast<String>(),
        );

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'profilePic': profilePic,
      'bio': bio,
      'points': points,
      'fullName': fullName,
      'groupId': groupId,
      'enrolledCourseIds': enrolledCourseIds,
      'following': following,
      'followers': followers,
    };
  }

  LocalUserModel copyWith({
    String? uid,
    String? email,
    String? profilePic,
    String? bio,
    int? points,
    String? fullName,
    List<String>? groupId,
    List<String>? enrolledCourseIds,
    List<String>? following,
    List<String>? followers,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      fullName: fullName ?? this.fullName,
      groupId: groupId ?? this.groupId,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }
}
