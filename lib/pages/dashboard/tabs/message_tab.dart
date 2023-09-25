import 'package:aski/components/profile_preview_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({super.key});

  @override
  State<MessageTab> createState() => _MessageTabState();
}

/*
a6ScvTWpcThD56gA3zSfDuD9oW63
*/

class _MessageTabState extends State<MessageTab> {
  late List<UserModel> _users;

  Future<List<UserModel>> getRegisteredUsers() async {
    final db = FirebaseFirestore.instance;

    final collRef = db.collection('users');
    final query = collRef.where(FieldPath.documentId,
        isNotEqualTo: FirebaseAuth.instance.currentUser!.uid);

    final snap = await query.get();

    final List<UserModel> mUsers = [];
    for (var mUser in snap.docs) {
      mUsers.add(UserModel.fromJson(mUser.data()));
    }

    setState(() {
      _users = mUsers;
    });

    return mUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<List<UserModel>>(
            future: getRegisteredUsers(), builder: buildRegisteredUsersList));
  }

  Widget buildRegisteredUsersList(
      BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
    if (snapshot.hasError) return const Text('Error loading data');
    if (snapshot.hasData) {
      final data = snapshot.data!;
      if (data.isEmpty) return const Text('No registered users found');

      return Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        const Text(
          'Registered Users',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ProfilePreviewContainer(model: _users[index]);
            },
            scrollDirection: Axis.vertical,
            shrinkWrap: true),
      ]);
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator(), Text('Loading...')],
      ),
    );
  }
}
