import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_todo/controller/cubits/settings_cubit_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(SettingsState settingsState) : super(SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkMode = prefs.getBool('dark_mode') ?? false;
    int allItemsFilter = prefs.getInt('all_items_filter') ?? 15;
    int defaultCategory = prefs.getInt('default_category') ?? 3;

    emit(SettingsState(
      darkMode: darkMode,
      allItemsFilter: allItemsFilter,
      defaultCategory: defaultCategory,
    ));
  }

  Future<void> setDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    emit(state.copyWith(darkMode: value));
  }

  Future<void> setAllItemsFilter(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('all_items_filter', value);
    emit(state.copyWith(allItemsFilter: value));
  }

  Future<void> setDefaultCategory(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('default_category', value);
    emit(state.copyWith(defaultCategory: value));
  }
}
