import 'package:cloud_firestore/cloud_firestore.dart';

class PostVisibility {
  static const String POST_PUBLIC = 'public';
  static const String POST_PRIVATE = 'private';
}

class PostsModel {
  final String title;
  final String message;
  final Timestamp timestamp;
  final String ownerId;
  final String visibility;

  static const String _titleKey = 'title';
  static const String _messageKey = 'message';
  static const String _timestampKey = 'timestamp';
  static const String _ownerIdKey = 'owner_id';
  static const String _visibilityKey = 'visibility';

  PostsModel({required this.title, required this.message, required this.ownerId, required this.visibility, required this.timestamp});

  factory PostsModel.fromJson(Map<String, dynamic> json) {
    return PostsModel(
        title: json[_titleKey],
        message: json[_messageKey],
        ownerId: json[_ownerIdKey],
        visibility: json[_visibilityKey],
        timestamp: json[_timestampKey]
    );
  }
}