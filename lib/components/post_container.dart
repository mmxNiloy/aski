// Contains posts
// UI element
// Plan: Scale up to accomodate comments, votes(up and down), and [TODO]
import 'package:aski/components/chat_bubble_shimmer.dart';
import 'package:aski/models/posts_model.dart';
import 'package:flutter/material.dart';
import 'package:aski/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostContainer extends StatefulWidget {
  final PostsModel model;

  const PostContainer({super.key, required this.model});

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  late UserModel postOwner;

  @override
  void initState() {
    super.initState();
    setState(() {
      postOwner = UserModel(firstName: "abc", lastName: "def", uid: "1");
    });
  }

  Future<UserModel> getOwnerInfo() async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection('users').doc(widget.model.ownerId).get();
    setState(() {
      postOwner = UserModel.fromJson(snapshot.data()!);
    });
    return postOwner;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: getOwnerInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return drawPostCard();
          }

          if (snapshot.hasError) {
            print("post container error!");
            print(snapshot.error);
            return const Text("Error Loading Post!");
          }

          return const ChatBubbleShimmer();
        });
  }

  Widget drawPostCard() {
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
                      postOwner.getFullName(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Posted on ${widget.model.getStandardTime()}',
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
              widget.model.title,
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
              widget.model.message,
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
    switch (widget.model.visibility) {
      case PostVisibility.POST_PUBLIC:
        return Icons.public;
      case PostVisibility.POST_PRIVATE:
        return Icons.lock;
      default:
        return Icons.warning;
    }
  }
}
