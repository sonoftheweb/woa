import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final Color? buttonColor, iconColor;
  final Function onTap;
  final double elevation;

  const IconButtonWidget(
      {super.key,
      required this.icon,
      this.buttonColor,
      this.iconColor,
      required this.onTap,
      this.elevation = 5});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: buttonColor ?? Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
            width: 38,
            height: 38,
            child: Icon(icon, size: 25, color: iconColor ?? Colors.white)),
        onTap: () => onTap(),
      ),
    );
  }
}
