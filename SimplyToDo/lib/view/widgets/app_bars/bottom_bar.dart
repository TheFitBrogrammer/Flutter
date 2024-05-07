import 'package:flutter/material.dart';
import 'package:simply_todo/util/values/strings.dart';

// ignore: camel_case_types
class kBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onCategoryTapped;

  const kBottomNavBar(
      {required this.currentIndex, required this.onCategoryTapped, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onCategoryTapped,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.list), label: kString_TagAllItems),
        BottomNavigationBarItem(
            icon: Icon(Icons.warning), label: kString_TagUrgent),
        BottomNavigationBarItem(
            icon: Icon(Icons.star), label: kString_TagImportant),
        BottomNavigationBarItem(
            icon: Icon(Icons.label), label: kString_TagMisc),
        BottomNavigationBarItem(
            icon: Icon(Icons.label), label: kString_TagShopping),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
