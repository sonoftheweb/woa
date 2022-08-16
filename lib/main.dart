import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'pages/Registration.dart';
import 'theme/themed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeData themeData = await initThemeData();
  runApp(MaterialApp(
    theme: themeData,
    home: const HomePage(),
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
    );
  }
}
