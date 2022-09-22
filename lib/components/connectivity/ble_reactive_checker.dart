import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothChecker extends StatefulWidget {
  const BluetoothChecker({Key? key}) : super(key: key);

  @override
  State<BluetoothChecker> createState() => _BluetoothCheckerState();
}

class _BluetoothCheckerState extends State<BluetoothChecker> {
  final _fb = FlutterBlue.instance;
  late Stream _statusStream;

  @override
  void initState() {
    super.initState();
    _statusStream = _fb.state;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _statusStream,
        initialData: BluetoothState.unknown,
        builder: (context, snapshot) {
          final state = snapshot.data as BluetoothState;
          if (state == BluetoothState.on) {
            return Container(); // it's on, do nothing
          }
          return BleIsOff(state: state);
        });
  }
}

class BleIsOff extends StatelessWidget {
  const BleIsOff({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        top: 5.0,
        bottom: 5.0,
      ),
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(color: Colors.red.shade400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.bluetooth_disabled,
            color: Colors.white54,
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Text(
            'Bluetooth is ${state != null ? state.toString().substring(15) : 'not available for this device'}.',
          ),
          state == BleStatus.poweredOff
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
    );
  }
}

class BlueToothReadyChip extends StatefulWidget {
  const BlueToothReadyChip({Key? key}) : super(key: key);

  @override
  State<BlueToothReadyChip> createState() => _BlueToothReadyChipState();
}

class _BlueToothReadyChipState extends State<BlueToothReadyChip> {
  late Future<List<BluetoothDevice>> _connectedDevices;
  @override
  void initState() {
    _connectedDevices = FlutterBlue.instance.connectedDevices;
    FlutterBlue.instance.startScan(timeout: const Duration(seconds: 10));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int countConnected = 0;
    return StreamBuilder<List<BluetoothDevice>>(
      stream: Stream.periodic(const Duration(seconds: 10))
          .asyncMap((_) => _connectedDevices),
      initialData: [],
      builder: (context, snapshot) {
        for (var d in snapshot.data!) {
          d.state.listen((state) {
            if (state == BluetoothDeviceState.connected) {
              countConnected++;
            }
          });
        }
        return Row(
          children: [
            Icon(countConnected > 0
                ? Icons.bluetooth_connected
                : Icons.bluetooth_disabled),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Text(countConnected > 0 ? 'Connected' : 'No device'),
          ],
        );
      },
    );
  }
}
