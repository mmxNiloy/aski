// Contains posts
// UI element
// Plan: Scale up to accomodate comments, votes(up and down), and [TODO]
// TODO: Take care of the memory leaks dart is freaking out about.
// TODO: Resize the container, blur out excess content, on comment button tap navigate to a page with full post details
import 'dart:math';

import 'package:aski/components/post_container_shimmer.dart';
import 'package:aski/constants/database_constants.dart';
import 'package:aski/models/posts_model.dart';
import 'package:aski/pages/comment_section_page/comment_section_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aski/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PostContainer extends StatefulWidget {
  final PostsModel model;
  final bool isPreview;

  const PostContainer(
      {super.key, required this.model, required this.isPreview});

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late UserModel postOwner;
  VoteType postVote = VoteType.empty;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _voteCountStream;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userVoteObserverStream;

  @override
  void initState() {
    super.initState();

    _voteCountStream = getPostRef().snapshots();
    _userVoteObserverStream = getPostRef()
        .collection(PostVotersSubCollection.name)
        .doc(uid)
        .snapshots();

    // Manage states for update and stuff
    subscribeToUserVoteChange();

    setState(() {
      postOwner = UserModel(firstName: "", lastName: "", uid: "");
    });
  }

  void subscribeToUserVoteChange() {
    getPostRef()
        .collection(PostVotersSubCollection.name)
        .doc(uid)
        .snapshots()
        .listen((event) {
      if (!event.exists) {
        getPostRef().collection(PostVotersSubCollection.name).doc(uid).set({
          PostVotersSubCollection.voteTypeKey:
              PostVotersSubCollection.voteTypeEmpty
        });
      } else {
        switch (event.data()![PostVotersSubCollection.voteTypeKey]) {
          case PostVotersSubCollection.voteTypeUpVote:
            if (mounted) {
              setState(() {
                postVote = VoteType.upvote;
              });
            }

            break;
          case PostVotersSubCollection.voteTypeDownVote:
            if (mounted) {
              setState(() {
                postVote = VoteType.downvote;
              });
            }
            break;
          default:
            if (mounted) {
              setState(() {
                postVote = VoteType.empty;
              });
            }
            break;
        }
      }
    }, onError: (error) => debugPrint('Post Container error >${error.toString()}'));
  }

  Future<UserModel> getOwnerInfo() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db
        .collection(UsersCollection.name)
        .doc(widget.model.ownerId)
        .get();
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
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            drawCardHeader(),
            Divider(
              color: Theme.of(context).dividerColor,
            ),
            const SizedBox(
              height: 8.0,
            ),

            // Title of a Card
            drawCardContent(),
            const SizedBox(height: 8.0),

            Divider(
              color: Theme.of(context).dividerColor,
            ),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          // Profile pic
          child: CircleAvatar(
            foregroundImage: _renderAvatar(),
            backgroundImage: const AssetImage('images/profile_image.jpg'),
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
                  const SizedBox(
                    width: 8,
                  ),
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
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ))
                ]),
      ],
    );
  }

  Widget drawCardContent() {
    // Body and meat of the card
    // Will show the main contents of the post

    return InkWell(
      onTap: viewPostDetails,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Title
          Text(
            widget.model.title,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.fade,
            ),
          ),

          const SizedBox(
            height: 8.0,
          ),

          // Post Content
          widget.model.content.isEmpty
              ? const Text('')
              : Text(
                  widget.model.content,
                  maxLines: 5,
                  overflow: TextOverflow.fade,
                ),

          // Post images
          widget.model.imgRefs.isEmpty
              ? const Text('')
              : SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.model.imgRefs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 50,
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.height / 50),
                        child: Image.network(
                          widget.model.imgRefs.elementAt(index),
                          height: MediaQuery.of(context).size.height / 5,
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
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
              if (snapshot.hasError ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  leading: Icon(Icons.arrow_upward),
                  title: Text(''),
                  enabled: false,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                );
              }

              return ListTile(
                leading: drawUpVoteIcon(),
                title: Text(snapshot.data!
                    .data()![PostsCollection.upVotesKey]
                    .toString()),
                onTap: upVotePost,
                dense: true,
                contentPadding: EdgeInsets.zero,
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
              if (snapshot.hasError ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  leading: Icon(Icons.arrow_upward),
                  title: Text(''),
                  enabled: false,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                );
              }

              return ListTile(
                leading: drawDownVoteIcon(),
                title: Text(snapshot.data!
                    .data()![PostsCollection.downVotesKey]
                    .toString()),
                onTap: downVotePost,
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            },
          ),
        ),

        const Spacer(
          flex: 1,
        ),

        // Comment
        Flexible(
          flex: 2,
          child: ListTile(
            leading: const Icon(
              Icons.comment,
            ),
            title: const Text(
              'Comment',
            ),
            onTap: viewPostDetails,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  DocumentReference<Map<String, dynamic>> getPostRef() {
    final db = FirebaseFirestore.instance;

    final postRef =
        db.collection(PostsCollection.name).doc(widget.model.postID);
    return postRef;
  }

  Widget drawUpVoteIcon() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _userVoteObserverStream,
      builder: (context, snapshot) {
        if (snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data!.data()![PostVotersSubCollection.voteTypeKey] !=
                PostVotersSubCollection.voteTypeUpVote) {
          return const Icon(Icons.arrow_upward);
        }

        return const Icon(
          Icons.arrow_upward,
          color: Colors.blue,
        );
      },
    );
  }

  Widget drawDownVoteIcon() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _userVoteObserverStream,
      builder: (context, snapshot) {
        if (snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data!.data()![PostVotersSubCollection.voteTypeKey] !=
                PostVotersSubCollection.voteTypeDownVote) {
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

  void upVotePost() {
    if (postVote == VoteType.empty) {
      getPostRef()
          .update({PostsCollection.upVotesKey: FieldValue.increment(1)});

      getPostRef().collection(PostVotersSubCollection.name).doc(uid).update({
        PostVotersSubCollection.voteTypeKey:
            PostVotersSubCollection.voteTypeUpVote
      });
    } else if (postVote == VoteType.upvote) {
      getPostRef()
          .update({PostsCollection.upVotesKey: FieldValue.increment(-1)});

      getPostRef().collection(PostVotersSubCollection.name).doc(uid).update({
        PostVotersSubCollection.voteTypeKey:
            PostVotersSubCollection.voteTypeEmpty
      });
    } else {
      getPostRef()
          .update({PostsCollection.upVotesKey: FieldValue.increment(1)});
      getPostRef()
          .update({PostsCollection.downVotesKey: FieldValue.increment(-1)});

      getPostRef().collection(PostVotersSubCollection.name).doc(uid).update({
        PostVotersSubCollection.voteTypeKey:
            PostVotersSubCollection.voteTypeUpVote
      });
    }
  }

  void downVotePost() {
    if (postVote == VoteType.empty) {
      getPostRef()
          .update({PostsCollection.downVotesKey: FieldValue.increment(1)});

      getPostRef().collection(PostVotersSubCollection.name).doc(uid).update({
        PostVotersSubCollection.voteTypeKey:
            PostVotersSubCollection.voteTypeDownVote
      });
    } else if (postVote == VoteType.downvote) {
      getPostRef()
          .update({PostsCollection.downVotesKey: FieldValue.increment(-1)});

      getPostRef().collection(PostVotersSubCollection.name).doc(uid).update({
        PostVotersSubCollection.voteTypeKey:
            PostVotersSubCollection.voteTypeEmpty
      });
    } else {
      getPostRef()
          .update({PostsCollection.upVotesKey: FieldValue.increment(-1)});
      getPostRef()
          .update({PostsCollection.downVotesKey: FieldValue.increment(1)});

      getPostRef().collection(PostVotersSubCollection.name).doc(uid).update({
        PostVotersSubCollection.voteTypeKey:
            PostVotersSubCollection.voteTypeDownVote
      });
    }
  }

  void viewPostDetails() {
    showModalBottomSheet(
      context: context,
      builder: (context) => FractionallySizedBox(
          heightFactor: 0.9,
          child: CommentSectionPage(postID: widget.model.postID!)),
      isScrollControlled: true,
    );
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => CommentSectionPage(postID: widget.model.postID!))
    // );
  }

  ImageProvider? _renderAvatar() {
    if(postOwner.profilePicUri != null && postOwner.profilePicUri!.isNotEmpty) {
      return NetworkImage(postOwner.profilePicUri!);
    }

    return null;
  }
}

enum VoteType { empty, upvote, downvote }
