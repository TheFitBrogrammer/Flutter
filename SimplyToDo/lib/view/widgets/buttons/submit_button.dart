import 'package:flutter/material.dart';
import 'package:simply_todo/data/bloc/cubits/item_cubit.dart';
import 'package:simply_todo/util/values/enums.dart';

// ignore: camel_case_types
class kButton_Submit extends StatelessWidget {
  final String buttonTitle;
  final TextEditingController textController;
  final ItemCubit itemCubit;
  final ItemCategory selectedCategory;
  final void Function() onPressed;

  const kButton_Submit({
    super.key,
    required this.buttonTitle,
    required this.textController,
    required this.itemCubit,
    required this.selectedCategory,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(const Size(150, 50)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(buttonTitle, style: const TextStyle(color: Colors.white)),
    );
  }
}
