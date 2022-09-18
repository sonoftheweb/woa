import 'package:flutter/material.dart';
import 'package:woa/components/selector/quantity_input.dart';

class QuantitySelectorWidget extends StatefulWidget {
  final String label;
  final int? defaultValue;
  final Function callback;

  const QuantitySelectorWidget({
    Key? key,
    this.defaultValue,
    required this.label,
    required this.callback,
  }) : super(key: key);

  @override
  State<QuantitySelectorWidget> createState() => _QuantitySelectorWidgetState();
}

class _QuantitySelectorWidgetState extends State<QuantitySelectorWidget> {
  int? _selectedValue;

  @override
  void initState() {
    _selectedValue = widget.defaultValue ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return QuantityInput(
        elevation: 0,
        label: widget.label,
        buttonColor: Colors.green.shade500,
        value: _selectedValue,
        acceptsZero: true,
        maxValue: 10,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            _selectedValue = int.parse(value);
          });
          widget.callback(_selectedValue);
        });
  }
}
