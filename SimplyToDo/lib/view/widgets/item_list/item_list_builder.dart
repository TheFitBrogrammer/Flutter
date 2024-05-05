import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit_state.dart';
import 'package:simply_todo/data/bloc/cubits/settings_cubit_state.dart';
import 'package:simply_todo/data/models/item.dart';
import 'package:simply_todo/util/values/enums.dart';
import 'package:simply_todo/util/widgets/item_list/item_list_tile.dart';

Widget buildItemList(
  BuildContext context,
  ItemState itemState,
  SettingsState settingsState,
  ItemCategory selectedCategory,
  Function(int, int) onReorder,
  Function(BuildContext, ItemCubit, TextEditingController, Item) onEdit,
  TextEditingController titleController,
  List<Item> givenList,
) {
  return ReorderableListView.builder(
    itemCount: selectedCategory != ItemCategory.Calendar
        ? itemState.itemsList.length
        : givenList.length,
    onReorder: onReorder,
    itemBuilder: (context, index) {
      final item = selectedCategory != ItemCategory.Calendar
          ? itemState.itemsList[index]
          : givenList[index];
      final itemCubit = context.read<ItemCubit>();

      if (selectedCategory == ItemCategory.All) {
        switch (settingsState.allItemsFilter) {
          case 0:
          case 15:
            if (item.category == ItemCategory.Urgent ||
                item.category == ItemCategory.Important ||
                item.category == ItemCategory.Misc ||
                item.category == ItemCategory.Shopping) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 14:
            if (item.category == ItemCategory.Urgent ||
                item.category == ItemCategory.Important ||
                item.category == ItemCategory.Misc) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 13:
            if (item.category == ItemCategory.Urgent ||
                item.category == ItemCategory.Important ||
                item.category == ItemCategory.Shopping) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 12:
            if (item.category == ItemCategory.Urgent ||
                item.category == ItemCategory.Important) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 11:
            if (item.category == ItemCategory.Urgent ||
                item.category == ItemCategory.Misc ||
                item.category == ItemCategory.Shopping) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 10:
            if (item.category == ItemCategory.Urgent ||
                item.category == ItemCategory.Misc) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 9:
            if (item.category == ItemCategory.Shopping ||
                item.category == ItemCategory.Urgent) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 8:
            if (item.category == ItemCategory.Urgent) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 7:
            if (item.category == ItemCategory.Important ||
                item.category == ItemCategory.Misc ||
                item.category == ItemCategory.Shopping) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 6:
            if (item.category == ItemCategory.Important ||
                item.category == ItemCategory.Misc) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 5:
            if (item.category == ItemCategory.Shopping ||
                item.category == ItemCategory.Important) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 4:
            if (item.category == ItemCategory.Important) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 3:
            if (item.category == ItemCategory.Misc ||
                item.category == ItemCategory.Shopping) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 2:
            if (item.category == ItemCategory.Misc) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          case 1:
            if (item.category == ItemCategory.Shopping) {
              log("Filter Value: ${settingsState.allItemsFilter}");
              return buildSlidableItem(
                  context, item, itemCubit, onEdit, titleController);
            }
            break;
          default:
            return Container();
        }
      } else if (item.category == selectedCategory) {
        return buildSlidableItem(
            context, item, itemCubit, onEdit, titleController);
      } else if (selectedCategory == ItemCategory.Calendar) {
        return buildSlidableItem(
            context, item, itemCubit, onEdit, titleController,
            hasDragHandle: false);
      }

      return Container(key: Key(item.id.toString()));
    },
  );
}
