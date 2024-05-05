// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit_state.dart';
import 'package:simply_todo/data/bloc/cubits/settings_cubit.dart';
import 'package:simply_todo/util/forms/add_item_form.dart';
import 'package:simply_todo/util/forms/edit_item_form.dart';
import 'package:simply_todo/util/values/enums.dart';
import 'package:simply_todo/util/widgets/app_bars/app_bar.dart';
import 'package:simply_todo/util/widgets/app_bars/bottom_bar.dart';
import 'package:simply_todo/util/widgets/buttons/floating_button.dart';
import 'package:simply_todo/util/widgets/item_list/item_list_builder.dart';
import 'package:simply_todo/util/widgets/menu/menu_drawer.dart';

class HomeScreen extends StatefulWidget {
  final SettingsCubit settingsCubit;
  const HomeScreen({required this.settingsCubit, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController titleController = TextEditingController();
  ItemCategory _selectedCategory = ItemCategory.All;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    context.read<ItemCubit>().fetchItemData();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCubit = context.read<ItemCubit>();
    return Scaffold(
      appBar: kAppBar(
        title: "Simply ToDo",
        hasAction: true,
        icon: Icons.calendar_month,
        onActionTapped: () {
          Navigator.pushNamed(context, '/calendar_screen',
              arguments: widget.settingsCubit);
        },
      ),
      drawer: const kDrawer_Menu(),
      body: BlocBuilder<ItemCubit, ItemState>(
        builder: (context, state) {
          if (state.itemsList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Tap the '+' to add an item."),
                  SizedBox(height: 25),
                  Text("Tap the calendar icon in the upper right corner"),
                  Text("to view your calendar."),
                ],
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: buildItemList(
                      context,
                      itemCubit.state,
                      widget.settingsCubit.state,
                      _selectedCategory,
                      itemCubit.reorderItem,
                      (context, itemCubit, titleController, item) =>
                          showEditItemForm(
                            context,
                            itemCubit,
                            titleController,
                            item,
                            widget.settingsCubit.state.darkMode,
                          ),
                      titleController,
                      []),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: kFloatingActionButton(
        onPressed: () {
          showAddItemForm(
              context,
              itemCubit,
              titleController,
              widget.settingsCubit.state.defaultCategory,
              widget.settingsCubit.state.darkMode);
        },
        tooltip: 'Add Item',
        buttonIcon: Icons.add,
      ),
      bottomNavigationBar: kBottomNavBar(
        currentIndex: _selectedIndex,
        onCategoryTapped: _onCategoryTapped,
      ),
    );
  }

  void _onCategoryTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _selectedCategory = ItemCategory.All;
          break;
        case 1:
          _selectedCategory = ItemCategory.Urgent;
          break;
        case 2:
          _selectedCategory = ItemCategory.Important;
          break;
        case 3:
          _selectedCategory = ItemCategory.Misc;
          break;
        case 4:
          _selectedCategory = ItemCategory.Shopping;
          break;
        default:
          _selectedCategory = ItemCategory.All;
      }
    });
  }
}
