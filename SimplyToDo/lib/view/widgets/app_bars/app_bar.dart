import 'package:flutter/material.dart';

// ignore: camel_case_types
class kAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasAction;
  final String title;
  final void Function()? onActionTapped;
  final IconData? icon;
  final bool hasLeading;

  const kAppBar({
    required this.hasAction,
    required this.title,
    this.hasLeading = true,
    this.onActionTapped,
    this.icon,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'DancingScript',
          fontWeight: FontWeight.bold,
          fontSize: 40,
          color: Colors.white,
        ),
      ),
      leading: hasLeading
          ? Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            )
          : const BackButton(
              color: Colors.white,
            ),
      actions: hasAction
          ? [
              IconButton(
                icon: Icon(
                  icon,
                  color: Colors.white,
                ),
                onPressed: onActionTapped,
              ),
            ]
          : null,
    );
  }
}
