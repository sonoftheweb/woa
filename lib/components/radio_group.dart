import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final Map data;
  final Function callback;
  final int? selected;

  const RadioGroup({
    Key? key,
    required this.data,
    required this.callback,
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
            border: Border.all(color: Colors.grey.shade700, width: 3),
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Radio<String>(
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
