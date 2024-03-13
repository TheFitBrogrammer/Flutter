import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/data/models/item.dart';

// ignore: camel_case_types
class kItemListTile extends StatelessWidget {
  final Item item;
  final ItemCubit itemCubit;

  const kItemListTile({
    super.key,
    required this.item,
    required this.itemCubit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: item.isDone,
        onChanged: (bool? value) async {
          final updatedItem = item.copyWith(isDone: value!);
          bool success = await itemCubit.updateItem(updatedItem);
          if (success) {
            log("Item with ID#: ${item.id} updated.");
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
          decoration: item.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: ReorderableDragStartListener(
        index: item.indexId,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}
