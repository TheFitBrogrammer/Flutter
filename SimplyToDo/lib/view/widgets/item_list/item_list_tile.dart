import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simply_todo/controller/cubits/item_cubit.dart';
import 'package:simply_todo/model/object_models/item.dart';
import 'package:simply_todo/util/values/enums.dart';
import 'package:simply_todo/util/values/strings.dart';

// ignore: camel_case_types
class kItemListTile extends StatelessWidget {
  final Item item;
  final ItemCubit itemCubit;
  final bool showDragHandle;

  const kItemListTile({
    super.key,
    required this.item,
    required this.itemCubit,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: item.isDone,
        onChanged: (bool? value) async {
          log("Item indexID = ${item.indexId}");
          final updatedItem = item.copyWith(isDone: value!);
          bool success = await itemCubit.updateItem(updatedItem);
          if (success) {
            log("Item with ID#: ${item.id} updated.");
          } else {
            log("ASYNC Error occurred");
          }
        },
      ),
      title: item.category == ItemCategory.Urgent
          ? Row(children: [
              Icon(Icons.priority_high_rounded, color: Colors.red),
              Flexible(
                child: Text(item.title,
                    style: TextStyle(
                        fontSize: 16,
                        decoration:
                            item.isDone ? TextDecoration.lineThrough : null)),
              )
            ])
          : Text(
              item.title,
              style: TextStyle(
                fontSize: 16,
                decoration: item.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
      trailing: showDragHandle
          ? ReorderableDragStartListener(
              index: item.indexId,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Icon(Icons.drag_handle),
              ),
            )
          : null,
    );
  }
}

//makes the list tile a slidable
Widget buildSlidableItem(
    BuildContext context,
    Item item,
    ItemCubit itemCubit,
    Function(BuildContext, ItemCubit, TextEditingController, Item) onEdit,
    TextEditingController titleController,
    {bool hasDragHandle = true}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  return Slidable(
    key: Key(item.id.toString()),
    startActionPane: ActionPane(
      motion: const BehindMotion(),
      extentRatio: 0.25,
      children: [
        SlidableAction(
          onPressed: (context) async {
            bool success = await itemCubit.deleteItem(item.id!);
            if (success) {
            } else {
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text(kString_ToastErrorDelete),
                  duration: Duration(seconds: 2),
                ),
              );
              log("DELETION FAILURE: ASYNC Error occurred");
            }
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: kString_LabelDelete,
        ),
      ],
    ),
    endActionPane: ActionPane(
      motion: const BehindMotion(),
      extentRatio: 0.25,
      children: [
        SlidableAction(
          onPressed: (context) {
            onEdit(context, itemCubit, titleController, item);
          },
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: kString_LabelEdit,
        ),
      ],
    ),
    child: kItemListTile(
      item: item,
      itemCubit: itemCubit,
      showDragHandle: hasDragHandle,
    ),
  );
}
