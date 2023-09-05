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

  // Get posts to view
  Future<List<PostsModel>> getPosts() async {
    // Get posts from firebase
    // Read access
    final db = FirebaseFirestore.instance;
    final collRef = db.collection('posts');
    // Get top 10 recent posts
    // Subject to change
    final query = collRef.limit(10).orderBy('timestamp', descending: true);

    // Execute query
    final snapshot = await query.get();

    // Bind data
    List<PostsModel> posts = [];
    for(var docSnap in snapshot.docs) {
      posts.add(PostsModel.fromJson(docSnap.data()));
    }

    setState(() {
      this.posts = posts;
    });

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<PostsModel>>(
        // TODO: Add futurebuilder
        future: getPosts,
        builder: (BuildContext context, AsyncSnapshot),
      ),
    );
  }

}