import 'package:flutter/material.dart';

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
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All Items'),
        BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Urgent'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Important'),
        BottomNavigationBarItem(icon: Icon(Icons.label), label: 'Misc'),
        BottomNavigationBarItem(icon: Icon(Icons.label), label: 'Shopping'),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
