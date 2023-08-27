class UserModel {
  final String firstName;
  final String lastName;
  final String? profilePicUri;

  static const String _fNameKey = 'first_name';
  static const String _lNameKey = 'last_name';
  static const String _pPicUriKey = 'profile_pic_uri';

  UserModel({required this.firstName, required this.lastName, this.profilePicUri});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json[_fNameKey],
      lastName: json[_lNameKey],
      profilePicUri: json[_pPicUriKey]
    );
  }

  Map<String, dynamic> toMapObject() {
    final userMap = <String, dynamic>{
      _fNameKey: firstName,
      _lNameKey: lastName,
      _pPicUriKey: profilePicUri
    };
    return userMap;
  }
}