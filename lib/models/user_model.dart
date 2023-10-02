import 'package:aski/constants/database_constants.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String? profilePicUri;
  final String uid;

  UserModel({
    required this.firstName,
    required this.lastName,
    this.profilePicUri,
    required this.uid
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json[UsersCollection.fNameKey],
      lastName: json[UsersCollection.lNameKey],
      profilePicUri: json[UsersCollection.pPicUriKey],
      uid: json[UsersCollection.uidKey]
    );
  }

  Map<String, dynamic> toMapObject() {
    final userMap = <String, dynamic>{
      UsersCollection.fNameKey: firstName,
      UsersCollection.lNameKey: lastName,
      UsersCollection.pPicUriKey: profilePicUri,
      UsersCollection.uidKey: uid,
    };
    return userMap;
  }

  String getFullName() {
    return "$firstName $lastName";
  }
}