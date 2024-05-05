import 'package:simply_todo/util/values/enums.dart';

class Item {
  int? id;
  int indexId;
  String title;
  bool isDone;
  ItemCategory category;
  int date;

  Item(
      {this.id,
      required this.indexId,
      required this.title,
      this.isDone = false,
      required this.category,
      this.date = 0});

  // Maps the item to a usable variable from the database.
  static Item fromMap(Map<String, dynamic> map) {
    return Item(
        id: map['id'],
        indexId: map['indexId'],
        title: map['itemTitle'],
        isDone: map['isDone'] == 1 ? true : false,
        category: ItemCategory.values[map['category']],
        date: map['date']);
  }

  // Maps the item data to table column values so we can store it for later use.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'indexId': indexId,
      'itemTitle': title,
      'isDone': isDone ? 1 : 0,
      'category': category.index,
      'date': date,
    };
  }

  Item copyWith({
    int? id,
    int? indexId,
    String? title,
    bool? isDone,
    ItemCategory? category,
    int? date,
  }) {
    return Item(
      id: id ?? this.id,
      indexId: indexId ?? this.indexId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
}
