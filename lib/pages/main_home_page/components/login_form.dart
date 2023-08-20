import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: Column(
          children: <Widget>[
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                'Welcome to',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32
                ),
              ),
            ),

            // Placeholder Text Logo
            const Padding(
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

            // Issue: Apply appropriate margin, padding, and size of the logo here
            // const Image(
            //   image: AssetImage('images/logo_dark.png'),
            //   height: 300,
            //   width: 300,
            // ),
            // Email text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your email'
                ),
                validator: (value) => isValidEmail(value) ? null : 'Invalid Email Address',
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
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)
                ),
                onPressed: () => {
                  if(_loginFormKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'TODO: Firebase Auth\nInput email: $email\nPassword$password'
                            )
                        )
                    )
                  }
                },
                child: const Text(
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
                    )
                ),
                // Google
                IconButton(
                    onPressed: () => loginUsingGoogle(),
                    icon: Image.network(
                      'https://img.icons8.com/color/48/google-logo.png',
                      height: 48,
                      width: 48,
                    )
                ),
                // Twitter X
                IconButton(
                    onPressed: () => loginUsingTwitter(),
                    icon: Image.network(
                      'https://img.icons8.com/color/48/twitter--v1.png',
                      height: 48,
                      width: 48,
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
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)
                  ),
                  onPressed: () => redirectToSignup(),
                  child: const Text(
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

  bool isValidEmail(String? email) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email!);

  bool loginUsingFacebook() {
    // TODO: Implement Login method Facebook
    // Call Facebook API and get a response
    // Return true on success
    return false;
  }
  bool loginUsingGoogle() {
    // TODO: Implement Login method Facebook
    // Call Facebook API and get a response
    // Return true on success
    return false;
  }
  bool loginUsingTwitter() {
    // TODO: Implement Login method Facebook
    // Call Facebook API and get a response
    // Return true on success
    return false;
  }

  void redirectToSignup() {
    // TODO: Redirect to sign up page.
  }
}