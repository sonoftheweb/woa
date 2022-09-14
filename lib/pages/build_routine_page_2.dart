import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:woa/components/radio_group.dart';

import '../components/form_title_widget.dart';

class BuildRoutinePageFinalArguments {
  final Map<String, int> settings;
  final Map<String, dynamic> deviceSettings;

  BuildRoutinePageFinalArguments(this.settings, this.deviceSettings);
}

class BuildRoutinePageFinalPage extends StatefulWidget {
  const BuildRoutinePageFinalPage({Key? key}) : super(key: key);

  @override
  State<BuildRoutinePageFinalPage> createState() =>
      _BuildRoutinePageFinalPageState();
}

class _BuildRoutinePageFinalPageState extends State<BuildRoutinePageFinalPage> {
  Map powerModes = {
    'power': 'Power',
    'meta': 'Meta & Cell',
    'relax': 'Body Relax',
    'endurance': 'Endurance',
    'fat_burn': 'Fat Burning'
  };

  double _frequency = 85.0;
  double _pulseW = 350.0;
  double _pulseT = 20.0;
  double _pauseT = 0.0;
  double _trainT = 20.0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as BuildRoutinePageFinalArguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: const Text('Save routine'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 30.0, right: 30.0),
          child: Column(
            children: [
              const Center(
                child: FormTitleWidget(registrationText: 'Mode selection'),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              RadioGroup(
                data: powerModes.values.toList().asMap(),
                selected: args.deviceSettings['powerMode'],
                callback: (selectedMode) {
                  setState(() {
                    args.deviceSettings['powerMode'] = selectedMode;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              const Center(
                child: FormTitleWidget(registrationText: 'Parameters'),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              SfSlider(
                value: _frequency,
                min: 10.0,
                max: 130.0,
                interval: 20.0,
                stepSize: 5.0,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 5,
                inactiveColor: Colors.green,
                activeColor: Colors.green,
                onChanged: (dynamic value) {
                  setState(() {
                    _frequency = value;
                    args.deviceSettings['frequency'] = value;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              const Center(
                child: Text('Frequency'),
              ),
              SfSlider(
                value: _pulseW,
                min: 0.0,
                max: 500.0,
                interval: 100.0,
                stepSize: 10.0,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 5,
                inactiveColor: Colors.green,
                activeColor: Colors.green,
                onChanged: (dynamic value) {
                  setState(() {
                    _pulseW = value;
                    args.deviceSettings['pulseWidth'] = value;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              const Center(
                child: Text('Pulse Width'),
              ),
              SfSlider(
                value: _pulseT,
                min: 10,
                max: 60,
                interval: 10,
                stepSize: 5.0,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 5,
                inactiveColor: Colors.green,
                activeColor: Colors.green,
                onChanged: (dynamic value) {
                  setState(() {
                    _pulseT = value;
                    args.deviceSettings['pulseTime'] = value;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              const Center(
                child: Text('Pulse Time'),
              ),
              SfSlider(
                value: _pauseT,
                min: 0,
                max: 60,
                interval: 10,
                stepSize: 1.0,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 5,
                inactiveColor: Colors.green,
                activeColor: Colors.green,
                onChanged: (dynamic value) {
                  setState(() {
                    _pauseT = value;
                    args.deviceSettings['pauseTime'] = value;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              const Center(
                child: Text('Pause Time'),
              ),
              SfSlider(
                value: _trainT,
                min: 0,
                max: 60,
                interval: 10,
                stepSize: 1.0,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 5,
                inactiveColor: Colors.green,
                activeColor: Colors.green,
                onChanged: (dynamic value) {
                  setState(() {
                    _trainT = value;
                    args.deviceSettings['trainTime'] = value;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              const Center(
                child: Text('Train Time'),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.green.shade500,
        label: const Text('Save'),
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }
}
