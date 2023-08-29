import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aski/pages/dashboard/dashboard_search_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aski/models/user_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        ///**AppBar .. appbar sundor er kaj sesh a*/
        appBar: AppBar(
          title: const Text(
            'Aski',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      showSearch(
                          context: context, delegate: MySearchDelegate());
                    }, //todo
                    icon: const Icon(
                      Icons.search_outlined,
                      semanticLabel: "Search",
                    ),
                    color: Colors.black,
                  ),
                ],
              ),
            ),

            //**Popup menu - Setting,Preference and Logout */
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: OutlinedButton(
                    onPressed: () {}, //todo
                    child: const Text('Setting'),
                  ),
                ),
                PopupMenuItem(
                  child: OutlinedButton(
                    onPressed: () {}, //todo
                    child: const Text('Preference'),
                  ),
                ),
                PopupMenuItem(
                    onTap: () {
                      FirebaseAuth.instance.signOut();

                      Navigator.pop(context);
                    },
                    child: OutlinedButton(
                        onPressed: () {
                          null;
                        },
                        child: const Text('Log out'))),
              ],
            ),
          ],

          ///*** Tab bar part.  */
          bottom: const TabBar(
            isScrollable: true,
            dividerColor: Colors.black,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                text: "Home",
                child: null, //todo
              ),
              Tab(
                icon: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                text: "Message",
                child: null, //todo
              ),
              Tab(
                icon: Icon(
                  Icons.question_mark_outlined,
                  color: Colors.white,
                ),
                text: "Ask a Question",
                child: null, //todo
              ),
              Tab(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                text: "Notifications",
                child: null, //todo
              ),
            ],
          ),
          backgroundColor: const Color.fromRGBO(125, 194, 246, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 8,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(255, 16, 55, 1),
                Color.fromRGBO(245, 175, 13, 1),
              ], begin: Alignment.bottomRight, end: Alignment.bottomLeft),
            ),
          ),
        ),

        //**Body part Begins from here */
        body: TabBarView(
          children: [
            ///**WIll call the pages */
            buildPage('Home Page'),
            buildPage('Message'),
            buildPage('Ask a question'),
            buildPage('Notifications')
          ],
        ),
      ),
    );
  }
}

Widget buildPage(String text) => Center(
        child: Text(
      text,
      style: const TextStyle(fontSize: 28.0),
    ));




// Center(
//           child: Wrap(
//             children: <Widget>[
//               Card(
//                 child: Column(
//                   children: <Widget>[
//                     const Text(
//                       'Welcome',
//                       style: TextStyle(fontSize: 32),
//                     ),
//                     Text(
//                       'UID: ${FirebaseAuth.instance.currentUser?.uid}',
//                       style: const TextStyle(fontSize: 28),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
