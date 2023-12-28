import 'package:aski/models/comments_model.dart';
import 'package:flutter/material.dart';

class CommentContainer extends StatelessWidget {
  final CommentsModel model;

  const CommentContainer({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: Column(
        children: [
          Text(
            'Posted by: ${model.ownerID}'
          ),
          Text(
            'Content: ${model.message}'
          )
        ],
      ),
    );
  }
}
