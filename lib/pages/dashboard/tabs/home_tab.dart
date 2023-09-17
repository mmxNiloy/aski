import 'package:aski/components/post_container.dart';
import 'package:aski/components/rich_text_editor.dart';
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
    final query = collRef.orderBy('timestamp', descending: true).limit(10);

    // Execute query
    final snapshot = await query.get();

    // Bind data
    List<PostsModel> posts = [];
    for (var docSnap in snapshot.docs) {
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
      ),
    );
  }
}
