import 'package:aski/constants/database_constants.dart';
import 'package:aski/pages/comment_section_page/components/comment_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aski/models/comments_model.dart';

class CommentSectionPage extends StatefulWidget {
  final String postID;

  const CommentSectionPage({super.key, required this.postID});

  @override
  State<CommentSectionPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<CommentSectionPage> {
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;
  final TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _stream = buildQuery().snapshots();
  }

  Query<Map<String, dynamic>> buildQuery([bool? isLimited, int? lim]) {
    isLimited ??= true;
    lim ??= 10;

    // Get posts from firebase
    // Read access
    final db = FirebaseFirestore.instance;
    final collRef = db.collection(PostsCollection.name);
    final docRef = collRef.doc(widget.postID);
    final commentCollRef = docRef.collection(PostCommentsSubCollection.name);

    return commentCollRef
        .orderBy(
      FieldPath.fromString(PostCommentsSubCollection.timestampKey),
      descending: true
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
              child: commentsStreamBuilder()
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment',
                suffix: IconButton(
                    onPressed: postComment,
                    icon: const Icon(Icons.send)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleBackButton() {
    Navigator.of(context).pop();
  }

  void handleComment() {
    // TODO: Handle comment route change(push)
  }

  Widget commentsStreamBuilder() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _stream,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return const Text("Error loading comments!");
        }

        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Loading...')
                ],
              )
          );
        }

        return ListView(
          children: snapshot.data!.docs.map(
                  (DocumentSnapshot<Map<String, dynamic>> docSnap) {
                    Map<String, dynamic> json = docSnap.data()!;
                return CommentContainer(
                    model: CommentsModel.fromJSON(json)
                );
              }
          ).toList().cast(),
        );
      },
    );
  }

  Future<void> postComment() async {
    String comment = _commentController.text.trim();

    _commentController.clear();

    User mUser = FirebaseAuth.instance.currentUser!;
    if(comment.isEmpty) return;

    // try to post the comment to the database
    final dbRef = FirebaseFirestore.instance;
    final postsRef = dbRef.collection(PostsCollection.name);
    final postRef = postsRef.doc(widget.postID);
    final commentsRef = postRef.collection(PostCommentsSubCollection.name);

    final commentRef = await commentsRef.add(
      CommentsModel(
          ownerID: mUser.uid,
          message: comment,
          timestamp: Timestamp.now()
      ).toJson()
    );
  }
}
