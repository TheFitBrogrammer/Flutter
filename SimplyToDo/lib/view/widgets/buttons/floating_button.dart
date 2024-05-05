import 'package:flutter/material.dart';

// ignore: camel_case_types
class kFloatingActionButton extends StatelessWidget {
  final void Function() onPressed;
  final String tooltip;
  final IconData buttonIcon;

  const kFloatingActionButton({
    required this.onPressed,
    required this.tooltip,
    required this.buttonIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(
        buttonIcon,
        color: Colors.white,
      ),
    );
  }
}
