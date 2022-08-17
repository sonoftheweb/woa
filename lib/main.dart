import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'firebase_options.dart';
import 'navigation/Menu.dart';
import 'pages/Registration.dart';
import 'theme/themed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeData themeData = await initThemeData();

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    theme: themeData,
    home: FutureBuilder(
      future: _fbApp,
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.hasError) {
          if (kDebugMode) {
            print('Something went wrong ${snapshot.error.toString()}');
          }
          return const Text('Something went wrong!');
        } else if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Builder(
            builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: SvgPicture.asset(
                "assets/drawer.svg",
                color: const Color.fromARGB(100, 64, 202, 255),
                height: 15,
                width: 34,
              ),
            ),
          ),
        ),
      ),
      body: const RegistrationPage(),
      drawer: const NavigationDrawer(),
    );
  }
}
