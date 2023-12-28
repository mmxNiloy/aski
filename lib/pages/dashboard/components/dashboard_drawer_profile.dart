import 'package:flutter/material.dart';

class DashboardDrawerProfile extends StatefulWidget {
  //const DashboardDrawerProfile({super.key});

  @override
  State<DashboardDrawerProfile> createState() => _DashboardDrawerProfileState();
}

class _DashboardDrawerProfileState extends State<DashboardDrawerProfile> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Custom drawer items here
          ListTile(title: Text('Hello Profile Drawer!'),)
        ],
      ),
    );
  }
}
