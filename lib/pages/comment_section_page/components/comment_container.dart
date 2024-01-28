import 'package:aski/components/comment_container_shimmer.dart';
import 'package:aski/constants/database_constants.dart';
import 'package:aski/models/comments_model.dart';
import 'package:aski/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentContainer extends StatelessWidget {
  final CommentsModel model;

  const CommentContainer({super.key, required this.model});

  // get commenter info here
  Future<UserModel> _getCommenterInfo() async {
    final dbRef = FirebaseFirestore.instance;
    final collRef = dbRef.collection(UsersCollection.name);
    final docRef = collRef.doc(model.ownerID);

    final docSnap = await docRef.get();
    return UserModel.fromJson(docSnap.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _getCommenterInfo(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Profile picture goes here
                  CircleAvatar(
                    backgroundImage: _renderAvatar(snapshot.data!.profilePicUri),
                  ),
                  Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // User name
                            Text(
                              '${snapshot.data!.firstName} ${snapshot.data!.lastName}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),

                            // Timestamp
                            Text(
                                _getPostTime(),
                                style: Theme.of(context).textTheme.bodySmall,
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            // Comment content
                            Text(
                                model.message,
                              style: Theme.of(context).textTheme.bodyLarge,
                            )

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

        // Error
        if(snapshot.hasError) {
          return const Center(
            child: Card(
              child: Text('Error loading comment!'),
            ),
          );
        }

        // Loading
        return const CommentContainerShimmer();
      },
    );
  }

  ImageProvider? _renderAvatar(String? dpLink) {
    if(dpLink != null && dpLink.isNotEmpty) {
      return NetworkImage(dpLink);
    }

    return const AssetImage('images/profile_image.jpg');
  }

  String _getPostTime() {
    // What's the difference between now and the time it was posted
    int timeDiff = DateTime.now().millisecondsSinceEpoch - model.timestamp!.toDate().millisecondsSinceEpoch;

    // Minutes
    if(60 * 60 * 1000 > timeDiff) {
      int min = timeDiff.toDouble() ~/ (1000.0 * 60.0);
      return '$min minute${min > 1 ? 's' : ''} ago';
    }

    // Hours
    if(24 * 60 * 60 * 1000 > timeDiff) {
      int hrs = timeDiff.toDouble() ~/ (1000.0 * 60.0 * 60.0);
      return '$hrs hour${hrs > 1 ? 's' : ''} ago';
    }

    // Day
    if(7 * 24 * 60 * 60 * 1000 > timeDiff) {
      int days = timeDiff.toDouble() ~/ (1000.0 * 60.0 * 60.0 * 24.0);
      return '$days day${days > 1 ? 's' : ''} ago';
    }

    // Date
    return DateFormat('dd-MMM-yy').format(model.timestamp!.toDate());
  }
}
