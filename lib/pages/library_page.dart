import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:woa/services/cloud/firebase_cloud_storage.dart';

import '../components/menu.dart';
import '../constants/routes.dart';
import '../services/auth/auth_service.dart';
import '../utils.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  late final FirebaseCloudStorage _workoutService;
  final user = AuthService.firebase().currentUser!;
  String get userId => user.id;

  @override
  void initState() {
    _workoutService = FirebaseCloudStorage();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkAuth(user, context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: navigationBuilder(),
              ),
              const Expanded(
                child: Text(
                  'Routine Library',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                width: 35.0,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.only(
                top: 30.0,
                left: 40.0,
                right: 40.0,
                bottom: 60.0,
              ),
              child: Text(
                'Below is a list of your workout library. Select one to schedule a workout, build a new workout plan or add to your library from the marketplace.',
                textAlign: TextAlign.center,
              ),
            ),
            Text('Waiting for all workouts')
          ],
        ),
      ),
      drawer: const NavigationDrawer(),
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            icon: Icons.library_add,
            iconColor: Colors.white,
            title: 'Routine from marketplace',
            titleStyle: const TextStyle(fontSize: 13, color: Colors.white),
            bubbleColor: Colors.green.shade500,
            onPress: () {},
          ),
          Bubble(
            icon: Icons.calculate,
            iconColor: Colors.white,
            title: 'Build routine',
            titleStyle: const TextStyle(fontSize: 13, color: Colors.white),
            bubbleColor: Colors.green.shade500,
            onPress: () => {Navigator.of(context).pushNamed(buildRoutine)},
          ),
        ],
        backGroundColor: Colors.green.shade500,
        iconColor: Colors.white,
        iconData: Icons.add,
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        animation: _animation,
      ),
    );
  }
}
