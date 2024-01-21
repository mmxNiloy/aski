import 'package:aski/constants/database_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  final String ownerID;
  final String message;
  Timestamp? timestamp;
  // TODO: Add a timestamp of each comment (both in the db and here)

  CommentsModel({
    required this.ownerID,
    required this.message,
    this.timestamp,
  });

  factory CommentsModel.fromJSON(Map<String, dynamic> json) {
    // TODO: Convert the database object to dart readable object
    return CommentsModel(
      ownerID: json[PostCommentsSubCollection.ownerIDKey],
      message: json[PostCommentsSubCollection.messageKey],
      timestamp: json[PostCommentsSubCollection.timestampKey]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      PostCommentsSubCollection.ownerIDKey: ownerID,
      PostCommentsSubCollection.messageKey: message,
      PostCommentsSubCollection.timestampKey: timestamp,
    };
  }
}