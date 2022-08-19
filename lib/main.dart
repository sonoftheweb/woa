import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:woa/constants/routes.dart';
import 'package:woa/pages/Login.dart';
import 'package:woa/pages/Registration.dart';
import 'package:woa/pages/VerifyEmail.dart';

import 'firebase_options.dart';
import 'pages/DashboardPage.dart';
import 'theme/themed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeData themeData = await initThemeData();

  runApp(MaterialApp(
    theme: themeData,
    home: FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            User? user = FirebaseAuth.instance.currentUser;
            user?.reload();
            if (user != null) {
              return const Dashboard();
            } else {
              return const LoginPage();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    ),
    routes: {
      loginRoute: (context) => const LoginPage(),
      registerRoute: (context) => const RegistrationPage(),
      verifyRoute: (context) => const VerifyEmailPage(),
      dashboardRoute: (context) => const Dashboard(),
    },
  ));
}
