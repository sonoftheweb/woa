import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final Map data;
  final Function callback;
  final int? selected;
  final Color? textColor;

  const RadioGroup({
    Key? key,
    required this.data,
    required this.callback,
    this.textColor,
    this.selected,
  }) : super(key: key);

  @override
  State<RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  int? _selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.selected != 0 && widget.selected != _selectedValue) {
      setState(() {
        _selectedValue = widget.selected;
      });
    }
    return Column(
      children: widget.data.entries.map((e) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.textColor ?? Colors.black45,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            textColor: widget.textColor ?? Colors.black45,
            leading: Radio<String>(
              fillColor: MaterialStateColor.resolveWith(
                  (states) => widget.textColor ?? Colors.black45),
              value: e.key.toString(),
              groupValue: _selectedValue.toString(),
              onChanged: (value) {
                setState(() {
                  _selectedValue = int.parse(value!);
                });
                widget.callback(_selectedValue);
              },
            ),
            title: Text(e.value.toString()),
          ),
        );
      }).toList(),
    );
  }
}
