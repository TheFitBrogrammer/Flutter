import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:simply_todo/controller/cubits/item_cubit.dart';
import 'package:simply_todo/model/object_models/item.dart';
import 'package:simply_todo/util/values/enums.dart';
import 'package:simply_todo/util/values/strings.dart';
import 'package:simply_todo/view/widgets/buttons/submit_button.dart';

void showEditItemForm(BuildContext homeContext, ItemCubit itemCubit,
    TextEditingController textController, Item item, bool darkMode) {
  ItemCategory selectedCategory = item.category;
  DateTime? pickedDate =
      item.date != 0 ? DateTime.fromMillisecondsSinceEpoch(item.date) : null;
  textController.text = item.title;

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
                          labelText: kString_FormItemTitle,
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
                              const Text(kString_FormItemTag),
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
                            child: const Text(kString_FormAddToCalendar),
                          ),
                        ],
                      ),
                      if (pickedDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '$kString_FormSelectedDate ${pickedDate!.month.toString().padLeft(2, '0')}/'
                            '${pickedDate!.day.toString().padLeft(2, '0')}/'
                            '${pickedDate!.year}',
                          ),
                        ),
                      const Spacer(),
                      kButton_Submit(
                        buttonTitle: kString_ButtonUpdateItem,
                        textController: textController,
                        itemCubit: itemCubit,
                        selectedCategory: selectedCategory,
                        onPressed: () async {
                          if (textController.text.trim().isNotEmpty) {
                            final navigator = Navigator.of(context);
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            final updatedItem = item.copyWith(
                              title: textController.text,
                              date: pickedDate?.millisecondsSinceEpoch ?? 0,
                              category: selectedCategory,
                            );
                            bool success =
                                await itemCubit.updateItem(updatedItem);
                            if (success) {
                              scaffoldMessenger.showSnackBar(const SnackBar(
                                content: Text(kString_ToastItemUpdated),
                                duration: Duration(milliseconds: 2000),
                              ));
                              navigator.pop();
                            } else {
                              log("Error occurred while updating item");
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
