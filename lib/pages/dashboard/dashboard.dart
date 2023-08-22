import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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
                  OutlinedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                      },
                      child: const Text('Log out')
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