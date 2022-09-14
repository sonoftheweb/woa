import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const CustomElevatedButton({
    Key? key,
    this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {onPressed},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade500,
        padding: const EdgeInsets.symmetric(
          horizontal: 60,
          vertical: 20,
        ),
      ),
      child: child,
    );
  }
}
