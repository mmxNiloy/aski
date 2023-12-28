import 'package:aski/constants/database_constants.dart';

class CommentsModel {
  final String ownerID;
  final String message;
  // TODO: Add a timestamp of each comment (both in the db and here)

  CommentsModel({
    required this.ownerID,
    required this.message,
  });

  factory CommentsModel.fromJSON(Map<String, dynamic> json) {
    // TODO: Convert the database object to dart readable object
    return CommentsModel(
      ownerID: json[PostCommentsSubCollection.ownerIDKey],
      message: json[PostCommentsSubCollection.messageKey]
    );
  }
}