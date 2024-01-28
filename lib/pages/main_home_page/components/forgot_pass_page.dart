import 'package:aski/pages/sign_up_page/components/forgot_pass_form.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
        ),
        body: const Center(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  Card(
                      child: ForgotPasswordForm()
                  )
                ],
              ),
            )
        )
    );
  }
}