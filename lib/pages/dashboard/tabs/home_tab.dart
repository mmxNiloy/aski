import 'package:aski/components/post_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final collRef = db.collection('posts');
    // Get top 10 recent public posts
    // TODO: Show the private posts in another tab
    // Subject to change
    var query = collRef
        .where('visibility', isEqualTo: 'public')
        .orderBy('timestamp', descending: true);

    if(isLimited) query = query.limit(lim);

    return query;
  }

  // Get posts to view
  Future<List<PostsModel>> getPosts() async {
    final query = buildQuery();

    // Execute query
    final snapshot = await query.get();

    // Bind data
    List<PostsModel> posts = [];
    print("post owners:");
    for (var docSnap in snapshot.docs) {
      posts.add(PostsModel.fromJson(docSnap.data()));
      posts.last.postID = docSnap.id;
      print(posts.last.ownerId);
    }
    print("End post owners.");

    setState(() {
      this.posts = posts;
    });

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: postsStreamBuilder(),
    );
  }

  Widget postsFutureBuilder() {
    return FutureBuilder<List<PostsModel>>(
      // TODO: Add futurebuilder
      future: getPosts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PostsModel>> snapshot) {
        // Show posts if available
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return PostContainer(model: snapshot.data!.elementAt(index));
              },
            ),
          );
        }
        // Otherwise return a placeholder (404 page like message) "Posts not found" component(widget)

        // On Error
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Text('Error loading posts');
        }
        // On Loading
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
      },
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
                return PostContainer(model: mPost);
              }).toList().cast(),
            ),
          );
        }
    );
  }
}
