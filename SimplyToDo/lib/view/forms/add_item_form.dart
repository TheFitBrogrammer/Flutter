import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/data/models/item.dart';
import 'package:simply_todo/util/values/enums.dart';
import 'package:simply_todo/util/widgets/buttons/submit_button.dart';

void showAddItemForm(BuildContext homeContext, ItemCubit itemCubit,
    TextEditingController textController, int defaultCategory, bool darkMode) {
  ItemCategory selectedCategory;
  switch (defaultCategory) {
    case 0:
      selectedCategory = ItemCategory.Urgent;
      break;
    case 1:
      selectedCategory = ItemCategory.Important;
      break;
    case 2:
      selectedCategory = ItemCategory.Misc;
      break;
    case 3:
      selectedCategory = ItemCategory.Shopping;
      break;
    default:
      selectedCategory = ItemCategory.Shopping;
      break;
  }
  DateTime? pickedDate;
  textController.clear();

  showModalBottomSheet(
      context: homeContext,
      isScrollControlled: Platform.isAndroid ? false : true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                // Removes ALL and Calendar categories from category menu.
                final categories = ItemCategory.values
                    .where((c) =>
                        c != ItemCategory.All && c != ItemCategory.Calendar)
                    .toList();
                return Container(
                  padding: const EdgeInsets.all(20),
                  height: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          counterText: "",
                          fillColor:
                              darkMode ? const Color(0xFF1F1D1D) : Colors.white,
                          filled: true,
                          labelText: "Item Title",
                          hintText: "",
                          labelStyle: TextStyle(
                              color: darkMode ? Colors.grey : Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: darkMode
                                    ? const Color(0xFFCC5201)
                                    : const Color(0xFF1c1c5e),
                                width: 3.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: darkMode
                                    ? const Color(0xFFCC5201)
                                    : const Color(0xFF1c1c5e)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        controller: textController,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Tag as:"),
                              const SizedBox(width: 15),
                              DropdownButton<ItemCategory>(
                                style: Theme.of(context).textTheme.bodyLarge,
                                dropdownColor: Theme.of(context)
                                    .dropdownMenuTheme
                                    .inputDecorationTheme!
                                    .fillColor,
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
                                    child: Text(
                                        category.toString().split('.').last),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              pickedDate = await showDatePicker(
                                builder: (context, child) {
                                  return Theme(
                                      data: darkMode
                                          ? Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.dark(
                                              primary: Color(0xFF1c1c5e),
                                              onPrimary: Colors.black,
                                              onSurface: Colors.grey,
                                            ))
                                          : Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                              primary: Color(0xFF1c1c5e),
                                              onPrimary: Colors.white,
                                              onSurface: Colors.black,
                                            )),
                                      child: child!);
                                },
                                context: context,
                                initialDate: pickedDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              setState(() {
                                // leave this empty
                              });
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(150, 50)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF1c1c5e)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            child: const Text("Add to Calendar"),
                          ),
                        ],
                      ),
                      pickedDate == null
                          ? const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "",
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Selected Date: ${pickedDate!.month.toString().padLeft(2, '0')}/'
                                '${pickedDate!.day.toString().padLeft(2, '0')}/'
                                '${pickedDate!.year}',
                              ),
                            ),
                      const Spacer(),
                      kButton_Submit(
                        buttonTitle: "Add Item",
                        textController: textController,
                        itemCubit: itemCubit,
                        selectedCategory: selectedCategory,
                        onPressed: () async {
                          if (textController.text.trim().isNotEmpty) {
                            final navigator = Navigator.of(context);
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            final newItem = Item(
                              indexId: itemCubit.state.itemsList.length,
                              title: textController.text,
                              date: pickedDate?.millisecondsSinceEpoch ?? 0,
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
                              navigator.pop();
                            } else {
                              log("Error occurred while adding item");
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      });
}
