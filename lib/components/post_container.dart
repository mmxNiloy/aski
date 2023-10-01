// Contains posts
// UI element
// Plan: Scale up to accomodate comments, votes(up and down), and [TODO]
// TODO: Take care of the memory leaks dart is freaking out about.
// TODO: Resize the container, blur out excess content, on comment button tap navigate to a page with full post details
import 'package:aski/components/chat_bubble_shimmer.dart';
import 'package:aski/components/post_container_shimmer.dart';
import 'package:aski/models/posts_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aski/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PostContainer extends StatefulWidget {
  final PostsModel model;

  const PostContainer({super.key, required this.model});

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late UserModel postOwner;
  bool isMenuOpen = false;
  VoteType postVote = VoteType.empty;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _voteCountStream;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userVoteObserverStream;
  int upvoteCount = 0;
  int downvoteCount = 0;

  @override
  void initState() {
    super.initState();

    _voteCountStream = getPostRef().snapshots();
    _userVoteObserverStream = getPostRef()
        .collection('voters')
        .doc(uid)
        .snapshots();

    // Manage states for update and stuff
    subscribeToUserVoteChange();

    setState(() {
      postOwner = UserModel(firstName: "abc", lastName: "def", uid: "1");
    });
  }

  void subscribeToUserVoteChange() {
    getPostRef()
        .collection('voters')
        .doc(uid)
        .snapshots().listen((event) {
          if(!event.exists) {
            getPostRef()
                .collection('voters')
                .doc(uid)
                .set({'vote_type': 'empty'});
          } else {
            switch(event.data()!['vote_type']) {
              case 'upvote':
                if(mounted) {
                  setState(() {
                    postVote = VoteType.upvote;
                  });
                }

                break;
              case 'downvote':
                if(mounted) {
                  setState(() {
                    postVote = VoteType.downvote;
                  });
                }
                break;
              default:
                if(mounted) {
                  setState(() {
                    postVote = VoteType.empty;
                  });
                }
                break;
            }
          }
    }, onError: (error) => debugPrint(error));
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
            return const Text("Error Loading Post!");
          }

          return const PostContainerShimmer();
        });
  }

  Widget drawPostCard() {
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            drawCardHeader(),
            const SizedBox(
              height: 8.0,
            ),

            // Title of a Card
            drawCardContent(),
            const SizedBox(height: 8.0),

            // Upvote, downvote, and comments yada yada
            drawCardActions()
          ],
        ),
      ),
    );
  }

  Widget drawCardHeader() {
    // Show User Profile Pic
    // Show User name
    // Show when the post has been posted
    // Menu bar for reporting the post

    return Row(
        children: [
          // Profile Pic Circle Area
          // Grab profile pic from gmail, fb or other platforms
          // Grab from database as well if exists
          // Otherwise placeholder image
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            // Profile pic
            child: Icon(
              Icons.circle_rounded,
              size: 40,
            ),
          ),

          // User Name and post timestamp
          Expanded(
            flex: 1,
            child: Column(
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

                Row(
                  children: [
                    Text(
                      'Posted on ${widget.model.getStandardTime()}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(width: 8,),

                    Icon(getVisibilityIcon(), size: 10),
                  ],
                ),
                // timestamp

              ],
            ),
          ),

          // Options for the post
          // For example, report the post
          PopupMenuButton(
              itemBuilder: (context) => [
                // Report button
                PopupMenuItem(
                    child: ListTile(
                      title: const Text('Report'),
                      leading: const Icon(Icons.report_problem),
                      onTap: reportPost,
                    )
                )
              ]
          ),
        ],
      );
  }

  Widget drawCardContent() {
    // Body and meat of the card
    // Will show the main contents of the post

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post Title
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

        // Post Content
        // TODO: Constraint the box to facilitate a few lines as preview
        HtmlWidget(
          widget.model.message,
          textStyle: const TextStyle(
              overflow: TextOverflow.fade
          ),
        ),
      ],
    );
  }

  Widget drawCardActions() {
    // Show upvote button
    // Show downvote button
    // Show comments button
    return Row(
      children: [
        // Upvote
        Flexible(
          flex: 1,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _voteCountStream,
            builder: (context, snapshot) {
              if(snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  leading: Icon(Icons.arrow_upward),
                  title: Text(''),
                  enabled: false,
                );
              }

              return ListTile(
                leading: drawUpvoteIcon(),
                title: Text(snapshot.data!.data()!['upvotes'].toString()),
                onTap: upvotePost,
              );
            },
          ),
        ),

        // Downvote
        Flexible(
          flex: 1,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _voteCountStream,
            builder: (context, snapshot) {
              if(snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  leading: Icon(Icons.arrow_upward),
                  title: Text(''),
                  enabled: false,
                );
              }

              return ListTile(
                leading: drawDownvoteIcon(),
                title: Text(snapshot.data!.data()!['downvotes'].toString()),
                onTap: downvotePost,
              );
            },
          ),
        ),

        const Spacer(
          flex: 3,
        ),

        // Comment
        Flexible(
          flex: 2,
          child: ListTile(
            trailing: const Icon(Icons.comment),
            title: const Text('Comment', textAlign: TextAlign.end,),
            onTap: viewPostDetails,
          ),
        ),
      ],
    );
  }

  DocumentReference<Map<String, dynamic>> getPostRef() {
    final db = FirebaseFirestore.instance;

    final postRef = db.collection('posts')
        .doc(widget.model.postID);
    return postRef;
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

  Widget drawUpvoteIcon() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _userVoteObserverStream,
      builder: (context, snapshot) {
        if(
          snapshot.hasError ||
          snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data!.data()!['vote_type'] != 'upvote'
        ) {
          return const Icon(Icons.arrow_upward);
        }

        return const Icon(
            Icons.arrow_upward,
            color: Colors.blue,
        );
      },
    );
  }
  Widget drawDownvoteIcon() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _userVoteObserverStream,
      builder: (context, snapshot) {
        if(
        snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data!.data()!['vote_type'] != 'downvote'
        ) {
          return const Icon(Icons.arrow_downward);
        }

        return const Icon(
          Icons.arrow_downward,
          color: Colors.red,
        );
      },
    );
  }

  void reportPost() {
    // TODO: Send a report to the database admin
  }

  Future<void> upvotePost() async {
    if(postVote == VoteType.empty) {
      getPostRef().update({'upvotes': FieldValue.increment(1)});

      getPostRef()
          .collection('voters')
          .doc(uid)
          .update({'vote_type': 'upvote'});
    } else if(postVote == VoteType.upvote) {
      getPostRef().update({'upvotes': FieldValue.increment(-1)});

      getPostRef()
          .collection('voters')
          .doc(uid)
          .update({'vote_type': 'empty'});
    } else {
      getPostRef().update({'upvotes': FieldValue.increment(1)});
      getPostRef().update({'downvotes': FieldValue.increment(-1)});

      getPostRef()
          .collection('voters')
          .doc(uid)
          .update({'vote_type': 'upvote'});
    }
  }

  void downvotePost() {
    if(postVote == VoteType.empty) {
      getPostRef().update({'downvotes': FieldValue.increment(1)});

      getPostRef()
          .collection('voters')
          .doc(uid)
          .update({'vote_type': 'downvote'});
    } else if(postVote == VoteType.downvote) {
      getPostRef().update({'downvotes': FieldValue.increment(-1)});

      getPostRef()
          .collection('voters')
          .doc(uid)
          .update({'vote_type': 'empty'});
    } else {
      getPostRef().update({'upvotes': FieldValue.increment(-1)});
      getPostRef().update({'downvotes': FieldValue.increment(1)});

      getPostRef()
          .collection('voters')
          .doc(uid)
          .update({'vote_type': 'downvote'});
    }
  }

  void viewPostDetails() {
    // TODO: Navigate to post details page
  }
}

enum VoteType {
  empty,
  upvote,
  downvote
}
