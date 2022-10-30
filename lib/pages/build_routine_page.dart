import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:woa/components/cool_stepper/cool_stepper.dart';
import 'package:woa/components/quantity_selector_widget.dart';
import 'package:woa/components/radio_group.dart';
import 'package:woa/components/slider_selector/sliders.dart';
import 'package:woa/constants/routes.dart';
import 'package:woa/services/auth/auth_service.dart';
import 'package:woa/services/cloud/cloud_storage_constants.dart';
import 'package:woa/services/cloud/cloud_workout.dart';
import 'package:woa/services/cloud/firebase_cloud_storage.dart';
import 'package:woa/utils.dart';

class BuildRoutinePage extends StatefulWidget {
  const BuildRoutinePage({Key? key}) : super(key: key);

  @override
  State<BuildRoutinePage> createState() => _BuildRoutinePageState();
}

class _BuildRoutinePageState extends State<BuildRoutinePage> {
  CloudWorkout? _workout;
  late final FirebaseCloudStorage _workoutService;
  late final TextEditingController _workoutName;

  int biceps = 0;
  int triceps = 0;
  int chest = 0;
  int abdomen = 0;
  int thigh = 0;
  int calf = 0;
  int trapezius = 0;
  int upperBack = 0;
  int lowerBack = 0;
  int glutes = 0;
  int quadriceps = 0;
  int hamstring = 0;
  int powerMode = 0;
  double frequency = 85;
  double pulseWidth = 350;
  double pulseTime = 20;
  double pauseTime = 0;
  double trainTime = 20;

  late Future<CloudWorkout?> _createOrGetExistingWorkout;

  @override
  void initState() {
    _workoutService = FirebaseCloudStorage();
    _workoutName = TextEditingController();
    _createOrGetExistingWorkout = createOrGetExistingWorkout();
    super.initState();
  }

  Future<CloudWorkout?> createOrGetExistingWorkout() async {
    final ownerUserId = AuthService.firebase().currentUser!.id;

    final existingWorkout = _workout;
    if (existingWorkout != null) {
      return existingWorkout;
    }

    final newWorkout =
        await _workoutService.createNewWorkout(ownerUserId: ownerUserId);
    _workout = newWorkout;
    return newWorkout;
  }

  void _deleteWorkoutIfNameIsEmpty() {
    final CloudWorkout? workout = _workout;
    if (_workoutName.text.isEmpty && workout != null) {
      _workoutService.deleteWorkout(documentId: workout.documentId);
    }
  }

  void _saveWorkoutIfNameIsNotEmpty({
    required Map<String, int> workoutAreas,
    required Map<String, String> deviceSettings,
  }) async {
    final workout = _workout;
    final name = _workoutName.text;
    if (workout != null && name.isNotEmpty) {
      await _workoutService.updateWorkout(
        documentId: workout.documentId,
        workoutNameData: name,
        workoutAreasData: json.encode(workoutAreas),
        workoutSettingsData: json.encode(deviceSettings),
      );
    }
  }

