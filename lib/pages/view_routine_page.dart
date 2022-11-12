import 'dart:convert';
import 'dart:io' show Platform;

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woa/pages/routine_work.dart';
import 'package:woa/services/auth/auth_service.dart';
import 'package:woa/services/cloud/cloud_workout.dart';
import 'package:woa/services/cloud/firebase_cloud_storage.dart';
import 'package:woa/utils.dart';

import '../components/charts/spline.dart';
import '../components/dialogs.dart';
import '../constants/devices_and_services.dart';
import '../constants/routes.dart';
import '../enums/power_modes.dart';

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
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? _device;

  @override
  void initState() {
    _workoutService = FirebaseCloudStorage();
    _getCurrentWorkout = getCurrentWorkout(widget.args.workoutId);
    super.initState();
  }

  @override
  void dispose() {
    _device?.disconnect().then((value) {
      _device = null;
    });
    super.dispose();
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

  Future<bool> requestPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus>? permissionResults;
    if (Platform.isAndroid) {
      permissionResults = await [
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();
    } else if (Platform.isIOS) {
      permissionResults = await [
        Permission.bluetooth,
      ].request();
    }

    if (permissionResults != null) {
      for (var permissionResult in permissionResults.entries) {
        if (permissionResult.value == PermissionStatus.permanentlyDenied) {
          DialogBoxes(
            context: context,
            title:
                '${permissionResult.key.toString().substring(11)} permissions needed.',
            body:
                'To begin this routine, the application would require ${permissionResult.key.toString().substring(11)} access. Please click yes to enable access in settings.',
            boolAction: (answer) async {
              if (answer) {
                await AppSettings.openBluetoothSettings();
              } else {
                // do nothing
              }
            },
          ).dialogBox();
        }
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    requestPermissions(context);

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
            return buildBody(snapshot.hasData);
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

  Scaffold buildBody(hasData) {
    if (hasData) {
      CloudWorkout? workout = _workout;
      Map<String, dynamic> settings = json.decode(workout!.settings!);
      Map<String, dynamic> areas = json.decode(workout.areas!);
      int areasTrainable =
          areas.entries.where((a) => a.value != 0).toList().length;
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          title: Text(workout.name!),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              padding: const EdgeInsets.only(top: 10.0),
              margin: const EdgeInsets.only(
                top: 30.0,
                left: 20.0,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Activity in last 5 days',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade500,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade900,
                        )
                      ],
                    ),
                    child: AnimatedSplineChart(
                      chartData: [
                        ChartData("Mon", 19),
                        ChartData("Tue", 12),
                        ChartData("Wed", 17),
                        ChartData("Thur", 11),
                        ChartData("Fri", 14),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Workout attributes',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade500,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.punch_clock_rounded,
                              size: 30.0,
                            ),
                            Text(
                              "${settings['trainTime']} mins",
                              style: const TextStyle(
                                fontSize: 40.0,
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
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width:
                                (MediaQuery.of(context).size.width - 100) / 2,
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade500,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  camelToNormal(
                                    PowerModes
                                        .values[int.parse(settings['mode'])]
                                        .toString()
                                        .substring(11),
                                  ).toUpperCase(),
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
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width:
                                (MediaQuery.of(context).size.width - 100) / 2,
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              '$areasTrainable trainable areas',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 40.0,
                        ),
                      ),
                      (_device != null)
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Column(
                                    children: [
                                      Text('connected to ${_device!.name}...'),
                                      const SizedBox(height: 20.0),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(20.0),
                                          backgroundColor: Colors.redAccent,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        onPressed: () async {
                                          await _device?.disconnect();
                                          setState(() {
                                            _device = null;
                                          });
                                        },
                                        child: Text(
                                          'Disconnect from ${_device!.name}',
                                        ),
                                      ),
                                      const SizedBox(height: 60.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_device != null) {
                                            Navigator.pushNamed(
                                              context,
                                              routineWork,
                                              arguments: WorkRoutineArgument(
                                                workout: workout,
                                                device: _device!,
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(30.0),
                                          textStyle: const TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons
                                                .check_circle_outline_rounded),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              'Begin workout routine!',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : StreamBuilder(
                              stream: flutterBlue.state,
                              initialData: BluetoothState.unknown,
                              builder: (BuildContext context,
                                  AsyncSnapshot<BluetoothState> snapshot) {
                                final state = snapshot.data;
                                if (state != BluetoothState.on) {
                                  return BleIsOff(state: state);
                                } else {
                                  return FutureBuilder(
                                    future: FlutterBlue.instance.startScan(
                                      timeout: const Duration(
                                        seconds: 10,
                                      ),
                                    ),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.done:
                                          if (snapshot.hasData) {
                                            var devices = snapshot.data as List;
                                            List<Widget> widgets = [
                                              const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(20.0),
                                                  child: Text(
                                                    'Devices found',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ];

                                            if (devices
                                                .where((d) =>
                                                    d.device.name == deviceName)
                                                .isNotEmpty) {
                                              for (var d in devices.where((d) =>
                                                  d.device.name ==
                                                  deviceName)) {
                                                widgets.add(Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 3,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 8),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await d.device.connect();
                                                      setState(() {
                                                        _device = d.device;
                                                      });
                                                    },
                                                    child: listTilesMethod(
                                                        d, snapshot),
                                                  ),
                                                ));
                                              }
                                            } else {
                                              widgets.add(
                                                const SizedBox(height: 20),
                                              );
                                              widgets.add(
                                                const Icon(
                                                  Icons
                                                      .bluetooth_disabled_rounded,
                                                  size: 90.0,
                                                ),
                                              );
                                            }

                                            return Column(
                                              children: widgets,
                                            );
                                          }
                                          return Center(
                                            child: Column(
                                              children: const [
                                                Text('No device found!'),
                                                SizedBox(height: 20),
                                                Icon(
                                                  Icons
                                                      .bluetooth_disabled_rounded,
                                                  size: 90.0,
                                                ),
                                              ],
                                            ),
                                          );
                                        default:
                                          return Center(
                                            child: Column(
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.all(20.0),
                                                  child: Text(
                                                    '... getting devices',
                                                    style: TextStyle(
                                                      color: Colors.greenAccent,
                                                    ),
                                                  ),
                                                ),
                                                CircularProgressIndicator(
                                                  color: Colors.white70,
                                                ),
                                              ],
                                            ),
                                          );
                                      }
                                    },
                                  );
                                }
                              }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          title: const Text('Failed to get workout'),
        ),
        body: const Center(
          child: Text('No data was found for this workout.'),
        ),
      );
    }
  }

  ListTile listTilesMethod(d, AsyncSnapshot<Object?> snapshot) {
    return ListTile(
      textColor: Colors.white,
      title: Text(d.device.name),
      trailing: StreamBuilder<BluetoothDeviceState>(
        stream: d.device.state,
        initialData: BluetoothDeviceState.disconnected,
        builder: (c, cSnapshot) {
          switch (cSnapshot.data) {
            case BluetoothDeviceState.connected:
              return const Icon(
                Icons.bluetooth_connected_rounded,
                color: Colors.greenAccent,
              );
            default:
              if (_device != null) {
                setState(() {
                  _device = null;
                });
              }
              return const Icon(
                Icons.bluetooth_disabled_rounded,
                color: Colors.grey,
              );
          }
        },
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

class BleIsOff extends StatelessWidget {
  const BleIsOff({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 860,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.bluetooth_disabled_rounded,
                size: 30.0,
              ),
            ),
            Text(
              'Bluetooth is ${state != null ? state.toString().substring(15) : 'not available for this device'}.',
            ),
            state == BluetoothState.off
                ? Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await AppSettings.openBluetoothSettings();
                      },
                      child: const Text('Turn on.'),
                    ),
                  )
                : const Padding(padding: EdgeInsets.only(left: 10.0)),
          ],
        ),
      ),
    );
  }
}
