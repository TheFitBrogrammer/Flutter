// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit_state.dart';
import 'package:simply_todo/data/bloc/cubits/settings_cubit.dart';
import 'package:simply_todo/data/models/item.dart';
import 'package:simply_todo/util/forms/edit_item_form.dart';
import 'package:simply_todo/util/values/enums.dart';
import 'package:simply_todo/util/widgets/app_bars/app_bar.dart';
import 'package:simply_todo/util/widgets/item_list/item_list_builder.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final SettingsCubit settingsCubit;
  const CalendarScreen({required this.settingsCubit, super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  List<Item> _getItemsForDay(DateTime day, List<Item> itemsList) {
    return itemsList.where((item) {
      final itemDate = DateTime.fromMillisecondsSinceEpoch(item.date);
      return item.date > 0 &&
          itemDate.year == day.year &&
          itemDate.month == day.month &&
          itemDate.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const kAppBar(
        title: "Calendar",
        hasAction: false,
        hasLeading: false,
      ),
      body: BlocBuilder<ItemCubit, ItemState>(
        builder: (context, state) {
          final itemCubit = context.read<ItemCubit>();
          final itemsList = state.itemsList;
          final selectedItems =
              _getItemsForDay(_selectedDay ?? _focusedDay, itemsList);
          return Column(
            children: [
              TableCalendar<Item>(
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 1825)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                eventLoader: (day) {
                  return _getItemsForDay(day, itemsList);
                },
                startingDayOfWeek: StartingDayOfWeek.sunday,
                calendarStyle: const CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Color(0xFFff6a06),
                    shape: BoxShape.circle,
                  ),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: buildItemList(
                  context,
                  itemCubit.state,
                  widget.settingsCubit.state,
                  ItemCategory.Calendar,
                  itemCubit.reorderItem,
                  (context, itemCubit, titleController, item) =>
                      showEditItemForm(
                    context,
                    itemCubit,
                    titleController,
                    item,
                    widget.settingsCubit.state.darkMode,
                  ),
                  titleController,
                  selectedItems,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
