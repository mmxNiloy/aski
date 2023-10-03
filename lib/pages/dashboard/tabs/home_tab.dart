import 'package:aski/components/post_container.dart';
import 'package:aski/constants/database_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aski/models/posts_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<StatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late List<PostsModel> posts;
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _postsStream;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _postsStream = buildQuery(false).snapshots();
  }

  Query<Map<String, dynamic>> buildQuery([bool? isLimited, int? lim]) {
    isLimited ??= true;
    lim ??= 10;

    // Get posts from firebase
    // Read access
    final db = FirebaseFirestore.instance;
    final collRef = db.collection(PostsCollection.name);
    // Get top 10 recent public posts
    // TODO: Show the private posts in another tab
    // Subject to change
    var query = collRef
        .where(PostsCollection.visibilityKey, isEqualTo: PostsCollection.visibilityPublic)
        .orderBy(PostsCollection.timestampKey, descending: true);

    if(isLimited) query = query.limit(lim);

    return query;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: postsStreamBuilder(),
    );
  }

  Widget postsStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
        stream: _postsStream,
        builder: (cotext, snapshot) {
          if(snapshot.hasError) {
            return const Text('Error loading posts');
          }

          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Loading...',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot docSnap){
                Map<String, dynamic> data = docSnap.data()! as Map<String, dynamic>;
                PostsModel mPost = PostsModel.fromJson(data);
                mPost.postID = docSnap.id;

                return PostContainer(
                    model: mPost,
                );
              }).toList().cast(),
            ),
          );
        }
    );
  }
}
