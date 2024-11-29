import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class WidgetButton extends StatelessWidget {
  const WidgetButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type,
    this.shape,
    this.color,
    this.textStyle,
  }) : super(key: key);

  final String text;
  final Function() onPressed;
  final GFButtonType? type;
  final GFButtonShape? shape;
  final Color? color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GFButton(
      shape: shape ?? GFButtonShape.standard,
      type: type ?? GFButtonType.solid,
      text: text,
      onPressed: onPressed,
      color: color ?? Theme.of(context).primaryColor,
      textStyle: textStyle,
    );
  }
}
