import 'package:aski/models/user_model.dart';
import 'package:aski/pages/dashboard/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<StatefulWidget> createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String? emailErrorMessage;
  String password = '';
  String? passErrorMessage;
  bool showPassword = false;
  bool isTnCChecked = false;

  final _signupFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Text(
              'Sign Up',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: TextFormField(
              onChanged: (value) => setState(() => firstName = value),
              validator: validateName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: TextFormField(
              onChanged: (value) => setState(() => lastName = value),
              validator: validateName,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name'
              ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: TextFormField(
              obscureText: !showPassword,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Enter your password',
                  errorText: passErrorMessage,
                  suffixIcon: IconButton(
                    icon: Icon(
                        showPassword ?
                        Icons.visibility_off :
                        Icons.visibility
                    ),
                    onPressed: () => {
                      setState(() => showPassword = !showPassword)
                    },
                  )
              ),
              validator: validatePassword,
              initialValue: password,
              onChanged: (value) => setState(() => password = value),
            ),
          ),

          // T&C Checkbox
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Row(
                children: [
                  Checkbox(
                    value: isTnCChecked,
                    onChanged: (value) => setState(() => isTnCChecked = value!),
                  ),
                  Expanded(
                    child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'I agree with the ',
                              style: Theme.of(context).textTheme.bodyMedium
                            ),
                            TextSpan(
                                text: 'Terms and Conditions',
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  debugPrint('TODO: Link to terms and conditions page');
                                }
                            )
                          ],

                        )
                    ),
                  )
                ],
              )
          ),

          // Sign-up button
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.check),
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)
                ),
                onPressed: signup,
                label: const Text(
                  'Sign up',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              )
          ),

          const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text('Already have an account?'),
          ),

          // Login button
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.login),
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)
                ),
                onPressed: () => Navigator.pop(context),
                label: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }

  String? validateName(String? name) {
    if(RegExp(r'^[a-zA-Z]+$').hasMatch(name!)) return null;

    return 'Invalid Name';
  }

  String? validatePassword(String? password) {
    if(password == null || password.isEmpty || password.length < 8) {
      return 'The password is too short';
    }

    return passErrorMessage = null;
  }

  String? validateEmail(String? email) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email!)) {
      return emailErrorMessage = null;
    }

    return 'Invalid email';
  }
  
  Future<void> signup() async {
    // If T&C are not agreed with
    if(!isTnCChecked) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(content: Text('You need to agree with our terms and conditions to proceed.'))
      );
    } else if(_signupFormKey.currentState!.validate()) {
      // Try to create a user from the given data.
      try {
        final creds = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // Structure data
        // TODO: Keep an option for a profile picture,
        //  or save that option for later in dashboard
        UserModel userModel = UserModel(firstName: firstName, lastName: lastName);

        // Insert data into firestore
        final db = FirebaseFirestore.instance;
        await db.collection('users')
          .doc(creds.user!.uid)
          .set(userModel.toMapObject())
          .onError((error, stackTrace) => debugPrint('Error inserting data, $error'));

        debugPrint('Successfully inserted user data');

        // Redirect to dashboard, prompt first time login BS
        if(context.mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Dashboard())
          );
        }
      } on FirebaseAuthException catch(err) {
        if(err.code == 'weak-password') {
          passErrorMessage = 'The given password is too weak.';
        } else if(err.code == 'email-already-in-use') {
          emailErrorMessage = 'An account exists for this email.';
        }
      } catch(err) {
        debugPrint(err.toString());
      }
    }
  }

  void verifyCode() {
    // TODO: Verify the given code and try to redirect to dashboard
  }
}
