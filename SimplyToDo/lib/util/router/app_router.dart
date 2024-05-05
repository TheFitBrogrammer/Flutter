import 'package:flutter/material.dart';
import 'package:simply_todo/data/bloc/cubits/settings_cubit.dart';
import 'package:simply_todo/screens/calendar_screen.dart';
import 'package:simply_todo/screens/home_screen.dart';
import 'package:simply_todo/screens/legal_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings rs) {
    switch (rs.name) {
      case '/':
        final args = rs.arguments as SettingsCubit;
        return MaterialPageRoute(
            builder: (_) => HomeScreen(
                  settingsCubit: args,
                ));

      case '/calendar_screen':
        final args = rs.arguments as SettingsCubit;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              CalendarScreen(settingsCubit: args),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      case '/legal_screen':
        final args = rs.arguments as SettingsCubit;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LegalScreen(settingsCubit: args),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(-1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      default:
        return null;
    }
  }
}
