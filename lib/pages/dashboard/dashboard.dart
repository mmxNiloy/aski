import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aski/models/user_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<UserModel> fUser;

  Future<UserModel> getUserInfo() async {
    final db = FirebaseFirestore.instance;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await db.collection('users').doc(uid).get();

    if(!doc.exists) throw Exception('User data not found.');

    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fUser = getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Wrap(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  const Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 32
                    ),
                  ),
                  Text(
                    'UID: ${FirebaseAuth.instance.currentUser?.uid}',
                    style: const TextStyle(
                        fontSize: 28
                    ),
                  ),
                  FutureBuilder(
                    future: fUser,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return Text('First Name: ${snapshot.data!.firstName}, Last Name: ${snapshot.data!.lastName}');
                      } else if(snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return const CircularProgressIndicator();
                    },
                  ),
                  OutlinedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      child: const Text('Log out')
                  ),
                  OutlinedButton(
                      onPressed: () {
                        final city = <String, String>{
                          "name": "Los Angeles",
                          "state": "CA",
                          "country": "USA"
                        };

                        final db = FirebaseFirestore.instance;
                        db.collection('users')
                          .doc('example123')
                          .set(city).onError((error, stackTrace) => debugPrint('Error inserting, $error'));
                      },
                      child: const Text('Add dummy data')
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}