import 'dart:io' show Platform;

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woa/components/dialogs.dart';
import 'package:woa/constants/devices_and_services.dart';

class IsConnectedOrSelect extends StatefulWidget {
  final Function callback;
  const IsConnectedOrSelect({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<IsConnectedOrSelect> createState() => _IsConnectedOrSelectState();
}

class _IsConnectedOrSelectState extends State<IsConnectedOrSelect> {
  List<BluetoothService>? _serviceDiscovered;
  BluetoothDevice? _selectedBleDevice;
  FlutterBlue flutterBlue = FlutterBlue.instance;

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

    if (_selectedBleDevice == null) {
      return StreamBuilder<BluetoothState>(
        stream: flutterBlue.state,
        initialData: BluetoothState.unknown,
        builder:
            (BuildContext context, AsyncSnapshot<BluetoothState> snapshot) {
          final bluetoothState = snapshot.data;
          if (bluetoothState != BluetoothState.on) {
            return BleIsOff(state: bluetoothState);
          } else {
            // now we begin scan
            return FutureBuilder(
              future: flutterBlue.startScan(
                withServices: [Guid(writeService), Guid(notifyService)],
                timeout: const Duration(
                  seconds: 10,
                ),
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      List<BluetoothDevice> devices =
                          snapshot.data as List<BluetoothDevice>;
                      // get the already connected devices
                      flutterBlue.connectedDevices.then(
                        (results) {
                          for (BluetoothDevice d in results) {
                            devices.add(d);
                          }
                        },
                      );

                      List<Widget> widgets = [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'Devices found',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ];

                      for (var d
                          in devices.where((d) => d.name == deviceName)) {
                        widgets.add(
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                              onTap: () async {
                                await d.connect();
                                var servicesDiscovered =
                                    await d.discoverServices();
                                setState(() {
                                  _selectedBleDevice = d;
                                  _serviceDiscovered = servicesDiscovered;
                                });
                              },
                              child: ListTile(
                                textColor: Colors.white,
                                title: Text(d.name),
                                trailing: StreamBuilder<BluetoothDeviceState>(
                                  stream: d.state,
                                  initialData:
                                      BluetoothDeviceState.disconnected,
                                  builder: (c, cSnapshot) {
                                    switch (snapshot.data) {
                                      case BluetoothDeviceState.connected:
                                        return const Icon(
                                          Icons.bluetooth_connected_rounded,
                                          color: Colors.greenAccent,
                                        );
                                      default:
                                        if (_selectedBleDevice != null) {
                                          setState(() {
                                            _selectedBleDevice = null;
                                            _serviceDiscovered = null;
                                          });
                                        }
                                        return const Icon(
                                          Icons.bluetooth_disabled_rounded,
                                          color: Colors.grey,
                                        );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: widgets,
                      );
                    } else {
                      return const Center(
                        child: Text('No device found!'),
                      );
                    }
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
        },
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: [
                Text('connected to ${_selectedBleDevice!.name}...'),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20.0),
                    backgroundColor: Colors.redAccent,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    await _selectedBleDevice?.disconnect();
                    setState(() {
                      _selectedBleDevice = null;
                      _serviceDiscovered = null;
                    });
                  },
                  child: Text(
                    'Disconnect from ${_selectedBleDevice!.name}',
                  ),
                ),
                const SizedBox(height: 60.0),
                ElevatedButton(
                  onPressed: () {
                    widget.callback(
                        true, _selectedBleDevice, _serviceDiscovered);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30.0),
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle_outline_rounded),
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
      );
    }
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
