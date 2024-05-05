import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit_state.dart';
import 'package:simply_todo/data/database/database_helper.dart';
import 'package:simply_todo/data/models/item.dart';

class ItemCubit extends Cubit<ItemState> {
  final DatabaseHelper dbHelper;

  ItemCubit({required this.dbHelper}) : super(ItemState([]));

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

// ********************** DATABASE/STATE LOGIC **********************
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

      emit(state.copyWith(itemsList: List<Item>.from(state.itemsList)));
      return true;
    } catch (e) {
      log('Failed to update todo item: $e');
      return false;
    }
  }

  void reorderItem(int oldIndex, int newIndex) {
    var items = List<Item>.from(state.itemsList);

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    for (int i = 0; i < items.length; i++) {
      items[i].indexId = i;
    }

    updateItemOrderInDatabase(items);
  }

  Future<bool> updateItemOrderInDatabase(List<Item> reorderedItems) async {
    try {
      for (int i = 0; i < reorderedItems.length; i++) {
        reorderedItems[i].indexId = i;
      }
      await dbHelper.updateItemOrder(reorderedItems);

      emit(ItemState(reorderedItems));
      return true;
    } catch (e) {
      log('ERROR: Failed to reorder itemsList: $e');
      return false;
    }
  }

  Future<bool> deleteItem(int itemId) async {
    try {
      await dbHelper.deleteItem(itemId);
      List<Item> updatedItemsList = List<Item>.from(state.itemsList);
      updatedItemsList.removeWhere((item) => item.id == itemId);
      updateItemOrderInDatabase(updatedItemsList);

      return true;
    } catch (e) {
      log('Failed to delete item from list: $e');
      return false;
    }
  }
}
