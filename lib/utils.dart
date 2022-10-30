import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:woa/services/auth/auth_user.dart';

import 'constants/routes.dart';

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

Builder navigationBuilder() {
  return Builder(
    builder: (context) => IconButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
      icon: SvgPicture.asset(
        "assets/drawer.svg",
        color: const Color.fromARGB(100, 64, 202, 255),
        height: 15,
        width: 34,
      ),
    ),
  );
}

void checkAuth(AuthUser? user, BuildContext context) {
  if (user == null) Navigator.of(context).pushNamed(loginRoute);
}

OverlayEntry addSpot(Offset pos) {
  return OverlayEntry(
    maintainState: true,
    builder: (context) {
      return Stack(
        children: [
          Positioned(
            top: pos.dy - 10,
            left: pos.dx - 10,
            child: ClipOval(
              child: Container(
                width: 10,
                height: 10,
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget buildCard(int index, context) {
  return GestureDetector(
      onTapDown: (details) {
        Overlay.of(context)?.insert(addSpot(details.globalPosition));
      },
      child: Image.asset('assets/images/bodmap.png', width: 400));
}

Widget buildImageMap(int index, context) {
  return GestureDetector(
      onTapDown: (details) {
        Overlay.of(context)?.insert(addSpot(details.globalPosition));
      },
      child: Image.asset('assets/images/bodmap.png', width: 300));
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

String getNumberAddZero(int number) {
  if (number < 10) {
    return "0$number";
  }
  return number.toString();
}
