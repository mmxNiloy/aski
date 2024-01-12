import 'package:aski/pages/dashboard/components/dashboard_drawer_main.dart';
import 'package:aski/pages/dashboard/components/dashboard_drawer_profile.dart';
import 'package:aski/pages/dashboard/components/my_app_bar.dart';
import 'package:aski/pages/dashboard/tabs/ask_question_tab.dart';
import 'package:aski/pages/dashboard/tabs/home_tab.dart';
import 'package:aski/pages/dashboard/tabs/message_tab.dart';
import 'package:aski/pages/dashboard/tabs/notifications_tab.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _navbarIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  List<Widget> _tabs = [
    HomeTab(),
    MessageTab(),
    AskQuestionTab(),
    NotificationsTab(),
  ];

  List<NavigationDestination> _bottomNavItems = [
    NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: "Home",
    ),
    NavigationDestination(
        icon: Icon(Icons.message_outlined),
        selectedIcon: Icon(Icons.message),
        label: 'Message'
    ),
    NavigationDestination(
        icon: Icon(Icons.add_circle_outline),
        selectedIcon: Icon(Icons.add_circle),
        label: 'Ask'
    ),
    NavigationDestination(
        icon: Icon(Icons.notifications_outlined),
        selectedIcon: Icon(Icons.notifications),
        label: 'Notifications'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        ///**AppBar*/
        appBar: AppBar(
          title: const Text('ASKi'),
          actions: [
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder()
                ),
                child: const CircleAvatar(),
              ),
            ),
          ],
        ),
        // Main drawer
        drawer: DashboardDrawerMain(),
        endDrawer: DashboardDrawerProfile(),
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: _bottomNavItems,
          selectedIndex: _navbarIndex,
          onDestinationSelected: handleNavbarChange,
        ),

        //**Body part Begins from here */
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: _tabs,
        ),
      ),
    );
  }

  void handleNavbarChange(int value) {
    setState(() {
      _navbarIndex = value;
      _pageController.jumpToPage(value);
    });
  }
}

Widget buildPage(String text) => Center(
        child: Text(
      text,
      style: const TextStyle(fontSize: 28.0),
    ));
