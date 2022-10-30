import 'package:flutter/material.dart';
import 'package:woa/constants/routes.dart';
import 'package:woa/pages/build_routine_page.dart';
import 'package:woa/pages/library_page.dart';
import 'package:woa/pages/login.dart';
import 'package:woa/pages/registration.dart';
import 'package:woa/pages/routine_work.dart';
import 'package:woa/pages/verify_email.dart';
import 'package:woa/pages/view_routine_page.dart';
import 'package:woa/services/auth/auth_service.dart';

import 'pages/dashboard_page.dart';
import 'theme/themed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeData themeData = await initThemeData();

  runApp(MyApp(themeData: themeData));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.themeData,
  }) : super(key: key);

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
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
        libraryRoute: (context) => const LibraryPage(),
        buildRoutine: (context) => const BuildRoutinePage(),
        viewRoutine: (context) => ViewRoutinePage(
            args:
                ModalRoute.of(context)!.settings.arguments as RoutineArguments),
        routineWork: (context) => RoutineWork(
            args: ModalRoute.of(context)!.settings.arguments
                as WorkRoutineArgument),
      },
    );
  }
}
