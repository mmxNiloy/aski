import 'package:aski/constants/database_constants.dart';
import 'package:aski/models/posts_model.dart';
import 'package:aski/pages/comment_section_page/components/comment_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      appBar: AppBar(
        title: const Text('ASKi'),
        leading: IconButton(
            onPressed: handleBackButton,
            icon: const Icon(Icons.keyboard_arrow_left)
        ),
      ),
      body: commentsStreamBuilder(),

      // Comment text field, it will route to a new page where a user
      // can write their comment in a text editor.
      bottomSheet: TextField(
        textAlign: TextAlign.left,
        onTap: handleComment,
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
          return const Text("Loading...");
        }

        if(snapshot.hasData) {
          return ListView(
            children: snapshot.data!.docs.map(
                (DocumentSnapshot<Map<String, dynamic>> docSnap) {
                  return CommentContainer(
                      model: CommentsModel.fromJSON(docSnap.data()!)
                  );
                }
            ).toList().cast(),
          );
        }

        return const Text("No comments yet.");
      },
    );
  }
}
