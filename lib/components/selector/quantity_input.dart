library quantity_input;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'icon-button.widget.dart';

/// quantity input type
/// [int] default mask type, to format value as int
/// [double] to format value as double
enum QuantityInputType {
  int,
  double,
}

class QuantityInput extends StatefulWidget {
  /// Has to be an int or double depending on QuantityInputType variable
  final dynamic value;

  /// Detects changes to the input and sends value through param
  final Function(String) onChanged;

  /// The value that is incremented or decremented each time the user presses a button
  final dynamic step;

  /// The number of decimal places that can be displayed for double input
  final int decimalDigits;

  /// Set min value to be displayed in input
  final dynamic minValue;

  /// Set max value to be displayed in input
  final dynamic maxValue;

  /// The width of the textfield input
  final double inputWidth;

  /// Sets color for increment and decrement buttons
  final Color? buttonColor;

  /// Sets color for icons inside increment and decrement buttons
  final Color? iconColor;

  /// Sets label for input
  final String label;

  /// Determines if the input will be readOnly
  final bool readOnly;

  /// If set to true, the input can accept the value 0
  final bool acceptsZero;

  /// If set to true, the input can accept negative values
  final bool acceptsNegatives;

  /// Determines if the input will manage values as int or double
  final QuantityInputType? type;

  /// Sets custom InputDecoration to the widget TextFormField
  final InputDecoration? decoration;

  final Color? textColor;

  /// Sets elevation to increment and decrement buttons
  final double elevation;

  /// Creates a widget that can be used to manage number inputs
  ///
  /// Widget can manage integer or double values
  const QuantityInput({
    Key? key,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.decimalDigits = 1,
    this.buttonColor,
    this.iconColor,
    this.label = '',
    this.readOnly = false,
    this.acceptsNegatives = false,
    this.acceptsZero = false,
    this.minValue = 1,
    this.maxValue = 100000,
    this.type = QuantityInputType.int,
    this.inputWidth = 80,
    this.decoration,
    this.textColor,
    this.elevation = 5,
  })  : assert(decimalDigits > 0,
            'Decimal digits cannot be set to zero or negative value'),
        assert(!(acceptsZero && acceptsNegatives),
            'acceptsZero and acceptsNegatives cannot be simultaneously true'),
        super(key: key);

  @override
  State<QuantityInput> createState() => _QuantityInputState();
}

class _QuantityInputState extends State<QuantityInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = valueFormatter(widget.value);
  }

  String valueFormatter(dynamic value) {
    String extraZeros = '';

    if (widget.decimalDigits > 0 && widget.type == QuantityInputType.double) {
      extraZeros = '.';
      extraZeros = extraZeros.padRight(widget.decimalDigits + 1, '0');
    }

    NumberFormat formatter = NumberFormat(
        '#,###,###,###,###,###,###,###,###,##0$extraZeros', 'en_US');

    return formatter.format(value);
  }

  String parseNewDouble(String value) {
    String fullPartOfDouble =
        value.substring(0, value.length - widget.decimalDigits);
    String decimalPartOfDouble =
        value.substring(value.length - widget.decimalDigits);
    String newFullValue = '$fullPartOfDouble.$decimalPartOfDouble';

    return newFullValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.label.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButtonWidget(
                        icon: Icons.remove,
                        iconColor: widget.iconColor,
                        buttonColor: widget.buttonColor,
                        elevation: widget.elevation,
                        onTap: () {
                          dynamic currentValue = 0;

                          if (widget.acceptsNegatives ||
                              ((widget.value - widget.step) > 0 &&
                                  widget.type == QuantityInputType.double) ||
                              ((widget.value - widget.step) >= 1 &&
                                  widget.type == QuantityInputType.int) ||
                              (widget.acceptsZero &&
                                  (widget.value - widget.step) == 0)) {
                            currentValue = widget.value - widget.step;
                          } else {
                            currentValue = widget.value;
                          }

                          String formattedValue = valueFormatter(currentValue);
                          _controller.value = TextEditingValue(
                              text: formattedValue,
                              selection: TextSelection.collapsed(
                                  offset: formattedValue.length));
                          widget.onChanged(formattedValue);
                        }),
                    SizedBox(
                        height: 38,
                        width: widget.inputWidth,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: TextFormField(
                                style: const TextStyle(color: Colors.black45),
                                controller: _controller,
                                textAlign: TextAlign.center,
                                decoration: widget.decoration,
                                readOnly: widget.readOnly,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    String simpleValue = '';
                                    String formattedValue = '';
                                    if (newValue.text
                                        .contains(RegExp(r'[a-zA-Z]'))) {
                                      return oldValue;
                                    }

                                    if (widget.type ==
                                        QuantityInputType.double) {
                                      simpleValue = newValue.text
                                          .replaceAll(',', '')
                                          .replaceAll('.', '');

                                      if (simpleValue.length == 1) {
                                        simpleValue =
                                            simpleValue.padLeft(1, '0');
                                      }

                                      formattedValue = valueFormatter(
                                          double.parse(
                                              parseNewDouble(simpleValue)));
                                    } else {
                                      if (newValue.text.isEmpty) {
                                        formattedValue = '0';
                                      } else {
                                        simpleValue =
                                            newValue.text.replaceAll(',', '');

                                        formattedValue = valueFormatter(
                                            int.parse(simpleValue));
                                      }
                                    }

                                    return TextEditingValue(
                                        text: formattedValue,
                                        selection: TextSelection.collapsed(
                                            offset: formattedValue.length));
                                  })
                                ],
                                onChanged: (value) =>
                                    widget.onChanged(value)))),
                    IconButtonWidget(
                        icon: Icons.add,
                        iconColor: widget.iconColor,
                        buttonColor: widget.buttonColor,
                        elevation: widget.elevation,
                        onTap: () {
                          dynamic currentValue = 0;

                          if (widget.maxValue >= widget.value &&
                              widget.maxValue >= widget.value + widget.step) {
                            currentValue = widget.value + widget.step;
                          } else {
                            currentValue = widget.value;
                          }

                          String formattedValue = valueFormatter(currentValue);
                          _controller.value = TextEditingValue(
                              text: formattedValue,
                              selection: TextSelection.collapsed(
                                  offset: formattedValue.length));
                          widget.onChanged(formattedValue);
                        })
                  ])
            ]));
  }
}
