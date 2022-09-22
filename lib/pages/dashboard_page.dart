import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:woa/components/previous_workout_widget.dart';
import 'package:woa/services/auth/auth_service.dart';

import '../components/menu.dart';
import '../utils.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser;
    checkAuth(user, context);
    String? name = user?.displayName ?? user?.email;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 40.0,
                bottom: 60.0,
              ),
              child: Text(
                'Hello $name! Ready to burn some more calories today?',
                textAlign: TextAlign.center,
              ),
            ),
            const PreviousWorkoutWidget()
          ],
        ),
      ),
      drawer: const NavigationDrawer(),
    );
  }
}
