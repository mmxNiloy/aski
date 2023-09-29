import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  final int upvotes;
  final int downvotes;
  late String? postID;

  static const String _titleKey = 'title';
  static const String _messageKey = 'message';
  static const String _timestampKey = 'timestamp';
  static const String _ownerIdKey = 'owner_id';
  static const String _visibilityKey = 'visibility';
  static const String _upvotesKey = 'upvotes';
  static const String _downvotesKey = 'downvotes';

  PostsModel(
      {required this.title,
      required this.message,
      required this.ownerId,
      required this.visibility,
      required this.timestamp,
      required this.upvotes,
      required this.downvotes,
      this.postID});

  factory PostsModel.fromJson(Map<String, dynamic> json) {
    return PostsModel(
        title: json[_titleKey],
        message: json[_messageKey],
        ownerId: json[_ownerIdKey],
        visibility: json[_visibilityKey],
        timestamp: json[_timestampKey],
        upvotes: json[_upvotesKey],
        downvotes: json[_downvotesKey]
    );
  }

  @override
  String toString() {
    return 'PostModel: {\n\ttitle: $title\n\tmessage: $message\n\townerId: $ownerId\n\ttimestamp: ${timestamp.toString()}\n\tvisibility: $visibility\n}';
  }

  Map<String, dynamic> toFirestore() {
    return {
      _titleKey: title,
      _messageKey: message,
      _timestampKey: timestamp,
      _ownerIdKey: ownerId,
      _visibilityKey: visibility,
      _upvotesKey: upvotes,
      _downvotesKey: downvotes
    };
  }

  factory PostsModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return PostsModel.fromJson(data!);
  }

  String getStandardTime() {
    final dateFormat = DateFormat("dd-MM-yyyy hh:mm a");
    // TODO: Business logic must be implemented.
    return dateFormat.format(timestamp.toDate());
  }
}
