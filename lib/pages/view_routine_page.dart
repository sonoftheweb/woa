import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../components/connectivity/is_connected_or_select.dart';
import '../enums/power_modes.dart';
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
    CloudWorkout? workout = _workout;
    Map<String, dynamic> settings = json.decode(workout!.settings!);
    Map<String, dynamic> areas = json.decode(workout.areas!);

    final pages = [
      Container(
        padding: const EdgeInsets.only(top: 10.0),
        margin: const EdgeInsets.only(
          left: 20.0,
          right: 20,
        ),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(27, 26, 41, 0.2),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.punch_clock_rounded,
                          size: 50.0,
                        ),
                        const Text(
                          '20.0',
                          style: TextStyle(
                            fontSize: 70.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Train time in minutes',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.settings, size: 30),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    camelToNormal(PowerModes
                                            .values[int.parse(settings['mode'])]
                                            .toString()
                                            .substring(11))
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'workout mode',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: const [
                                  Icon(Icons.fireplace_rounded, size: 60),
                                  SizedBox(height: 10.0),
                                  Text(
                                    '250 kcal',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Calories to be burnt',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: const [
                                  Icon(Icons.watch_rounded, size: 30),
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Enabled',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'external devices',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const IsConnectedOrSelect(),
                ],
              ),
            )
          ],
        ),
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

  camelToNormal(String camelCaseText) {
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    String result =
        camelCaseText.replaceAllMapped(exp, (Match m) => (' ${m.group(0)}'));
    return result;
  }
}
