import 'package:aski/constants/database_constants.dart';
import 'package:aski/models/posts_model.dart';
import 'package:aski/models/user_model.dart';
import 'package:aski/pages/dashboard/components/dashboard_drawer_main.dart';
import 'package:aski/pages/dashboard/components/dashboard_drawer_profile.dart';
import 'package:aski/pages/dashboard/components/my_app_bar.dart';
import 'package:aski/pages/dashboard/tabs/ask_ai_assistant_tab.dart';
import 'package:aski/pages/dashboard/tabs/ask_question_tab.dart';
import 'package:aski/pages/dashboard/tabs/home_tab.dart';
import 'package:aski/pages/dashboard/tabs/message_tab.dart';
import 'package:aski/pages/dashboard/tabs/notifications_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _navbarIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  UserModel? _mUser;

  Future<UserModel> _getUserInfo() async {
    // Get user uid
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Get user info
    final docSnap = await FirebaseFirestore.instance
        .collection(UsersCollection.name)
        .doc(uid)
        .get();

    final json = docSnap.data()!;

    return UserModel.fromJson(json);
  }

  final List<Widget> _tabs = [
    const HomeTab(),
    const MessageTab(),
    const AskQuestionTab(),
    const NotificationsTab(),
  ];

  final List<NavigationDestination> _bottomNavItems = [
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: "Home",
    ),
    const NavigationDestination(
        icon: Icon(Icons.message_outlined),
        selectedIcon: Icon(Icons.message),
        label: 'Message'),
    const NavigationDestination(
        icon: Icon(Icons.add_circle_outline),
        selectedIcon: Icon(Icons.add_circle),
        label: 'Ask'),
    const NavigationDestination(
        icon: Icon(Icons.notifications_outlined),
        selectedIcon: Icon(Icons.notifications),
        label: 'Notifications'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///**AppBar*/
      appBar: AppBar(
        title: const Text('ASKi'),
        actions: [
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              style: ElevatedButton.styleFrom(shape: const CircleBorder()),
              child: const CircleAvatar(),
            ),
          ),
        ],
      ),
      // Main drawer
      drawer: const DashboardDrawerMain(),
      endDrawer: FutureBuilder<UserModel>(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DashboardDrawerProfile(
              user: snapshot.data,
            );
          }

          if (snapshot.hasError) {
            return const Drawer(
              child: Center(child: Text('Error loading user info')),
            );
          }

          return const Drawer(
            child: Center(child: Text('Loading...')),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: _bottomNavItems,
        selectedIndex: _navbarIndex,
        onDestinationSelected: handleNavbarChange,
      ),

      //**Body part Begins from here */
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _tabs,
      ),
    );
  }

  void handleNavbarChange(int value) {
    setState(() {
      if (value == 2) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AskQuestionTab()));
      } else {
        _navbarIndex = value;
        _pageController.jumpToPage(value);
      }
    });
  }
}
