import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:woa/constants/routes.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 150.0),
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
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              ),
              ElevatedButton(
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification().then((value) async {
                    await FirebaseAuth.instance.signOut().then((value) =>
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                          (route) => false,
                        ));
                  });
                },
                child: const Text('Resend verification email'),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(registerRoute);
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
                  Navigator.of(context).pushNamed(loginRoute);
                },
                style: TextButton.styleFrom(primary: Colors.white),
                child: const Text('Sign In'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
