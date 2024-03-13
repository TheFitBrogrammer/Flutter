import 'package:flutter/material.dart';

// ignore: camel_case_types
class kAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasAction;
  final void Function()? onActionTapped;
  final IconData? icon;

  const kAppBar({
    required this.title,
    required this.hasAction,
    this.onActionTapped,
    this.icon,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'DancingScript',
          fontWeight: FontWeight.bold,
          fontSize: 40,
          color: Colors.white,
        ),
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: hasAction
          ? [
              IconButton(
                icon: Icon(icon),
                onPressed: onActionTapped,
              ),
            ]
          : null,
    );
  }
}
