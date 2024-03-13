import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/data/database/database_helper.dart';
import 'package:simply_todo/screens/home_screen.dart';
import 'package:simply_todo/util/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  await DatabaseHelper.instance.database;

  runApp(
    BlocProvider(
      create: (context) => ItemCubit(
        dbHelper: DatabaseHelper.instance,
      ),
      child: SimplyTodo(
        appRouter: AppRouter(),
      ),
    ),
  );
}

class SimplyTodo extends StatelessWidget {
  final AppRouter appRouter;

  const SimplyTodo({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFff6a06),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1c1c5e),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF1c1c5e),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
        ),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
                iconColor: MaterialStateProperty.all<Color>(Colors.white))),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFFff6a06)),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(
                  0xFFff6a06); // Color when the checkbox is selected/checked
            }
            return Colors.white;
          }),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
