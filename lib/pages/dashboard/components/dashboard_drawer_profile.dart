import 'package:aski/models/posts_model.dart';
import 'package:aski/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardDrawerProfile extends StatefulWidget {
  final UserModel? user;
  const DashboardDrawerProfile({super.key, this.user});

  //const DashboardDrawerProfile({super.key});

  @override
  State<DashboardDrawerProfile> createState() => _DashboardDrawerProfileState();
}

class _DashboardDrawerProfileState extends State<DashboardDrawerProfile> {
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
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: MediaQuery.of(context).orientation == Orientation.portrait
                ? 2
                : 6,
            child: DrawerHeader(
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: CircleAvatar(
                      minRadius: MediaQuery.of(context).size.width / 8,
                      maxRadius: MediaQuery.of(context).size.width / 4,
                      backgroundColor: const Color.fromARGB(255, 178, 175, 175),
                      foregroundImage: const NetworkImage(
                        "https://media.istockphoto.com/id/1476170969/photo/portrait-of-young-man-ready-for-job-business-concept.webp?b=1&s=170667a&w=0&k=20&c=FycdXoKn5StpYCKJ7PdkyJo9G5wfNgmSLBWk3dI35Zw=",
                      ), //! Profile picture needed
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.user == null ? 
                      "Username":
                      '${widget.user!.firstName} ${widget.user!.lastName}', //! User name needed
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 30,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: MediaQuery.of(context).orientation == Orientation.portrait
                ? 3
                : 4,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              children: [
                OutlinedButton(
                  onPressed: () {
                    logout(context);
                  },
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Logout"),
                      ]),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Settings"),
                      ]), //! Other Funtionalities should be added
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
