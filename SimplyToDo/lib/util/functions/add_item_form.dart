import 'package:flutter/material.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/util/values/enums.dart';
import 'package:simply_todo/util/widgets/buttons/submit_button.dart';

void showAddItemForm(BuildContext homeContext, ItemCubit itemCubit,
    TextEditingController textController) {
  ItemCategory selectedCategory = ItemCategory.Misc;
  textController.clear();

  showModalBottomSheet(
      context: homeContext,
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
                    decoration: const InputDecoration(labelText: 'Item Title'),
                    controller: textController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Tag as:"),
                      const SizedBox(width: 15),
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
                    ],
                  ),
                  const Spacer(),
                  kSubmitButton(
                      buttonTitle: "Add Item",
                      textController: textController,
                      itemCubit: itemCubit,
                      selectedCategory: selectedCategory),
                  const SizedBox(height: 25),
                ],
              ),
            );
          },
        );
      });
}
