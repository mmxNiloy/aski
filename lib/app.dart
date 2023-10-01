import 'package:aski/pages/dashboard/dashboard.dart';
import 'package:aski/pages/main_home_page/main_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Main app layout
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ASKi',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        home: drawLandingPage());
  }

  Widget drawLandingPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return const Dashboard();
        }

        return const MainHomePage();
      },
    );
  }
}
