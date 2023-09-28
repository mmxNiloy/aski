import 'package:aski/pages/dashboard/dashboard.dart';
import 'package:aski/pages/sign_up_page/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});


  @override
  State<StatefulWidget> createState() => LoginFormState();

}

// Form states should have email and password text fields
class LoginFormState extends State<LoginForm> {
  // Form states
  String email = '';
  String password = '';
  bool showPassword = false;
  final _loginFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Column(
          children: <Widget>[
            // Title
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      'Welcome to',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32,
                      ),
                    ),
                  ),
                ),
                // Placeholder Text Logo
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: Text(
                      'ASKi',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                ),
                // Issue: Apply appropriate margin, padding, and size of the logo here
                // Flexible(
                //   fit: FlexFit.loose,
                //   flex: 1,
                //   child: Image(
                //     image: AssetImage('images/logo_dark.png'),
                //     height: 300,
                //     width: 300,
                //     fit: BoxFit.cover,
                //   ),
                // )
              ],
            ),

            // Email text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your email'
                ),
                validator: validateEmail,
                onChanged: (value) => setState(() => email = value),
                initialValue: email,
              ),
            ),
            // Password text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextFormField(
                obscureText: !showPassword,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Enter your password',
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
                validator: (value) => (value == null || value.length < 8) ? 'The password is too short' : null,
                initialValue: password,
                onChanged: (value) => setState(() => password = value),
              ),
            ),
            // Login button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.login),
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)
                ),
                onPressed: isLoading ? null : login,
                label: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16
                  ),
                ),
              )
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 16, 0),
                    child: Divider(
                        color: Theme.of(context).hintColor
                    ),
                  )
                ),
                const Text(
                  'Login using',
                  style: TextStyle(
                    fontSize: 16
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 32, 0),
                      child: Divider(
                          color: Theme.of(context).hintColor
                      ),
                    )
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            // Login method list
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Facebook
                IconButton(
                    onPressed: () => loginUsingFacebook,
                    icon: Image.network(
                      'https://img.icons8.com/color/48/facebook-new.png',
                      height: 48,
                      width: 48,
                      errorBuilder: (context, error, stackTrace) => drawErrorIcon(context),
                    )
                ),
                // Google
                IconButton(
                    onPressed: signInWithGoogle,
                    icon: Image.network(
                      'https://img.icons8.com/color/48/google-logo.png',
                      height: 48,
                      width: 48,
                      errorBuilder: (context, error, stackTrace) => drawErrorIcon(context),
                    )
                ),
                // Twitter X
                IconButton(
                    onPressed: () => loginUsingTwitter(),
                    icon: Image.network(
                      'https://img.icons8.com/color/48/twitter--v1.png',
                      height: 48,
                      width: 48,
                      errorBuilder: (context, error, stackTrace) => drawErrorIcon(context),
                    )
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 16, 0),
                      child: Divider(
                          color: Theme.of(context).hintColor
                      ),
                    )
                ),
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                      fontSize: 16
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 32, 0),
                      child: Divider(
                          color: Theme.of(context).hintColor
                      ),
                    )
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: redirectToSignup,
                  label: const Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                )
            ),
          ],
        ),
      )
    );
  }

  String? validateEmail(String? email) {
    if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email!)) {
      return null;
    }

    return 'Invalid email';
  }

  bool loginUsingFacebook() {
    // TODO: Implement Login method Facebook
    // Call Facebook API and get a response
    // Return true on success
    return false;
  }

  Future<UserCredential> signInWithGoogle() async {
    if(kDebugMode) print('Google sign in helper method');

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  bool loginUsingTwitter() {
    // TODO: Implement Login method Facebook
    // Call Facebook API and get a response
    // Return true on success
    return false;
  }

  void redirectToSignup() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
  }

  Widget drawErrorIcon(BuildContext context) {
    return Icon(
      Icons.error_outlined,
      color: Theme.of(context).colorScheme.error,
    );
  }

  Future<void> login() async {
    // It shouldn't be here but oh well, if it ain't broke don't fix it.
    if(!context.mounted || isLoading) return;

    setState(() {
      isLoading = true;
    });

    if(_loginFormKey.currentState!.validate()) {
      // Try logging in with email and password
      String message = '';
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password
        );

        if(context.mounted) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Dashboard()));
        }
      } on FirebaseAuthException catch(err) {
        if(err.code == 'user-not-found') {
          message = 'There is no account for this email, $email';
        } else if(err.code == 'wrong-password') {
          message = 'The given password is incorrect.';
        }
      }

      if(context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('message: $message')));
      }

      setState(() {
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }
}