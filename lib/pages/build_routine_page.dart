import 'package:flutter/material.dart';
import 'package:quantity_input/quantity_input.dart';

import '../services/auth/auth_service.dart';
import '../utils.dart';

class BuildRoutinePage extends StatefulWidget {
  const BuildRoutinePage({Key? key}) : super(key: key);

  @override
  State<BuildRoutinePage> createState() => _BuildRoutinePageState();
}

class _BuildRoutinePageState extends State<BuildRoutinePage> {
  int biceps = 0;
  int triceps = 0;
  int chest = 0;
  int abdomen = 0;
  int trapezius = 0;
  int upperBack = 0;
  int lowerBack = 0;
  int glutes = 0;
  int quadriceps = 0;
  int hamstring = 0;
  String mode = 'power';
  int frequency = 0;
  int pulseTime = 20;
  int pauseTime = 0;
  int trainTime = 20;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser;
    checkAuth(user, context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: const Text('Build a new routine'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 250,
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
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
                                width: 10, height: 10, color: Colors.white),
                          ),
                        ), // Chest
                        Positioned(
                          top: 75,
                          left: 69,
                          child: ClipOval(
                            child: Container(
                                width: 10, height: 10, color: Colors.white),
                          ),
                        ), // Chest
                        Positioned(
                          top: 94,
                          left: 91,
                          child: ClipOval(
                            child: Container(
                              width: 10,
                              height: 10,
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
                              color: Colors.white,
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
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: QuantityInput(
                        label: 'Biceps',
                        buttonColor: const Color.fromRGBO(57, 180, 120, 1),
                        value: biceps,
                        acceptsZero: true,
                        maxValue: 10,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        onChanged: (value) {
                          setState(() {
                            biceps = int.parse(value.replaceAll(',', ''));
                          });
                        }),
                  ),
                  Expanded(
                    child: QuantityInput(
                        label: 'Triceps',
                        buttonColor: const Color.fromRGBO(57, 180, 120, 1),
                        value: triceps,
                        acceptsZero: true,
                        maxValue: 10,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            triceps = int.parse(value.replaceAll(',', ''));
                          });
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: QuantityInput(
                        label: 'Chest',
                        buttonColor: const Color.fromRGBO(57, 180, 120, 1),
                        value: chest,
                        acceptsZero: true,
                        maxValue: 10,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            chest = int.parse(value.replaceAll(',', ''));
                          });
                        }),
                  ),
                  Expanded(
                    child: QuantityInput(
                        label: 'Abdomen',
                        buttonColor: const Color.fromRGBO(57, 180, 120, 1),
                        value: abdomen,
                        acceptsZero: true,
                        maxValue: 10,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            abdomen = int.parse(value.replaceAll(',', ''));
                          });
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: QuantityInput(
                        label: 'Trapezius',
                        buttonColor: const Color.fromRGBO(57, 180, 120, 1),
                        value: trapezius,
                        acceptsZero: true,
                        maxValue: 10,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            trapezius = int.parse(value.replaceAll(',', ''));
                          });
                        }),
                  ),
                  Expanded(
                    child: QuantityInput(
                        label: 'Upper Back',
                        buttonColor: const Color.fromRGBO(57, 180, 120, 1),
                        value: upperBack,
                        acceptsZero: true,
                        maxValue: 10,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            upperBack = int.parse(value.replaceAll(',', ''));
                          });
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: QuantityInput(
                        label: 'Lower Back',
                        buttonColor: const Color.fromRGBO(57, 180, 120, 1),
                        value: lowerBack,
                        acceptsZero: true,
                        maxValue: 10,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            lowerBack = int.parse(value.replaceAll(',', ''));
                          });
                        }),
                  ),
                  Expanded(
                    child: QuantityInput(
                        label: 'Glutes',
                        buttonColor: const Color.fromRGBO(57, 180, 120, 1),
                        value: glutes,
                        acceptsZero: true,
                        maxValue: 10,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            glutes = int.parse(value.replaceAll(',', ''));
                          });
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: QuantityInput(
                        label: 'Quadriceps',
                        buttonColor: const Color.fromRGBO(57, 180, 120, 1),
                        value: quadriceps,
                        acceptsZero: true,
                        maxValue: 10,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            quadriceps = int.parse(value.replaceAll(',', ''));
                          });
                        }),
                  ),
                  Expanded(
                    child: QuantityInput(
                        label: 'Hamstrings',
                        buttonColor: const Color.fromRGBO(57, 180, 120, 1),
                        value: hamstring,
                        acceptsZero: true,
                        maxValue: 10,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            hamstring = int.parse(value.replaceAll(',', ''));
                          });
                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              label: const Text('Next'),
              style: TextButton.styleFrom(primary: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
