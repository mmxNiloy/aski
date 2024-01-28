import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<StatefulWidget> createState() => ForgotPasswordFormState();
}

class ForgotPasswordFormState extends State<ForgotPasswordForm> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String? emailErrorMessage;
  String password = '';
  String? passErrorMessage;
  bool showPassword = false;
  bool isTnCChecked = false;
  bool isLoadSubmitting= false;

  final _forgotPasswordKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _forgotPasswordKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Text(
              'Enter Your Associated Email',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Enter your email',
                errorText: emailErrorMessage,
              ),
              validator: validateEmail,
              onChanged: (value) => setState(() => email = value),
              initialValue: email,
            ),
          ),
          // Password text field


          // T&C Checkbox

          // Sign-up button
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: OutlinedButton.icon(
                icon: isLoadSubmitting? const CircularProgressIndicator() :const Icon(Icons.send_to_mobile),
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)),
                onPressed: submit,
                label: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
              )),

          const Padding(padding: EdgeInsets.symmetric(vertical: 8)),

        ],
      ),
    );
  }




  String? validateEmail(String? email) {
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email!)) {
      return emailErrorMessage = null;
    }

    return 'Invalid email';
  }

  Future<void> submit() async {
    bool valid= _forgotPasswordKey.currentState!.validate();

    if(isLoadSubmitting==true){
      return;
    }
    setState(() {
      isLoadSubmitting= false;
    });


    if(valid) {
      setState(() {
        isLoadSubmitting = true;
      });

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                content: Text('Password reset link is sent! Check your email.'),
              );

            }
        );
      } on FirebaseAuthException catch (e) {
        print(e);
        showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                content: Text(e.message.toString()),
              );

            }
        );
      }
    }



    setState(() {
      isLoadSubmitting= false;
    });

  }
}
