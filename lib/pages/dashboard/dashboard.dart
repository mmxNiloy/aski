import 'package:aski/pages/dashboard/components/my_app_bar.dart';
import 'package:aski/pages/dashboard/tabs/ask_question_tab.dart';
import 'package:aski/pages/dashboard/tabs/home_tab.dart';
import 'package:aski/pages/dashboard/tabs/message_tab.dart';
import 'package:flutter/material.dart';

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
        appBar: const MyAppBar(),

        //**Body part Begins from here */
        body: TabBarView(
          children: [
            ///**WIll call the pages */
            const HomeTab(),
            const MessageTab(),
            // const AIAssistantTab(),
            const AskQuestionTab(),
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
