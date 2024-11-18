import 'package:flutter/material.dart';

import '../constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.press,
    this.color = primaryColor,
    this.padding = const EdgeInsets.all(defaultPadding * 0.75),
  });

  final String text;
  final VoidCallback press;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 65,
      shape: const RoundedRectangleBorder(
        // borderRadius: BorderRadius.all(Radius.circular(40)),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: padding,
      color: color,
      minWidth: double.infinity,
      onPressed: press,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
