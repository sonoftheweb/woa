import 'dart:async';

import 'package:flutter/material.dart';

class PulseTimer extends StatefulWidget {
  final int pulseTime;

  const PulseTimer({Key? key, required this.pulseTime}) : super(key: key);

  @override
  State<PulseTimer> createState() => _PulseTimerState();
}

class _PulseTimerState extends State<PulseTimer> {
  late int _pulseTimeTicker;
  late Timer _pulseTimer;

  @override
  void initState() {
    _pulseTimeTicker = 0;
    _pulseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_pulseTimeTicker >= widget.pulseTime) {
        if (mounted) {
          setState(() {
            _pulseTimeTicker = 0;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _pulseTimeTicker += 1;
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Pulse timer',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w100,
          ),
        ),
        Text('$_pulseTimeTicker'),
      ],
    );
  }
}
