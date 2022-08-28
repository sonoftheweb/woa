import 'package:flutter/material.dart';
import 'package:woa/utils.dart';

class PreviousWorkoutWidget extends StatelessWidget {
  const PreviousWorkoutWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PreviousWorkoutHeaderWidget(
          date: 'Mon, May 11',
          title: 'CHEST & TRICEPS',
        ),
        const PreviousWorkoutBodyWidget(),
        const SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: Colors.green.shade500,
            padding: const EdgeInsets.symmetric(
              horizontal: 60,
              vertical: 20,
            ),
          ),
          child: Text('See all previous workout'),
        )
      ],
    );
  }
}

class PreviousWorkoutBodyWidget extends StatelessWidget {
  const PreviousWorkoutBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Color.fromRGBO(44, 40, 68, 1), width: 1),
          right: BorderSide(color: Color.fromRGBO(44, 40, 68, 1), width: 1),
          bottom: BorderSide(color: Color.fromRGBO(44, 40, 68, 1), width: 1),
        ),
        color: Color.fromRGBO(71, 60, 97, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: const [
                PreviousWorkoutCaloriesBurnedWidget(caloriesBurned: 344),
                PreviousWorkoutTimeSpentWidget(timeSpent: 84),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Bench Press',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: VerticalSingleLineGraphWidget(
                      count: 1,
                      weight: 100,
                      reps: 10,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: VerticalSingleLineGraphWidget(
                      count: 2,
                      weight: 100,
                      reps: 10,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: VerticalSingleLineGraphWidget(
                      count: 3,
                      weight: 100,
                      reps: 8,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: VerticalSingleLineGraphWidget(
                      count: 4,
                      weight: 100,
                      reps: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalSingleLineGraphWidget extends StatelessWidget {
  final int count;
  final int weight;
  final int reps;

  const VerticalSingleLineGraphWidget({
    Key? key,
    required this.count,
    required this.weight,
    required this.reps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: reps * 10,
          height: 20.0,
          decoration: BoxDecoration(
            color: verticalSingleLineGraphColor(reps * 10),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: darken(verticalSingleLineGraphColor(reps * 10), 0.1),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(count.toString(), textAlign: TextAlign.center),
              ),
              const SizedBox(
                width: 5.0,
              ),
              (reps * 10 >= 60)
                  ? Text(
                      '$weight Kg',
                      style: const TextStyle(
                        fontSize: 11,
                      ),
                    )
                  : const Text(''),
            ],
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            reps.toString(),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Color verticalSingleLineGraphColor(int value) {
    if (value >= 90) {
      return const Color.fromRGBO(57, 180, 120, 1);
    } else if (value >= 60 && value < 90) {
      return const Color.fromRGBO(152, 186, 64, 1);
    } else if (value >= 50 && value < 60) {
      return const Color.fromRGBO(154, 143, 36, 1);
    } else {
      return const Color.fromRGBO(191, 81, 104, 1);
    }
  }
}

class PreviousWorkoutTimeSpentWidget extends StatelessWidget {
  final int timeSpent;

  const PreviousWorkoutTimeSpentWidget({
    Key? key,
    required this.timeSpent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Color.fromRGBO(44, 40, 68, 1),
            width: 1,
          ),
          bottom: BorderSide(
            color: Color.fromRGBO(44, 40, 68, 1),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
      alignment: Alignment.center,
      child: const IconTextDescriptor(
        number: 84,
        icon: Icons.watch_outlined,
        descriptor: 'MIN SPENT',
      ),
    );
  }
}

class PreviousWorkoutCaloriesBurnedWidget extends StatelessWidget {
  final int caloriesBurned;

  const PreviousWorkoutCaloriesBurnedWidget({
    Key? key,
    required this.caloriesBurned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Color.fromRGBO(44, 40, 68, 1),
            width: 1,
          ),
          bottom: BorderSide(
            color: Color.fromRGBO(44, 40, 68, 1),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
      alignment: Alignment.center,
      child: IconTextDescriptor(
        number: caloriesBurned,
        icon: Icons.local_fire_department_outlined,
        descriptor: 'CALORIES BURNED',
      ),
    );
  }
}

class IconTextDescriptor extends StatelessWidget {
  final int number;
  final IconData icon;
  final String descriptor;

  const IconTextDescriptor({
    Key? key,
    required this.number,
    required this.icon,
    required this.descriptor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.blue[300],
            ),
            const SizedBox(width: 10.0),
            Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        Text(
          descriptor,
          style: TextStyle(
            fontSize: 11.0,
            color: Colors.blue[300],
          ),
        ),
      ],
    );
  }
}

class PreviousWorkoutHeaderWidget extends StatelessWidget {
  final String date;
  final String title;

  const PreviousWorkoutHeaderWidget({
    Key? key,
    required this.date,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(44, 40, 68, 1),
        ),
        color: const Color.fromRGBO(68, 60, 104, 1),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 35.0,
              right: 35.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  textAlign: TextAlign.left,
                  'Previous: $date',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  textAlign: TextAlign.left,
                  title,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
