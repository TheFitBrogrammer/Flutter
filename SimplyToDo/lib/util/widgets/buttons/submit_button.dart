import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/data/models/item.dart';
import 'package:simply_todo/util/values/enums.dart';

// ignore: camel_case_types
class kSubmitButton extends StatelessWidget {
  final String buttonTitle;
  final TextEditingController textController;
  final ItemCubit itemCubit;
  final ItemCategory selectedCategory;

  const kSubmitButton({
    super.key,
    required this.buttonTitle,
    required this.textController,
    required this.itemCubit,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (textController.text.trim().isNotEmpty) {
          final navigator = Navigator.of(context);
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final newItem = Item(
            indexId: itemCubit.state.itemsList.length,
            title: textController.text,
            // date: DateTime.now().millisecondsSinceEpoch,
            category: selectedCategory,
          );
          bool success = await itemCubit.addItem(newItem.toMap());
          if (success) {
            scaffoldMessenger.showSnackBar(SnackBar(
              content: Text("New item added to ${selectedCategory.name}."),
              duration: const Duration(milliseconds: 2000),
            ));
            navigator.pop();
          } else {
            log("Error occurred while adding item");
          }
        }
      },
      child: Text(buttonTitle, style: const TextStyle(color: Colors.white)),
    );
  }
}
