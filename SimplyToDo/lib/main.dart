import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/data/bloc/cubits/settings_cubit.dart';
import 'package:simply_todo/data/bloc/cubits/settings_cubit_state.dart';
import 'package:simply_todo/data/database/database_helper.dart';
import 'package:simply_todo/screens/home_screen.dart';
import 'package:simply_todo/util/router/app_router.dart';
// import 'package:simply_todo/util/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the database
  await DatabaseHelper.instance.database;
  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();
  bool darkMode = prefs.getBool('dark_mode') ?? false;
  int allItemsFilter = prefs.getInt('all_items_filter') ?? 15;
  int defaultCategory = prefs.getInt('default_category') ?? 3;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsCubit(
            SettingsState(
              darkMode: darkMode,
              allItemsFilter: allItemsFilter,
              defaultCategory: defaultCategory,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ItemCubit(
            dbHelper: DatabaseHelper.instance,
          ),
        ),
      ],
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
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        bool darkModeOn = settingsState.darkMode;
        SettingsCubit settingsCubit = context.read<SettingsCubit>();
        return MaterialApp(
          onGenerateRoute: appRouter.onGenerateRoute,
          theme: ThemeData(
            listTileTheme: ListTileThemeData(
              titleTextStyle:
                  TextStyle(color: darkModeOn ? Colors.grey : Colors.black),
            ),
            scaffoldBackgroundColor:
                darkModeOn ? const Color(0xFF1F1D1D) : Colors.white,
            dropdownMenuTheme: DropdownMenuThemeData(
              menuStyle: MenuStyle(
                backgroundColor: darkModeOn
                    ? MaterialStateProperty.all<Color>(const Color(0xFF1F1D1D))
                    : MaterialStateProperty.all<Color>(Colors.white),
              ),
              textStyle:
                  TextStyle(color: darkModeOn ? Colors.grey : Colors.black),
              inputDecorationTheme: InputDecorationTheme(
                  fillColor:
                      darkModeOn ? const Color(0xFF191818) : Colors.white,
                  labelStyle: TextStyle(
                      color: darkModeOn ? Colors.grey : Colors.black)),
            ),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor:
                  darkModeOn ? const Color(0xFF1F1D1D) : Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: darkModeOn
                  ? const Color(0xFFCC5201)
                  : const Color(0xFFff6a06),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF1c1c5e),
              titleTextStyle: TextStyle(
                color: darkModeOn ? Colors.grey : Colors.white,
              ),
              iconTheme: IconThemeData(
                color: darkModeOn ? Colors.grey : Colors.white,
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: const Color(0xFF1c1c5e),
              selectedItemColor: darkModeOn ? Colors.grey : Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.6),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: darkModeOn
                    ? MaterialStateProperty.all<Color>(const Color(0xFFCC5201))
                    : MaterialStateProperty.all<Color>(const Color(0xFFff6a06)),
                foregroundColor: MaterialStateProperty.all<Color>(
                  darkModeOn ? Colors.grey : Colors.white,
                ),
              ),
            ),
            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return darkModeOn
                        ? const Color(0xFFCC5201)
                        : const Color(0xFFff6a06);
                  }
                  return darkModeOn ? Colors.grey : Colors.white;
                },
              ),
              checkColor: darkModeOn
                  ? MaterialStateProperty.all<Color>(const Color(0xFF9E9E9E))
                  : MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
              side: BorderSide(
                color: darkModeOn ? Colors.grey : Colors.black,
              ),
            ),
            textTheme: TextTheme(
              bodyLarge:
                  TextStyle(color: darkModeOn ? Colors.grey : Colors.black),
              bodyMedium:
                  TextStyle(color: darkModeOn ? Colors.grey : Colors.black),
              bodySmall:
                  TextStyle(color: darkModeOn ? Colors.grey : Colors.black),
            ),
            iconTheme: IconThemeData(
              color: darkModeOn ? Colors.grey : Colors.white,
            ),
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF1c1c5e)),
            useMaterial3: true,
          ),
          home: HomeScreen(
            settingsCubit: settingsCubit,
          ),
        );
      },
    );
  }
}
