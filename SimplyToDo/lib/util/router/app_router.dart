import 'package:flutter/material.dart';
import 'package:simply_todo/screens/home_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings rs) {
    switch (rs.name) {
      case '/':
        // final title = rs.arguments as String;
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return null;
    }
  }
}
