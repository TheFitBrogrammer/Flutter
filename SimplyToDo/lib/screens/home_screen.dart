import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final itemCubit = context.read<ItemCubit>();
    Color appBarAndBottomNavColor = const Color(0xFF1c1c5e);
    Color floatingActionButtonColor = const Color(0xFFff6a06);
    Color textColor = Colors.white;
    Color iconAndTextColor = Colors.white;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarAndBottomNavColor,
        title: Text(
          widget.title,
          style: TextStyle(color: textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: textColor),
            onPressed: () {
              // Implement menu action
            },
          ),
        ],
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

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.title,
                      style: const TextStyle(color: Colors.black)),
                  // Further implementation details such as leading, trailing, onTap
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: floatingActionButtonColor,
        onPressed: () => _showAddItemForm(context, itemCubit),
        tooltip: 'Add Item',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: appBarAndBottomNavColor,
        selectedItemColor: iconAndTextColor,
        unselectedItemColor: iconAndTextColor.withOpacity(
            0.6), // Slightly faded white color for unselected items
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

  void _onItemTapped(int index) {
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
                            date: DateTime.now().millisecondsSinceEpoch,
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
                            itemCubit.fetchItemData();
                            navigator.pop();
                          } else {
                            log("Error occurred while adding item");
                          }
                        }
                      },
                      child: const Text('Add Item'),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
