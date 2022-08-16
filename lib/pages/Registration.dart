import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/FormTitleWidget.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController();
  late final _password = TextEditingController();
  late final _confirmPassword = TextEditingController();

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
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
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
              padding: const EdgeInsets.only(top: 100.0, bottom: 20.0),
              child: TextFormField(
                controller: _email,
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
                  final email = _email.text;
                  final password = _password.text;

                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, password: password);
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
          ],
        ),
      ),
    );
  }
}
