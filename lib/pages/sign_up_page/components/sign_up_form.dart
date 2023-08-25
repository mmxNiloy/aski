import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<StatefulWidget> createState() => SignUpFormState();

}

class StepNames {
  static int get basicInfo => 0;
  static int get emailAndPassword => 1;
  static int get verification => 2;
}

class SignUpFormState extends State<SignUpForm> {
  String firstName = '';
  String lastName = '';
  String username = '';
  String email = '';
  String password = '';
  String repeatedPassword = '';
  bool showPassword = false;
  bool showRepeatPassword = false;
  int currentStep = StepNames.basicInfo;
  String verificationCode = '';

  final _basicInfoFormKey = GlobalKey<FormState>();
  final _emailPassFormKey = GlobalKey<FormState>();
  final _verificationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  'Sign up to',
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

        // Sign up form steps
        Stepper(
        currentStep: currentStep,
        onStepContinue: goToNextStep,
        onStepCancel: goToPreviousStep,
        onStepTapped: (int currentStep) {
          setState(() {
            this.currentStep = currentStep;
          });
        },
        steps: [
          Step(
              title: const Text(
                'Basic Information'
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Form(
                  key: _basicInfoFormKey,
                  child: Column(
                    children: <Widget>[
                      // First name text field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'First Name'
                          ),
                          validator: (value) => (value == null || value.isEmpty) ? 'Enter your first name' : null,
                          onChanged: (value) => setState(() => firstName = value),
                          initialValue: firstName,
                          maxLength: 32,
                        ),
                      ),

                      // Last name text field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Last Name'
                          ),
                          validator: (value) => (value == null || value.isEmpty) ? 'Enter your last name' : null,
                          onChanged: (value) => setState(() => lastName = value),
                          initialValue: lastName,
                          maxLength: 32,
                        ),
                      ),

                      // Username text field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username'
                          ),
                          validator: validateUsername,
                          onChanged: (value) => setState(() => username = value),
                          initialValue: username,
                          maxLength: 20,
                        ),
                      ),

                      // Sign up button
                      // Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      //     child: OutlinedButton(
                      //       style: OutlinedButton.styleFrom(
                      //           minimumSize: const Size.fromHeight(48)
                      //       ),
                      //       onPressed: signup,
                      //       child: const Text(
                      //         'Sign Up',
                      //         style: TextStyle(
                      //             fontSize: 16
                      //         ),
                      //       ),
                      //     )
                      // ),
                    ],
                  ),
                ),
              )
          ),
          Step(
              title: const Text(
                  'Basic Information'
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Form(
                  key: _emailPassFormKey,
                  child: Column(
                    children: <Widget>[
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

                      // Repeat Password text field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        child: TextFormField(
                          obscureText: !showRepeatPassword,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Confirm your password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                    showRepeatPassword ?
                                    Icons.visibility_off :
                                    Icons.visibility
                                ),
                                onPressed: () => {
                                  setState(() => showRepeatPassword = !showRepeatPassword)
                                },
                              )
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value == password ? null : 'Password didn\'t match',
                          initialValue: repeatedPassword,
                          onChanged: (value) => setState(() => repeatedPassword = value),
                        ),
                      ),

                      // Sign up button
                      // Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      //     child: OutlinedButton(
                      //       style: OutlinedButton.styleFrom(
                      //           minimumSize: const Size.fromHeight(48)
                      //       ),
                      //       onPressed: signup,
                      //       child: const Text(
                      //         'Sign Up',
                      //         style: TextStyle(
                      //             fontSize: 16
                      //         ),
                      //       ),
                      //     )
                      // ),
                    ],
                  ),
                ),
              )
          ),
          Step(
            title: const Text('Finalization'),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: <Widget>[
                  Text(
                      '''
                      We\'ve sent you and email with verification code at this email address, $email.
                      Please enter the verification code to activate your account. 
                      The verification code will expire after 7 days. 
                      You need to activate your account before the code expires otherwise you need to create a new account.
                      '''
                  ),
                  Form(
                    key: _verificationFormKey,
                    child: Column(
                      children: <Widget>[
                        // Verification code text field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter the verification code'
                            ),
                            // TODO: Add verification code validator here
                            // validator: ,
                            onChanged: (value) => setState(() => verificationCode = value),
                            initialValue: verificationCode,
                          ),
                        ),

                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: // Verify code button
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.check),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(48),
                                    ),
                                    onPressed: verifyCode,
                                    label: const Text(
                                      'Verify',
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            Flexible(
                              child: // Resend email button
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.refresh),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(48),
                                    ),
                                    onPressed: verifyCode,
                                    label: const Text(
                                      'Resend Verification Code',
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                  )
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            )
          ),
        ],
      ),
      ]
    );
  }

  void goToPreviousStep() {
    if(currentStep == StepNames.verification) {
      setState(() {
        currentStep = StepNames.emailAndPassword;
      });
    } else if(currentStep == StepNames.emailAndPassword) {
      setState(() {
        currentStep = StepNames.basicInfo;
      });
    }
  }

  void goToNextStep() {
    // TODO: Validate forms here and block access upon failure
    if(currentStep == StepNames.basicInfo) {
      if(_basicInfoFormKey.currentState!.validate()) {
        setState(() {
          currentStep = StepNames.emailAndPassword;
        });
      }
    } else if(currentStep == StepNames.emailAndPassword) {
      if(_emailPassFormKey.currentState!.validate()) {
        setState(() {
          currentStep = StepNames.verification;
        });
      }
    } else {
      // TODO: Redirect to dashboard upon email verification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('TODO: Send verification email. Verify email or redirect to dashboard.')
        )
      );
    }
  }

  String? validateUsername(String? username) {
    // Regex explanation
    // username should be 8-20 characters long
    // has no _., ._, __, __.
    // has allowed characters
    // has no . or _ at the end
    if(RegExp(r"^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$").hasMatch(username!)) {
      return null;
    }
    return 'Invalid username!';
  }

  String? validateEmail(String? email) {
    if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email!)) {
      return null;
    }

    return 'Invalid email';
  }

  void signup() {
    if(_emailPassFormKey.currentState!.validate() && _basicInfoFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'TODO: Firebase auth\nGiven data, {${{firstName, lastName, username, email, password}.toString()}}'
              )
          )
      );
    }
  }

  void verifyCode() {
    // TODO: Verify the given code and try to redirect to dashboard
  }
}