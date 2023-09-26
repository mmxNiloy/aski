import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../dashboard_search_icon.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
                  showSearch(context: context, delegate: MySearchDelegate());
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
              onTap: () => logout(context),
              child: const ListTile(
                title: Text('Log out'),
                leading: Icon(Icons.logout),
              ),
            ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 8,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(255, 16, 55, 1),
            Color.fromRGBO(245, 175, 13, 1),
          ], begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.popUntil(
        context,
        ModalRoute.withName("/"),
      );
    }

    return;
  }

  @override
  Size get preferredSize => Size.fromHeight(150);
}
