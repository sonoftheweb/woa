import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:woa/components/countdown.dart';
import 'package:woa/components/pulse_timer.dart';
import 'package:woa/components/simple_anumated_ripple.dart';
import 'package:woa/constants/devices_and_services.dart';
import 'package:woa/services/cloud/cloud_workout.dart';
import 'package:woa/utils.dart';

class WorkRoutineArgument {
  final CloudWorkout workout;
  final BluetoothDevice device;

  WorkRoutineArgument({
    required this.workout,
    required this.device,
  });
}

class RoutineWork extends StatefulWidget {
  final WorkRoutineArgument args;

  const RoutineWork({Key? key, required this.args}) : super(key: key);

  @override
  State<RoutineWork> createState() => _RoutineWorkState();
}

class _RoutineWorkState extends State<RoutineWork> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  bool isRunning = false;
  late CloudWorkout _workout;
  late Map<String, dynamic> _areas;
  late Map<String, dynamic> _settings;
  late int _trainTime;
  late int _pulseTime;

  @override
  void initState() {
    _workout = widget.args.workout;
    _areas = json.decode(_workout.areas!);
    _settings = json.decode(_workout.settings!);
    _trainTime = int.parse(_settings['trainTime']);
    _pulseTime = int.parse(_settings['pulseTime']).floor();

    super.initState();
  }

  void _beginRoutine() async {
    final CloudWorkout workout = _workout;
    final Map<String, dynamic> areas = _areas;
    final Map<String, dynamic> settings = _settings;
    final Map<String, int> areasToChannelMap = {
      'biceps': 1,
      'triceps': 2,
      'chest': 3,
      'abdomen': 4,
      'thigh': 5,
      'calf': 6,
      'trapezius': 7,
      'upperBack': 8,
      'lowerBack': 9,
      'glutes': 10,
      'quadriceps': 11,
      'hamstring': 12,
    };

    List<BluetoothService> services =
        await widget.args.device.discoverServices();
    BluetoothService ws =
        services.where((s) => s.uuid.toString() == writeService).toList().first;
    BluetoothService ns = services
        .where((s) => s.uuid.toString() == notifyService)
        .toList()
        .first;

    BluetoothCharacteristic wsChars = ws.characteristics
        .where((c) => c.uuid.toString() == writeServiceCharacteristics)
        .toList()
        .first;
    BluetoothCharacteristic nsChars = ns.characteristics
        .where((c) => c.uuid.toString() == notifyServiceCharacteristics)
        .toList()
        .first;

    // // This triggers the light toggle on device
    // //await wsChars.write([0xa8, 0x10, 0xB8]);
    // await wsChars.write([168, 16, 184]);

    // set frequency
    // int freq = settings['frequency'];
    // await wsChars.write([168, 1, freq, 169 + freq]);
    //
    // // set pulse width
    // int pulseWidth = settings['pulseWidth'];
    // await wsChars.write([168, 2, pulseWidth, 170 + pulseWidth]);
    //
    // // set pulse width
    // int pulseTime = settings['pulseTime'];
    // await wsChars.write([168, 3, pulseTime, 171 + pulseTime]);
    //
    // // set mode
    // int mode = settings['mode'];
    // await wsChars.write([168, 4, mode, 172 + mode]);
    //
    // // set mode
    // int trainTime = settings['trainTime'];
    // await wsChars.write([168, 5, trainTime, 173 + trainTime]);
    //
    // // trigger all the body stimulation start
    // for (var element in areas.entries) {
    //   String key = element.key;
    //   int value = element.value;
    //   int? channel = areasToChannelMap[key];
    //   if (channel != null) {
    //     if (value != 0) {
    //       await wsChars.write(
    //           [168, 6, channel, value, 174 + value]); // enable the channel
    //     } else {
    //       await wsChars.write(
    //           [168, 6, channel, 0, 174]); // ensure the channel stays disabled
    //     }
    //   }
    // }

    // done sending all commands to the board
  }

  @override
  void dispose() {
    widget.args.device.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('${widget.args.workout.name} Running...'),
      ),
      body: StreamBuilder<BluetoothDeviceState>(
        stream: widget.args.device.state,
        initialData: BluetoothDeviceState.disconnected,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case BluetoothDeviceState.connected:
              //_beginRoutine();
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(27, 26, 41, 0.2),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
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
                                      child: runningOrNotIndicator(
                                          _areas['chest']),
                                    ), // Chest
                                    Positioned(
                                      top: 75,
                                      left: 69,
                                      child: runningOrNotIndicator(
                                          _areas['chest']),
                                    ), // Chest
                                    Positioned(
                                      top: 94,
                                      left: 91,
                                      child: runningOrNotIndicator(
                                          _areas['biceps']),
                                    ), // Left Bicep
                                    Positioned(
                                      top: 94,
                                      left: 21,
                                      child: runningOrNotIndicator(
                                          _areas['biceps']),
                                    ), // Right Bicep
                                    Positioned(
                                      top: 119,
                                      left: 46,
                                      child: runningOrNotIndicator(
                                          _areas['abdomen']),
                                    ), // Abdomen
                                    Positioned(
                                      top: 119,
                                      left: 65,
                                      child: runningOrNotIndicator(
                                          _areas['abdomen']),
                                    ), // Abdomen
                                    Positioned(
                                      top: 188,
                                      left: 69,
                                      child: runningOrNotIndicator(
                                          _areas['thigh']),
                                    ), // Thigh
                                    Positioned(
                                      top: 188,
                                      left: 38,
                                      child: runningOrNotIndicator(
                                          _areas['thigh']),
                                    ), // Thigh
                                    Positioned(
                                      top: 250,
                                      right: 39,
                                      child: runningOrNotIndicator(
                                          _areas['calf'],
                                          right: true),
                                    ), // Calf
                                    Positioned(
                                      top: 250,
                                      right: 65,
                                      child: runningOrNotIndicator(
                                          _areas['calf'],
                                          right: true),
                                    ), // Calf
                                    Positioned(
                                      top: 190,
                                      right: 39,
                                      child: runningOrNotIndicator(
                                          _areas['hamstring'],
                                          right: true),
                                    ), // Hamstrings
                                    Positioned(
                                      top: 190,
                                      right: 65,
                                      child: runningOrNotIndicator(
                                          _areas['hamstring'],
                                          right: true),
                                    ), // Hamstrings
                                    Positioned(
                                      top: 160,
                                      right: 38,
                                      child: runningOrNotIndicator(
                                          _areas['glutes'],
                                          right: true),
                                    ), // Glutes
                                    Positioned(
                                      top: 160,
                                      right: 65,
                                      child: runningOrNotIndicator(
                                          _areas['glutes'],
                                          right: true),
                                    ), // Glutes
                                    Positioned(
                                      top: 120,
                                      right: 42,
                                      child: runningOrNotIndicator(
                                          _areas['lowerBack'],
                                          right: true),
                                    ), // Lower Back
                                    Positioned(
                                      top: 120,
                                      right: 65,
                                      child: runningOrNotIndicator(
                                          _areas['lowerBack'],
                                          right: true),
                                    ), // Lower Back
                                    Positioned(
                                      top: 100,
                                      right: 37,
                                      child: runningOrNotIndicator(
                                          _areas['upperBack'],
                                          right: true),
                                    ), // Upper Back
                                    Positioned(
                                      top: 100,
                                      right: 70,
                                      child: runningOrNotIndicator(
                                          _areas['upperBack'],
                                          right: true),
                                    ), // Upper Back
                                    Positioned(
                                      top: 100,
                                      right: 20,
                                      child: runningOrNotIndicator(
                                          _areas['triceps'],
                                          right: true),
                                    ), // Triceps
                                    Positioned(
                                      top: 100,
                                      right: 90,
                                      child: runningOrNotIndicator(
                                          _areas['triceps'],
                                          right: true),
                                    ), // Triceps
                                    Positioned(
                                      top: 80,
                                      right: 30,
                                      child: runningOrNotIndicator(
                                          _areas['trapezius'],
                                          right: true),
                                    ), // Trapeziums
                                    Positioned(
                                      top: 80,
                                      right: 80,
                                      child: runningOrNotIndicator(
                                          _areas['trapezius'],
                                          right: true),
                                    ), // Trapeziums
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 40,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(27, 26, 41, 0.2),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Time elapsed',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TimerCountdown(
                              descriptionTextStyle: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                              colonsTextStyle: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              timeTextStyle: const TextStyle(
                                fontSize: 34.0,
                                fontWeight: FontWeight.bold,
                              ),
                              format: CountDownTimerFormat.minutesSeconds,
                              endTime: DateTime.now()
                                  .add(Duration(minutes: _trainTime)),
                              onEnd: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Pulse timer',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      PulseTimer(pulseTime: _pulseTime)
                    ],
                  ),
                ),
              );
            default:
              return const Center(
                child: Text(
                  'Not Connected...',
                ),
              );
          }
        },
      ),
    );
  }

  Widget runningOrNotIndicator(int areaIntensity, {bool? right}) {
    if (areaIntensity > 0) {
      return Padding(
        padding: right == false || right == null
            ? const EdgeInsets.only(left: 5, top: 5)
            : const EdgeInsets.only(right: 5, top: 5),
        child: RippleAnimation(
            repeat: true,
            color: pointsColor(areaIntensity),
            minRadius: 10,
            ripplesCount: 3,
            child: Container()),
      );
    } else {
      return ClipOval(
        child: Container(
          width: 10,
          height: 10,
          color: pointsColor(areaIntensity),
        ),
      );
    }
  }
}
