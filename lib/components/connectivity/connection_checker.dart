import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectivityChecker extends StatefulWidget {
  const ConnectivityChecker({Key? key}) : super(key: key);

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionState);
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Error Occurred: ${e.toString()} ");
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionState(result);
  }

  Future<void> _updateConnectionState(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile &&
        result == ConnectivityResult.wifi) {
      // showStatus(result, true);
    } else {
      showStatus(result, false);
    }
  }

  void showStatus(ConnectivityResult result, bool status) {
    final snackBar = SnackBar(
        content:
            Text("${status ? 'ONLINE\n' : 'OFFLINE\n'}${result.toString()} "),
        backgroundColor: status ? Colors.green : Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
