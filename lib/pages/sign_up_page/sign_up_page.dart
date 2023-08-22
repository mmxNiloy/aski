import 'package:aski/pages/sign_up_page/components/sign_up_form.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up to ASKi'),
        ),
        body: const Center(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  Card(
                      child: SignUpForm()
                  )
                ],
              ),
            )
        )
    );
  }
}