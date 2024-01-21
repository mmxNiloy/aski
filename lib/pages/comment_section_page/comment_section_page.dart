import 'package:aski/constants/database_constants.dart';
import 'package:aski/models/posts_model.dart';
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
    // TODO: implement initState
    super.initState();

    _stream = buildQuery().get().asStream();
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
    // Get top 10 recent public posts
    // TODO: Show the private posts in another tab
    // Subject to change

    // TODO: Create a key for comments
    //  using the timestamp in firebase firestore
    // var query = commentCollRef
    //     .orderBy(PostsCollection.timestampKey, descending: true);
    //
    // if(isLimited) query = query.limit(lim);

    return commentCollRef;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Flexible(
              flex: 9,
              child: commentsStreamBuilder()
          ),
          Flexible(
              flex: 1,
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write a comment',
                  suffix: IconButton(
                      onPressed: postComment,
                      icon: Icon(Icons.send)
                  ),
                ),
              )
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

        if(snapshot.hasData) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> comments = snapshot.data!.docs;

          if(comments.isEmpty) return const Center(child: Text("No comments yet."));
          // for(var i = 0 ; i < 10 ; i++) {
          //   comments.add(comments.first);
          // }

          return ListView(
            children: comments.map(
                (DocumentSnapshot<Map<String, dynamic>> docSnap) {
                  return CommentContainer(
                      model: CommentsModel.fromJSON(docSnap.data()!)
                  );
                }
            ).toList().cast(),
          );
        }

        return const Center(child: Text("No comments yet."));
      },
    );
  }

  Future<void> postComment() async {
    String comment = _commentController.text.trim();

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
