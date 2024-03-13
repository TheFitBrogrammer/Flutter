import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit_state.dart';
import 'package:simply_todo/util/functions/add_item_form.dart';
import 'package:simply_todo/util/values/enums.dart';
import 'package:simply_todo/util/widgets/app_bars/app_bar.dart';
import 'package:simply_todo/util/widgets/app_bars/bottom_bar.dart';
import 'package:simply_todo/util/widgets/buttons/floating_button.dart';
import 'package:simply_todo/util/widgets/list_tiles/item_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController titleController = TextEditingController();
  // ignore: prefer_final_fields
  ItemCategory _selectedCategory = ItemCategory.All;

  @override
  void initState() {
    super.initState();
    context.read<ItemCubit>().fetchItemData();
    WidgetsFlutterBinding.ensureInitialized();
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
        title: 'Simply ToDo',
        hasAction: true,
        icon: Icons.calendar_today,
        onActionTapped: () {
          log("Icon tapped");
        },
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF191818),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF191818),
                ),
                child: Text('Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                title: const Text('Settings',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                onTap: () {
                  // Navigate to the Settings screen
                  log("Settings menu option selected.");
                },
              ),
              const Divider(color: Colors.grey),
              ListTile(
                title: const Text('Legal',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                onTap: () {
                  // Navigate to the Legal screen
                  log("Legal menu option selected.");
                },
              ),
              const Divider(color: Colors.grey),
              ListTile(
                title: const Text('Contact/Support',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                onTap: () {
                  // Navigate to the Contact screen
                  log("Contact/Support menu option selected.");
                },
              ),
              const Divider(color: Colors.grey),
            ],
          ),
        ),
      ),
      body: BlocBuilder<ItemCubit, ItemState>(
        builder: (context, state) {
          if (state.itemsList.isEmpty) {
            return const Center(
                child: Text('No items to display',
                    style: TextStyle(color: Colors.black)));
          } else {
            var items = state.itemsList.where((item) {
              if (_selectedCategory == ItemCategory.All) return true;
              return item.category == _selectedCategory;
            }).toList();

            return Column(
              children: [
                Expanded(
                  child: ReorderableListView.builder(
                    itemCount: items.length,
                    onReorder: (oldIndex, newIndex) {
                      itemCubit.reorderItem(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Slidable(
                        key: Key(item.id.toString()),
                        startActionPane: ActionPane(
                          motion: const BehindMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                final scaffoldMessenger =
                                    ScaffoldMessenger.of(context);
                                bool success =
                                    await itemCubit.deleteItem(item.id!);
                                if (success) {
                                  scaffoldMessenger.showSnackBar(const SnackBar(
                                    content: Text("Item deleted."),
                                    duration: Duration(milliseconds: 2000),
                                  ));
                                  log("Item with ID#: ${item.id} successfully deleted.");
                                } else {
                                  log("ASYNC Error occurred");
                                }
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                log("Edit icon button tapped for item id# ${item.id}.");
                              },
                              backgroundColor: Colors.cyan,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: kItemListTile(item: item, itemCubit: itemCubit),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: kFloatingActionButton(
        onPressed: () {
          showAddItemForm(context, itemCubit, titleController);
        },
        tooltip: 'Add Item',
        buttonIcon: Icons.add,
      ),
      bottomNavigationBar: kBottomNavBar(
          currentIndex: _selectedIndex, onCategoryTapped: _onCategoryTapped),
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
