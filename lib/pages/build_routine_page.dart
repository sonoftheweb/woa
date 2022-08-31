import 'package:flutter/material.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:woa/pages/build_routine_page_2.dart';

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
  int thigh = 0;
  int calf = 0;
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
                          child: ClipOval(
                            child: Container(
                              width: 10,
                              height: 10,
                              color: pointsColor(chest),
                            ),
                          ),
                        ), // Chest
                        Positioned(
                          top: 75,
                          left: 69,
                          child: ClipOval(
                            child: Container(
                              width: 10,
                              height: 10,
                              color: pointsColor(chest),
                            ),
                          ),
                        ), // Chest
                        Positioned(
                          top: 94,
                          left: 91,
                          child: ClipOval(
                            child: Container(
                              width: 10,
                              height: 10,
                              color: pointsColor(biceps),
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
                              color: pointsColor(biceps),
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
                              color: pointsColor(abdomen),
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
                              color: pointsColor(abdomen),
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
                              color: pointsColor(thigh),
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
                              color: pointsColor(thigh),
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
                              color: pointsColor(calf),
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
                              color: pointsColor(calf),
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
                              color: pointsColor(hamstring),
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
                              color: pointsColor(hamstring),
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
                              color: pointsColor(glutes),
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
                              color: pointsColor(glutes),
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
                              color: pointsColor(lowerBack),
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
                              color: pointsColor(lowerBack),
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
                              color: pointsColor(upperBack),
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
                              color: pointsColor(upperBack),
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
                              color: pointsColor(triceps),
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
                              color: pointsColor(triceps),
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
                              color: pointsColor(trapezius),
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
                              color: pointsColor(trapezius),
                            ),
                          ),
                        ), // Trapeziums
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  QuantityInput(
                      label: 'Biceps',
                      buttonColor: Colors.green.shade500,
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
                  QuantityInput(
                      label: 'Triceps',
                      buttonColor: Colors.green.shade500,
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  QuantityInput(
                      label: 'Chest',
                      buttonColor: Colors.green.shade500,
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
                  QuantityInput(
                      label: 'Abdomen',
                      buttonColor: Colors.green.shade500,
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  QuantityInput(
                      label: 'Trapezius',
                      buttonColor: Colors.green.shade500,
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
                  QuantityInput(
                      label: 'Upper Back',
                      buttonColor: Colors.green.shade500,
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  QuantityInput(
                      label: 'Lower Back',
                      buttonColor: Colors.green.shade500,
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
                  QuantityInput(
                      label: 'Glutes',
                      buttonColor: Colors.green.shade500,
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  QuantityInput(
                      label: 'Quadriceps',
                      buttonColor: Colors.green.shade500,
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
                  QuantityInput(
                      label: 'Hamstrings',
                      buttonColor: Colors.green.shade500,
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  QuantityInput(
                      label: 'Thighs',
                      buttonColor: Colors.green.shade500,
                      value: thigh,
                      acceptsZero: true,
                      maxValue: 10,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          thigh = int.parse(value.replaceAll(',', ''));
                        });
                      }),
                  QuantityInput(
                      label: 'Calf',
                      buttonColor: Colors.green.shade500,
                      value: calf,
                      acceptsZero: true,
                      maxValue: 10,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          calf = int.parse(value.replaceAll(',', ''));
                        });
                      }),
                  /*ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade500,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 20,
                      ),
                    ),
                    child: const Text('Sign In'),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Map<String, int> data = {
            'bicep': biceps,
            'triceps': triceps,
            'chest': chest,
            'abdomen': abdomen,
            'thigh': thigh,
            'calf': calf,
            'trapezius': trapezius,
            'upperBack': upperBack,
            'lowerBack': lowerBack,
            'glutes': glutes,
            'quadriceps': quadriceps,
            'hamstring': hamstring,
          };
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BuildRoutinePageFinalPage(workoutSettings: data),
            ),
          );
        },
        backgroundColor: Colors.green.shade500,
        label: const Text('Next'),
        icon: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }

  Color pointsColor(int bodyPart) {
    switch (bodyPart) {
      case 1:
      case 2:
      case 3:
        return Colors.green;
      case 4:
      case 5:
      case 6:
        return Colors.orange;
      case 7:
      case 8:
      case 9:
      case 10:
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
