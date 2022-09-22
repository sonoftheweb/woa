import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothChecker extends StatefulWidget {
  const BluetoothChecker({Key? key}) : super(key: key);

  @override
  State<BluetoothChecker> createState() => _BluetoothCheckerState();
}

class _BluetoothCheckerState extends State<BluetoothChecker> {
  final reactiveBle = FlutterReactiveBle();
  late Stream _statusStream;
  late Stream _connectedDeviceStream;

  @override
  void initState() {
    super.initState();
    _statusStream = reactiveBle.statusStream;
    _connectedDeviceStream = reactiveBle.connectedDeviceStream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _statusStream,
      initialData: BleStatus.unknown,
      builder: (context, snapshot) {
        final state = snapshot.data as BleStatus;
        switch (state) {
          case BleStatus.poweredOff:
          case BleStatus.unsupported:
          case BleStatus.unauthorized:
            return BleIsOff(state: state);
          default:
            return StreamBuilder(
              stream: _connectedDeviceStream,
              builder: (context, connectionSnapshot) {
                final connectionState = connectionSnapshot.data;
                print(connectionState);
                return Container();
              },
            );
          // _connectedDeviceStream.listen((state) {
          //   print(state.deviceId);
          //   switch (state) {
          //     case DeviceConnectionState.connected:
          //       break;
          //     default:
          //       return Text('nothing connected');
          //   }
          // });
          // case BleStatus.unknown:
          //   // TODO: Handle this case.
          //   break;
          // case BleStatus.unauthorized:
          //   // TODO: Handle this case.
          //   break;
          // case BleStatus.locationServicesDisabled:
          //   // TODO: Handle this case.
          //   break;
          // case BleStatus.ready:
          //   // TODO: Handle this case.
          //   break;
        }
      },
    );
  }
}

class BleIsOff extends StatelessWidget {
  const BleIsOff({Key? key, this.state}) : super(key: key);

  final BleStatus? state;

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
            'Bluetooth is ${state != null ? state.toString().substring(10) : 'not available for this device'}.',
          ),
          state == BleStatus.poweredOff || state == BleStatus.unauthorized
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
