// Contains posts
// UI element
// Plan: Scale up to accomodate comments, votes(up and down), and [TODO]
import 'package:aski/models/posts_model.dart';
import 'package:flutter/material.dart';

class PostContainer extends StatelessWidget {
  final PostsModel model;

  const PostContainer({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Profile Section in Row
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  child: Icon(
                    Icons.circle_rounded,
                    size: 40,
                  ),
                ),

                ///* Profile pic
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // username
                    Text(
                      model.ownerId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Posted on ${model.getStandardTime()}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            //* Title of a Card
            Text(
              model.title,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            //* Post is here
            Text(
              model.message,
              maxLines: 3,
              style: const TextStyle(overflow: TextOverflow.fade),
            ),
            const SizedBox(height: 8.0),
            //** Visibility part */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(getVisibilityIcon()),
                // IconButton(
                //   icon: const Icon(Icons.visibility),
                //   onPressed: () {
                //     // Implement visibility toggle logic here
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData? getVisibilityIcon() {
    switch (model.visibility) {
      case PostVisibility.POST_PUBLIC:
        return Icons.public;
      case PostVisibility.POST_PRIVATE:
        return Icons.lock;
      default:
        return Icons.warning;
    }
  }
}
