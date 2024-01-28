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

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin<HomeTab> {
  @override
  bool get wantKeepAlive => true;

  late List<PostsModel> posts;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _postsStream;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    loadPosts();
  }

  Future<void> loadPosts() async {
    setState(() {
      _postsStream = buildQuery(false).get().asStream();
    });
  }

  Query<Map<String, dynamic>> buildQuery([bool? isLimited, int? lim]) {
    isLimited ??= true;
    lim ??= 10;

    // Get posts from firebase
    // Read access
    final db = FirebaseFirestore.instance;
    final collRef = db.collection(PostsCollection.name);
    // Get top 10 recent public posts
    // Subject to change
    var query = collRef.orderBy(PostsCollection.timestampKey, descending: true);

    if (isLimited) query = query.limit(lim);

    return query;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: postsStreamBuilder(),
    );
  }

  Widget postsStreamBuilder() {
    return RefreshIndicator(
      onRefresh: loadPosts,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _postsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              const snackBar = SnackBar(
                content: Text('Error loading posts'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                children: snapshot.data!.docs
                    .map((DocumentSnapshot<Map<String, dynamic>> docSnap) {
                      Map<String, dynamic> data = docSnap.data()!;
                      PostsModel mPost = PostsModel.fromJson(data);
                      mPost.postID = docSnap.id;

                      return PostContainer(
                        model: mPost,
                        isPreview: true,
                      );
                    })
                    .toList()
                    .cast(),
              ),
            );
          }),
    );
  }
}
