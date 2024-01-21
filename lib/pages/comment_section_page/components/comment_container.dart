import 'package:aski/models/comments_model.dart';
import 'package:flutter/material.dart';

class CommentContainer extends StatelessWidget {
  final CommentsModel model;

  const CommentContainer({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Profile picture goes here
          const CircleAvatar(),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username
                  // Todo: get username from database
                  Text(model.ownerID, style: const TextStyle(fontWeight: FontWeight.bold),),

                  // Comment content
                  Text(model.message)

                  // Todo: show timestamp
                  // Todo: upvote/downvote for comments here
                  // Optional: reply feature
                ],
              ),
            )
          )
        ],
      )
    );
  }
}
