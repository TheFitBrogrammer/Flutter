import 'package:simply_todo/model/object_models/item.dart';

class ItemState {
  List<Item> itemsList;

  ItemState(this.itemsList);

  ItemState copyWith({
    List<Item>? itemsList,
  }) {
    return ItemState(
      itemsList ?? this.itemsList,
    );
  }
}
