/*
!! Important
i) Put '[x]' symbol next to a task/sub-task if it has been implemented successfully.
ii) Put '[w]' symbol next to a task/sub-task if it is being worked on.
iii) Put '[d]' symbol next to a task/sub-task if it needs debugging.
iv) Put '[u]' symbol next to a task/sub-task if it needs unit testing.
v) Otherwise don't put anything.

This is the landing page.
-- Task --
1. Logo at the top
2. Login form
3. Login button
4. Account Recovery Option
5. Login methods
6. Sign-up button

-- Subtask 2: Login form --
i) Email: Input Text Field
ii) Password: Input Text Field
iii) Email validation
iv) Password length validation
v) Show error message, refer to material error text
vi) Login: Button
vii) Enable Login button if the given creds pass primary validation

-- Subtask 3: Login button --
i) Use Firebase auth
ii) Show an error dialog on failure.
iii) Redirect to dashboard on success.

-- Subtask 4: Account Recovery Option --
i) Redirect to account recovery page

-- Subtask 5: Login Methods --
i) Google, Facebook, Twitter, etc
ii) Show an error dialog on failure.
iii) Redirect to dashboard on success.

-- Subtask 6: Sign-up button --
i) Redirect to sign-up page
*/

import 'package:flutter/material.dart';
import './components/login_form.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<StatefulWidget> createState() => MainHomePageState();
}

class MainHomePageState extends State<MainHomePage> {
  // Declare child components here
  LoginForm loginForm = const LoginForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Wrap(
              children: <Widget>[
                Card(
                  child: loginForm,
                )
              ],
            )
        )
    );
  }

}