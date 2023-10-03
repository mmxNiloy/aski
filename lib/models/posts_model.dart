import 'package:aski/constants/database_constants.dart';
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
        title: json[PostsCollection.titleKey],
        message: json[PostsCollection.messageKey],
        ownerId: json[PostsCollection.ownerIdKey],
        visibility: json[PostsCollection.visibilityKey],
        timestamp: json[PostsCollection.timestampKey],
        upvotes: json[PostsCollection.upVotesKey],
        downvotes: json[PostsCollection.downVotesKey]
    );
  }

  @override
  String toString() {
    return 'PostModel: {\n\ttitle: $title\n\tmessage: $message\n\townerId: $ownerId\n\ttimestamp: ${timestamp.toString()}\n\tvisibility: $visibility\n}';
  }

  Map<String, dynamic> toFirestore() {
    return {
      PostsCollection.titleKey: title,
      PostsCollection.messageKey: message,
      PostsCollection.timestampKey: timestamp,
      PostsCollection.ownerIdKey: ownerId,
      PostsCollection.visibilityKey: visibility,
      PostsCollection.upVotesKey: upvotes,
      PostsCollection.downVotesKey: downvotes
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
