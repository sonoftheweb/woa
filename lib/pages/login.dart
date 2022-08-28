import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:woa/components/form_title_widget.dart';
import 'package:woa/constants/routes.dart';
import 'package:woa/services/auth/auth_service.dart';

import '../services/auth/auth_exceptions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final _loginFormKey = GlobalKey<FormState>();
  late final _email = TextEditingController();
  late final _password = TextEditingController();
  final Map<String, String> _errors = {
    'user-not-found':
        'Incorrect login details. Please enter your email and password to log in.',
    'wrong-password':
        'Password incorrect. Please enter your email and password to log in.',
  };
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _loginFormKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 150.0),
            child: Column(
              children: [
                const Center(
                  child: FormTitleWidget(registrationText: 'Login'),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Text(
                    'Fill in your credentials to access your dashboard.',
                    textAlign: TextAlign.center,
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
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
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
                  padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
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
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_loginFormKey.currentState!.validate()) {
                      try {
                        final email = _email.text;
                        final password = _password.text;

                        await AuthService.firebase().logIn(
                          email: email,
                          password: password,
                        );

                        final user = AuthService.firebase().currentUser;

                        String page = (user?.isEmailVerified ?? false)
                            ? dashboardRoute
                            : verifyRoute;

                        Navigator.of(context).pushNamedAndRemoveUntil(
                          page,
                          (route) => false,
                        );
                      } on UserNotFoundAuthException {
                        _error = _errors['user-not-found'];
                      } on WrongPasswordAuthException {
                        _error = _errors['wrong-password'];
                      } on GenericAuthException {
                        _error = 'Authentication error';
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
                  child: const Text('Sign In'),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0, top: 40.0),
                  child: Text(
                    'Don\'t have an account yet?',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(registerRoute);
                  },
                  style: TextButton.styleFrom(primary: Colors.white),
                  child: const Text('Register'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
