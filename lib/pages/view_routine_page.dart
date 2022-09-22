import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../components/connectivity/ble_reactive_checker.dart';
import '../services/auth/auth_service.dart';
import '../services/cloud/cloud_workout.dart';
import '../services/cloud/firebase_cloud_storage.dart';
import '../utils.dart';

class RoutineArguments {
  final String workoutId;
  RoutineArguments({required this.workoutId});
}

class ViewRoutinePage extends StatefulWidget {
  final RoutineArguments args;

  const ViewRoutinePage({Key? key, required this.args}) : super(key: key);

  @override
  State<ViewRoutinePage> createState() => _ViewRoutinePageState();
}

class _ViewRoutinePageState extends State<ViewRoutinePage> {
  late final FirebaseCloudStorage _workoutService;
  late Future<CloudWorkout?> _getCurrentWorkout;
  CloudWorkout? _workout;
  final controller = PageController(viewportFraction: 1.0, keepPage: true);

  @override
  void initState() {
    _workoutService = FirebaseCloudStorage();
    _getCurrentWorkout = getCurrentWorkout(widget.args.workoutId);
    super.initState();
  }

  Future<CloudWorkout?> getCurrentWorkout(workoutId) async {
    final existingWorkout = _workout;
    if (existingWorkout != null) {
      return existingWorkout;
    }

    final workout =
        await _workoutService.fetchWorkoutByDocumentId(workoutId: workoutId);
    _workout = workout;
    return workout;
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser;
    checkAuth(user, context);

    return FutureBuilder(
      future: _getCurrentWorkout,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Center(
                child: Text('There was an error getting workout.'),
              );
            }

            if (snapshot.hasData) {
              return buildBody();
            }

            return Scaffold(
              appBar: AppBar(
                elevation: 0.1,
                title: const Text('Failed to get workout'),
              ),
              body: const Center(
                child: Text('No data was found for this workout.'),
              ),
            );
          default:
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
        }
      },
    );
  }

  Scaffold buildBody() {
    final pages = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: Column(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      print('yay');
                    },
                    child: const Text('Start this routine'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('four'),
              Text('five'),
              Text('six'),
            ],
          )
        ],
      ),
    ];
    CloudWorkout? workout = _workout;
    Map<String, dynamic> settings = json.decode(workout!.settings!);
    Map<String, dynamic> areas = json.decode(workout.areas!);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Text(workout.name!),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BluetoothChecker(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Container(
                      //   alignment: Alignment.center,
                      //   child: Row(
                      //     children: [
                      //       const Icon(Icons.man_outlined),
                      //       Text(powerModes.values
                      //           .toList()[int.parse(settings['mode'])]),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: pages.length,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 5,
                            dotWidth: 5,
                            activeDotColor: Color.fromRGBO(91, 188, 46, 1),
                          ),
                        ),
                      ),
                      //const BlueToothReadyChip(),
                      // Container(
                      //   alignment: Alignment.center,
                      //   child: Row(
                      //     children: const [
                      //       Icon(Icons.bluetooth_connected),
                      //       Text(
                      //         ' Connected',
                      //         style: TextStyle(fontSize: 10),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: PageView.builder(
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    return pages[index % pages.length];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
