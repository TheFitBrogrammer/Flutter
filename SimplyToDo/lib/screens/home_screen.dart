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
  // ignore: prefer_final_fields
  ItemCategory _selectedCategory = ItemCategory.All;

  @override
  Widget build(BuildContext context) {
    final itemCubit = context.read<ItemCubit>();
    Color appBarAndBottomNavColor = const Color(0xFF1c1c5e);
    Color floatingActionButtonColor = const Color(0xFFff6a06);
    Color textColor = Colors.white;
    Color iconAndTextColor = Colors.white; // White color for text and icons

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarAndBottomNavColor,
        title: Text(
          widget.title,
          style:
              TextStyle(color: textColor), // Apply white color to AppBar title
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu,
                color: textColor), // Apply white color to menu icon
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
                  title: Text(item.title, style: TextStyle(color: textColor)),
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
        backgroundColor: appBarAndBottomNavColor, // Match AppBar color
        selectedItemColor: iconAndTextColor, // White color for selected item
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
      // Update your category view based on the index, if necessary
    });
  }

  void _showAddItemForm(BuildContext context, ItemCubit itemCubit) {
    final TextEditingController titleController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // Return your form here
          return Container(
            padding: const EdgeInsets.all(20),
            height: 400, // Adjust the height as needed
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Item Title'),
                  controller: titleController,
                ),
                // Add more fields for item details like category selection
                ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final newItem = Item(
                        indexId: itemCubit.state.itemsList.length,
                        title: titleController.text.toString(),
                        date: DateTime.now().millisecondsSinceEpoch,
                        category: ItemCategory.Misc);
                    bool success = await itemCubit.addItem(newItem.toMap());
                    // titleController.dispose();
                    if (success) {
                      scaffoldMessenger.showSnackBar(const SnackBar(
                        content: Text("New item added"),
                        duration: Duration(milliseconds: 2000),
                      ));
                      itemCubit.fetchItemData();
                      navigator.pop();
                    } else {
                      log("ASYNC Error occurred");
                    }
                  },
                  child: const Text('Add Item'),
                ),
              ],
            ),
          );
        });
  }
}
