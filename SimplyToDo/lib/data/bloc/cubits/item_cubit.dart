import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit_state.dart';
import 'package:simply_todo/data/database/database_helper.dart';
import 'package:simply_todo/data/models/item.dart';
import 'package:simply_todo/util/values/enums.dart';

class ItemCubit extends Cubit<ItemState> {
  final DatabaseHelper dbHelper;

  ItemCubit({required this.dbHelper}) : super(ItemState([]));

  // Query all items in todo list from database into useable map.
  Future<void> fetchItemData() async {
    try {
      List<Map<String, dynamic>> itemListMaps = await dbHelper.queryItems();
      var itemList =
          itemListMaps.map((itemMap) => Item.fromMap(itemMap)).toList();
      itemList.sort((a, b) => a.indexId.compareTo(b.indexId));

      log("**************************************************************");
      log("'fetchItemData' successful with the following values:");
      log("Items List: ${itemList.length.toString()}");
      log("**************************************************************");

      emit(ItemState(itemList));
    } catch (e) {
      log('ERROR: Failed to fetch item data: $e');
    }
  }

  Future<bool> addItem(Map<String, dynamic> item) async {
    try {
      int id = await dbHelper.insertItem(item);
      if (id != 0) {
        // checking if the ID returned is valid
        item['id'] = id;
        final newItem = Item.fromMap(item);
        emit(state.copyWith(
            itemsList: List<Item>.from(state.itemsList)..add(newItem)));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Failed to add a new item: $e');
      return true;
    }
  }

  Future<bool> updateItem(Item updatedItem) async {
    try {
      await dbHelper.updateItem(updatedItem.toMap());
      int index =
          state.itemsList.indexWhere((item) => item.id == updatedItem.id);
      state.itemsList[index] = updatedItem;
      return true;
    } catch (e) {
      log('Failed to update todo item: $e');
      return false;
    }
  }

  Future<bool> updateItemOrder(List<Item> items) async {
    try {
      for (int i = 0; i < items.length; i++) {
        items[i].indexId = i;
      }
      List<Item> updateditems = List<Item>.from(state.itemsList);
      for (var item in items) {
        int index = updateditems.indexWhere((p) => p.id == item.id);
        if (index != -1) {
          updateditems[index] = item;
        }
      }
      updateditems.sort((a, b) => a.indexId.compareTo(b.indexId));
      for (int i = 0; i < updateditems.length; i++) {
        updateditems[i].indexId = i;
      }
      await dbHelper.updateItemOrder(updateditems);
      emit(state.copyWith(itemsList: updateditems));

      return true;
    } catch (e) {
      log('ERROR: Failed to reorder itemsList: $e');
      return false;
    }
  }

  Future<bool> deleteItem(int itemId) async {
    try {
      await dbHelper.deleteItem(itemId);
      state.itemsList.removeWhere((item) => item.id == itemId);
      return true;
    } catch (e) {
      log('Failed to delete item from list: $e');
      return false;
    }
  }

  void filterItemsByCategory(ItemCategory category) async {
    // If 'All' is selected, fetch all items
    if (category == ItemCategory.All) {
      fetchItemData();
      return;
    }

    List<Item> filteredList = state.itemsList.where((item) {
      return item.category == category;
    }).toList();
    emit(ItemState(filteredList));
  }
}
