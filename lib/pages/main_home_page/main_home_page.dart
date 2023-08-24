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
i) Email: Input Text Field [x]
ii) Password: Input Text Field [x]
iii) Email validation [x]
iv) Password length validation [x]
v) Show error message, refer to material error text [x]
vi) Login: Button [x]
vii) Enable Login button if the given creds pass primary validation

-- Subtask 3: Login button --
i) Use Firebase auth
ii) Show an error dialog on failure.
iii) Redirect to dashboard on success.

-- Subtask 4: Account Recovery Option --
i) Redirect to account recovery page

-- Subtask 5: Login Methods --
i) Google, Facebook, Twitter, etc [x]
ii) Show an error dialog on failure.
iii) Redirect to dashboard on success.

-- Subtask 6: Sign-up button --
i) Redirect to sign-up page
*/

import 'package:aski/pages/main_home_page/components/login_form.dart';
import 'package:flutter/material.dart';

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  Card(
                      child: LoginForm()
                  )
                ],
              ),
            )
        )
    );
  }
}