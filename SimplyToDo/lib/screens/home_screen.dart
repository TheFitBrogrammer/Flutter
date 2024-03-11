import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit_state.dart';
import 'package:simply_todo/data/models/item.dart';
import 'package:simply_todo/util/values/enums.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

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
    const appBarTitleStyle = TextStyle(
      fontFamily: 'DancingScript',
      fontWeight: FontWeight.bold,
      fontSize: 40,
      color: Colors.white,
    );
    final itemCubit = context.read<ItemCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: appBarTitleStyle),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.calendar_today,
              // color: iconAndTextColor,
            ),
            onPressed: () {
              // Implement calendar action
              log("Calendar button tapped.");
            },
          ),
        ],
      ),
      // Drawer on the left side of the screen
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
                                  // await itemCubit.fetchItemData();
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
                        child: ListTile(
                          leading: Checkbox(
                            value: item.isDone,
                            onChanged: (bool? value) async {
                              final updatedItem = item.copyWith(isDone: value!);
                              bool success =
                                  await itemCubit.updateItem(updatedItem);
                              if (success) {
                                log("Item with ID#: ${item.id} updated.");
                                // await itemCubit.fetchItemData();
                              } else {
                                log("ASYNC Error occurred");
                              }
                            },
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              decoration: item.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: ReorderableDragStartListener(
                            index: index,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child:
                                  Icon(Icons.drag_handle), // Drag handle icon
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemForm(context, itemCubit),
        tooltip: 'Add Item',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onCategoryTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All Items'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Urgent'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Important'),
          BottomNavigationBarItem(icon: Icon(Icons.label), label: 'Misc'),
          BottomNavigationBarItem(icon: Icon(Icons.label), label: 'Shopping'),
        ],
        type: BottomNavigationBarType.fixed,
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

  void _showAddItemForm(BuildContext context, ItemCubit itemCubit) {
    ItemCategory selectedCategory = ItemCategory.Misc;
    titleController.clear();

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              // Removes ALL category from category menu.
              final categories = ItemCategory.values
                  .where((c) => c != ItemCategory.All)
                  .toList();
              return Container(
                padding: const EdgeInsets.all(20),
                height: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Item Title'),
                      controller: titleController,
                    ),
                    DropdownButton<ItemCategory>(
                      value: selectedCategory,
                      onChanged: (ItemCategory? newValue) {
                        setState(() {
                          if (newValue != null) {
                            selectedCategory = newValue;
                          }
                        });
                      },
                      items: categories.map((ItemCategory category) {
                        return DropdownMenuItem<ItemCategory>(
                          value: category,
                          child: Text(category.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.trim().isNotEmpty) {
                          final navigator = Navigator.of(context);
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          final newItem = Item(
                            indexId: itemCubit.state.itemsList.length,
                            title: titleController.text,
                            // date: DateTime.now().millisecondsSinceEpoch,
                            category: selectedCategory,
                          );
                          bool success =
                              await itemCubit.addItem(newItem.toMap());
                          if (success) {
                            scaffoldMessenger.showSnackBar(SnackBar(
                              content: Text(
                                  "New item added to ${selectedCategory.name}."),
                              duration: const Duration(milliseconds: 2000),
                            ));
                            // itemCubit.fetchItemData();
                            navigator.pop();
                          } else {
                            log("Error occurred while adding item");
                          }
                        }
                      },
                      child: const Text('Add Item',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
