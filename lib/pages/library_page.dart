import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:woa/components/menu.dart';
import 'package:woa/components/workout_list_view.dart';
import 'package:woa/constants/routes.dart';
import 'package:woa/pages/test_ble.dart';
import 'package:woa/pages/view_routine_page.dart';
import 'package:woa/services/auth/auth_service.dart';
import 'package:woa/utils.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final user = AuthService.firebase().currentUser!;
  String get userId => user.id;

  @override
  void initState() {
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
        scrolledUnderElevation: 0.5,
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
      body: WorkoutListView(
        userId: userId,
        onTap: (workout) {
          Navigator.pushNamed(
            context,
            viewRoutine,
            arguments: RoutineArguments(workoutId: workout.documentId),
          );
        },
        onDelete: (workout) async {
          await FirebaseFirestore.instance
              .collection('workouts')
              .doc(workout.documentId)
              .delete();
        },
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
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FlutterBlueApp()));
            },
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
