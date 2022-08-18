import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:woa/pages/Login.dart';

import 'Registration.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 200.0),
            ),
            SvgPicture.asset(
              "assets/5e535a2b8e24938384074dac_peep-73.svg",
            ),
            const Padding(
              padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 30.0),
              child: Text(
                'Please verify email. Check your email account for an email from **** and click on the link to confirm your email.',
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(primary: Colors.white),
              child: const Text('Register'),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: Text(
                'OR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(primary: Colors.white),
              child: const Text('Sign In'),
            )
          ],
        ),
      ),
    );
  }
}
