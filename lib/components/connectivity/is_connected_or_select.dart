import 'dart:io' show Platform;

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:woa/components/dialogs.dart';

class IsConnectedOrSelect extends StatefulWidget {
  const IsConnectedOrSelect({Key? key}) : super(key: key);

  @override
  State<IsConnectedOrSelect> createState() => _IsConnectedOrSelectState();
}

class _IsConnectedOrSelectState extends State<IsConnectedOrSelect> {
  bool scanInProgress = false;

  void isScanning() {
    FlutterBlue.instance.isScanning.listen((event) {
      setState(() {
        scanInProgress = event;
      });
    });
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
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (BuildContext context, AsyncSnapshot<BluetoothState> snapshot) {
        final state = snapshot.data;
        if (state != BluetoothState.on) {
          return BleIsOff(state: state);
        } else {
          // check for what the bluetooth is connected to
          //FlutterBlue.instance.startScan(timeout: const Duration(seconds: 10));
          return StreamBuilder<bool>(
              stream: FlutterBlue.instance.isScanning,
              builder: (context, snapshot) {
                if (snapshot.data != true) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white70,
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          bottom: 10,
                          top: 10,
                        ),
                        child: Text(
                          'Devices available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      StreamBuilder<List<BluetoothDevice>>(
                        stream: Stream.periodic(const Duration(seconds: 8))
                            .asyncMap(
                                (_) => FlutterBlue.instance.connectedDevices),
                        initialData: [],
                        builder: (c, snapshot) => Column(
                          children: snapshot.data!.map((d) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.greenAccent, width: 3),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  textColor: Colors.white70,
                                  title: Text(d.name),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      StreamBuilder<List<ScanResult>>(
                        stream: FlutterBlue.instance.scanResults,
                        initialData: [],
                        builder: (c, snapshot) => Column(
                          children: snapshot.data!
                              .where((d) => d.device.name != '')
                              .map(
                            (d) {
                              return GestureDetector(
                                onTap: () {
                                  d.device.connect();
                                  d.device.discoverServices();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white70, width: 3),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    textColor: Colors.white70,
                                    title: Text(d.device.name),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  );
                }
              });
        }
      },
    );
    /*return Padding(
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
          children: const [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.bluetooth_connected_rounded,
                size: 30.0,
              ),
            ),
            Text('is connected to'),
          ],
        ),
      ),
    );*/
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

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap})
      : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;

  Widget _buildTitle(BuildContext context) {
    if (result.device.name.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(result.device.name),
          Text(result.device.id.toString())
        ],
      );
    } else {
      return Text(result.device.id.toString());
    }
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.caption),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  String getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      leading: Text(result.rssi.toString()),
      trailing: ElevatedButton(
        onPressed: (result.advertisementData.connectable) ? onTap : null,
        child: const Text('CONNECT'),
      ),
      children: <Widget>[
        _buildAdvRow(
            context, 'Complete Local Name', result.advertisementData.localName),
        _buildAdvRow(context, 'Tx Power Level',
            '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
        _buildAdvRow(context, 'Manufacturer Data',
            getNiceManufacturerData(result.advertisementData.manufacturerData)),
        _buildAdvRow(
            context,
            'Service UUIDs',
            (result.advertisementData.serviceUuids.isNotEmpty)
                ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
                : 'N/A'),
        _buildAdvRow(context, 'Service Data',
            getNiceServiceData(result.advertisementData.serviceData)),
      ],
    );
  }
}
