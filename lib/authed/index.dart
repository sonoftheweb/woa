import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../components/menu.dart';
import '../firebase_options.dart';

class MyApp extends StatelessWidget {
  final ThemeData? themeData;
  MyApp({Key? key, this.themeData}) : super(key: key);

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData ?? ThemeData.dark(),
      home: FutureBuilder(
        future: _fbApp,
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                if (kDebugMode) {
                  print('Something went wrong ${snapshot.error.toString()}');
                }
                return const Center(
                  child: Text('Something went wrong...'),
                );
              } else if (snapshot.hasData) {
                return const MyHomePage(title: 'Flutter Demo Home Page');
              }
              break;
            default:
              return const Center(
                child: Text('Loading...'),
              );
          }

          if (snapshot.hasError) {
            if (kDebugMode) {
              print('Something went wrong ${snapshot.error.toString()}');
            }
            return const Text('Something went wrong!');
          } else if (snapshot.hasData) {
            return const MyHomePage(title: 'Flutter Demo Home Page');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      drawer: const NavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'What',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
