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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'Simply ToDo'),
    );
  }
}
