import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:woa/constants/routes.dart';
import 'package:woa/services/auth/auth_service.dart';

import '../components/FormTitleWidget.dart';
import '../services/auth/auth_exceptions.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController();
  late final _password = TextEditingController();
  late final _confirmPassword = TextEditingController();
  final Map<String, String> _errors = {
    'weak-password':
        'Password was deemed to be too weak. Please re-enter a password.',
    'email-already-in-use':
        'The email address entered is already in use. Login if you already have access.',
    'invalid-email':
        'An invalid email was entered. Please enter a valid email.',
  };
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const registrationText = 'Registration!';
    const registrationFormDesc =
        'Please fill in the form below to begin registration';
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 150.0),
            child: Column(
              children: [
                const Center(
                  child: FormTitleWidget(registrationText: registrationText),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: Text(
                      registrationFormDesc,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: (_error != null)
                      ? Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        )
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0, bottom: 20.0),
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Email address',
                    ),
                    validator: (value) {
                      bool isValid = EmailValidator.validate(value.toString());
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid email';
                      }
                      if (!isValid) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length > 1 && value.length < 6) {
                        return 'Password has to be greater than 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 40.0),
                  child: TextFormField(
                    controller: _confirmPassword,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Confirm Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter your password';
                      }
                      if (value != _password.text) {
                        return 'Passwords are not identical';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final email = _email.text;
                        final password = _password.text;

                        AuthService.firebase().createUser(
                          email: email,
                          password: password,
                        );

                        Navigator.of(context).pushNamed(verifyRoute);
                      } on WeakPasswordAuthException {
                        _error = _errors['weak-password'];
                      } on EmailAlreadyInUseAuthException {
                        _error = _errors['email-already-in-use'];
                      } on InvalidEmailAuthException {
                        _error = _errors['invalid-email'];
                      } on GenericAuthException {
                        _error = 'Error occurred during registration.';
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade500,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 20,
                    ),
                  ),
                  child: const Text('Register'),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0, top: 40.0),
                  child: Text(
                    'Already have an account?',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  },
                  style: TextButton.styleFrom(primary: Colors.white),
                  child: const Text('Sign In'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