  @override
  void dispose() {
    _deleteWorkoutIfNameIsEmpty();
    _workoutName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser;
    checkAuth(user, context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: const Text('Build a new routine'),
      ),
      body: FutureBuilder(
          future: _createOrGetExistingWorkout,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return buildMainBody(context);
              default:
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
            }
          }),
    );
  }

  Container buildMainBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      color: Colors.white,
      child: CoolStepper(
        showErrorSnackbar: true,
        onCompleted: () {
          final workout = _workout;
          if (workout == null) {
            return;
          }
          final Map<String, int> areas = {
            'biceps': biceps,
            'triceps': triceps,
            'chest': chest,
            'abdomen': abdomen,
            'thigh': thigh,
            'calf': calf,
            'trapezius': trapezius,
            'upperBack': upperBack,
            'lowerBack': lowerBack,
            'glutes': glutes,
            'quadriceps': quadriceps,
            'hamstring': hamstring,
          };
          final Map<String, String> settings = {
            'mode': powerMode.toString(),
            'frequency': frequency.toString(),
            'pulseWidth': pulseWidth.toString(),
            'pulseTime': pulseTime.toString(),
            'pauseTime': pauseTime.toString(),
            'trainTime': trainTime.toString(),
          };
          _saveWorkoutIfNameIsNotEmpty(
            workoutAreas: areas,
            deviceSettings: settings,
          );
          Navigator.of(context)
              .pushNamedAndRemoveUntil(libraryRoute, (route) => false);
        },
        config: const CoolStepperConfig(backText: 'BACK'),
        steps: [
          CoolStep(
            isHeaderEnabled: true,
            title: 'Body Selection (front)',
            subtitle: 'Select the parts of the body to workout',
            content: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/bodmap.png',
                                width: 250,
                              ),
                            ),
                            Positioned(
                              top: 75,
                              left: 41,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(chest),
                                ),
                              ),
                            ), // Chest
                            Positioned(
                              top: 75,
                              left: 69,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(chest),
                                ),
                              ),
                            ), // Chest
                            Positioned(
                              top: 94,
                              left: 91,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(biceps),
                                ),
                              ),
                            ), // Left Bicep
                            Positioned(
                              top: 94,
                              left: 21,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(biceps),
                                ),
                              ),
                            ), // Right Bicep
                            Positioned(
                              top: 119,
                              left: 46,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(abdomen),
                                ),
                              ),
                            ), // Abdomen
                            Positioned(
                              top: 119,
                              left: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(abdomen),
                                ),
                              ),
                            ), // Abdomen
                            Positioned(
                              top: 188,
                              left: 69,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(thigh),
                                ),
                              ),
                            ), // Thigh
                            Positioned(
                              top: 188,
                              left: 38,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(thigh),
                                ),
                              ),
                            ), // Thigh
                            Positioned(
                              top: 250,
                              right: 39,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(calf),
                                ),
                              ),
                            ), // Calf
                            Positioned(
                              top: 250,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(calf),
                                ),
                              ),
                            ), // Calf
                            Positioned(
                              top: 190,
                              right: 39,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(hamstring),
                                ),
                              ),
                            ), // Hamstrings
                            Positioned(
                              top: 190,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(hamstring),
                                ),
                              ),
                            ), // Hamstrings
                            Positioned(
                              top: 160,
                              right: 38,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(glutes),
                                ),
                              ),
                            ), // Glutes
                            Positioned(
                              top: 160,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(glutes),
                                ),
                              ),
                            ), // Glutes
                            Positioned(
                              top: 120,
                              right: 42,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(lowerBack),
                                ),
                              ),
                            ), // Lower Back
                            Positioned(
                              top: 120,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(lowerBack),
                                ),
                              ),
                            ), // Lower Back
                            Positioned(
                              top: 100,
                              right: 37,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(upperBack),
                                ),
                              ),
                            ), // Upper Back
                            Positioned(
                              top: 100,
                              right: 70,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(upperBack),
                                ),
                              ),
                            ), // Upper Back
                            Positioned(
                              top: 100,
                              right: 20,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(triceps),
                                ),
                              ),
                            ), // Triceps
                            Positioned(
                              top: 100,
                              right: 90,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(triceps),
                                ),
                              ),
                            ), // Triceps
                            Positioned(
                              top: 80,
                              right: 30,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(trapezius),
                                ),
                              ),
                            ), // Trapeziums
                            Positioned(
                              top: 80,
                              right: 80,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(trapezius),
                                ),
                              ),
                            ), // Trapeziums
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20.0)),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuantitySelectorWidget(
                        label: 'Biceps',
                        callback: (value) {
                          setState(() => biceps = value);
                        },
                      ),
                      QuantitySelectorWidget(
                        label: 'Triceps',
                        callback: (value) {
                          setState(() => triceps = value);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuantitySelectorWidget(
                        label: 'Chest',
                        callback: (value) {
                          setState(() => chest = value);
                        },
                      ),
                      QuantitySelectorWidget(
                        label: 'Abdomen',
                        callback: (value) {
                          setState(() => abdomen = value);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      QuantitySelectorWidget(
                        label: 'Thighs',
                        callback: (value) {
                          setState(() => thigh = value);
                        },
                      ),
                      QuantitySelectorWidget(
                        label: 'Calf',
                        callback: (value) {
                          setState(() => calf = value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            validation: () {
              return null;
            },
          ),
          CoolStep(
            isHeaderEnabled: true,
            title: 'Body Selection (back)',
            subtitle: 'Select the parts of the body to workout',
            content: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/bodmap.png',
                                width: 250,
                              ),
                            ),
                            Positioned(
                              top: 75,
                              left: 41,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(chest),
                                ),
                              ),
                            ), // Chest
                            Positioned(
                              top: 75,
                              left: 69,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(chest),
                                ),
                              ),
                            ), // Chest
                            Positioned(
                              top: 94,
                              left: 91,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(biceps),
                                ),
                              ),
                            ), // Left Bicep
                            Positioned(
                              top: 94,
                              left: 21,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(biceps),
                                ),
                              ),
                            ), // Right Bicep
                            Positioned(
                              top: 119,
                              left: 46,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(abdomen),
                                ),
                              ),
                            ), // Abdomen
                            Positioned(
                              top: 119,
                              left: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(abdomen),
                                ),
                              ),
                            ), // Abdomen
                            Positioned(
                              top: 188,
                              left: 69,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(thigh),
                                ),
                              ),
                            ), // Thigh
                            Positioned(
                              top: 188,
                              left: 38,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(thigh),
                                ),
                              ),
                            ), // Thigh
                            Positioned(
                              top: 250,
                              right: 39,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(calf),
                                ),
                              ),
                            ), // Calf
                            Positioned(
                              top: 250,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(calf),
                                ),
                              ),
                            ), // Calf
                            Positioned(
                              top: 190,
                              right: 39,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(hamstring),
                                ),
                              ),
                            ), // Hamstrings
                            Positioned(
                              top: 190,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(hamstring),
                                ),
                              ),
                            ), // Hamstrings
                            Positioned(
                              top: 160,
                              right: 38,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(glutes),
                                ),
                              ),
                            ), // Glutes
                            Positioned(
                              top: 160,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(glutes),
                                ),
                              ),
                            ), // Glutes
                            Positioned(
                              top: 120,
                              right: 42,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(lowerBack),
                                ),
                              ),
                            ), // Lower Back
                            Positioned(
                              top: 120,
                              right: 65,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(lowerBack),
                                ),
                              ),
                            ), // Lower Back
                            Positioned(
                              top: 100,
                              right: 37,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(upperBack),
                                ),
                              ),
                            ), // Upper Back
                            Positioned(
                              top: 100,
                              right: 70,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(upperBack),
                                ),
                              ),
                            ), // Upper Back
                            Positioned(
                              top: 100,
                              right: 20,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(triceps),
                                ),
                              ),
                            ), // Triceps
                            Positioned(
                              top: 100,
                              right: 90,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(triceps),
                                ),
                              ),
                            ), // Triceps
                            Positioned(
                              top: 80,
                              right: 30,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(trapezius),
                                ),
                              ),
                            ), // Trapeziums
                            Positioned(
                              top: 80,
                              right: 80,
                              child: ClipOval(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  color: pointsColor(trapezius),
                                ),
                              ),
                            ), // Trapeziums
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20.0)),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      QuantitySelectorWidget(
                        label: 'Trapezius',
                        callback: (value) {
                          setState(() => trapezius = value);
                        },
                      ),
                      QuantitySelectorWidget(
                        label: 'Upper Back',
                        callback: (value) {
                          setState(() => upperBack = value);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      QuantitySelectorWidget(
                        label: 'Lower Back',
                        callback: (value) {
                          setState(() => lowerBack = value);
                        },
                      ),
                      QuantitySelectorWidget(
                        label: 'Glutes',
                        callback: (value) {
                          setState(() => glutes = value);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      QuantitySelectorWidget(
                        label: 'Quads',
                        callback: (value) {
                          setState(() => quadriceps = value);
                        },
                      ),
                      QuantitySelectorWidget(
                        label: 'Hamstrings',
                        callback: (value) {
                          setState(() => hamstring = value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            validation: () {
              return null;
            },
          ),
          CoolStep(
            isHeaderEnabled: true,
            title: 'Select the mode of workout',
            subtitle: 'What mode do you wish to run?',
            content: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                RadioGroup(
                  textColor: Colors.grey.shade700,
                  data: powerModes.values.toList().asMap(),
                  selected: powerMode,
                  callback: (selectedMode) {
                    setState(() => powerMode = selectedMode);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
              ],
            ),
            validation: () {
              return null;
            },
          ),
          CoolStep(
            isHeaderEnabled: true,
            title: 'Setup workout parameters',
            subtitle:
                'These parameters control the wearable and provides control for your comfort.',
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      'Frequency',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                SfSliderTheme(
                  data: buildSfSliderThemeData(),
                  child: SfSlider(
                    value: frequency,
                    min: 10.0,
                    max: 130.0,
                    interval: 20.0,
                    stepSize: 5.0,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    showDividers: true,
                    minorTicksPerInterval: 5,
                    inactiveColor: Colors.green,
                    activeColor: Colors.green,
                    onChanged: (dynamic value) {
                      setState(() => frequency = value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Pulse Width',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                SfSliderTheme(
                  data: buildSfSliderThemeData(),
                  child: SfSlider(
                    value: pulseWidth,
                    min: 0.0,
                    max: 500.0,
                    interval: 100.0,
                    stepSize: 10.0,
                    showTicks: true,
                    showLabels: true,
                    showDividers: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 5,
                    inactiveColor: Colors.green,
                    activeColor: Colors.green,
                    onChanged: (dynamic value) {
                      setState(() => pulseWidth = value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Pulse Time',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                SfSliderTheme(
                  data: buildSfSliderThemeData(),
                  child: SfSlider(
                    value: pulseTime,
                    min: 10,
                    max: 60,
                    interval: 10,
                    stepSize: 5.0,
                    showTicks: true,
                    showLabels: true,
                    showDividers: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 5,
                    inactiveColor: Colors.green,
                    activeColor: Colors.green,
                    onChanged: (dynamic value) {
                      setState(() => pulseTime = value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Pause Time',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                SfSliderTheme(
                  data: buildSfSliderThemeData(),
                  child: SfSlider(
                    value: pauseTime,
                    min: 0,
                    max: 60,
                    interval: 10,
                    stepSize: 1.0,
                    showTicks: true,
                    showLabels: true,
                    showDividers: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 5,
                    inactiveColor: Colors.green,
                    activeColor: Colors.green,
                    onChanged: (dynamic value) {
                      setState(() => pauseTime = value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Train Time',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                SfSliderTheme(
                  data: buildSfSliderThemeData(),
                  child: SfSlider(
                    value: trainTime,
                    min: 0,
                    max: 60,
                    interval: 10,
                    stepSize: 1.0,
                    showTicks: true,
                    showLabels: true,
                    showDividers: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 5,
                    inactiveColor: Colors.green,
                    activeColor: Colors.green,
                    onChanged: (dynamic value) {
                      setState(() => trainTime = value);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                const Center(
                  child: Text('Train Time'),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 15.0,
                  ),
                ),
                TextFormField(
                  controller: _workoutName,
                  style: const TextStyle(
                    color: Color.fromRGBO(44, 42, 70, 1),
                  ),
                  keyboardType: TextInputType.text,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Routine name',
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(44, 42, 70, 1),
                    ),
                    fillColor: Colors.grey.shade50,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(44, 42, 70, 1),
                        width: 2.0,
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(44, 42, 70, 1),
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Routine name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name to identify this routine.';
                    }
                    return null;
                  },
                ),
              ],
            ),
            validation: () {
              if (_workoutName.text.isEmpty) {
                return 'Please enter a name to save this routine.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  SfSliderThemeData buildSfSliderThemeData() {
    return SfSliderThemeData(
      activeLabelStyle: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 16,
      ),
      inactiveLabelStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 16,
      ),
      activeTrackHeight: 5,
      inactiveTrackHeight: 3,
      activeDividerColor: Colors.grey.shade700,
      inactiveDividerColor: Colors.grey.shade400,
      activeTickColor: Colors.grey.shade700,
      inactiveTickColor: Colors.grey.shade400,
      activeMinorTickColor: Colors.grey.shade500,
      inactiveMinorTickColor: Colors.grey.shade200,
    );
  }
}
