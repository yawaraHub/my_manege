import 'package:flutter/material.dart';
import 'package:my_manege/app/category/color_picker.dart';

class CategoryAdd extends StatefulWidget {
  final int parentId;
  const CategoryAdd({super.key, required this.parentId});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  String colorCode = '660000';
  String categoryName = "";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              onChanged: (newValue) {
                categoryName = newValue;
              },
              decoration: InputDecoration(labelText: 'カテゴリー名'),
            ),
            ColorPicker(
              colorCode: colorCode,
              updateCallback: (newColor) {
                setState(() {
                  colorCode = newColor;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('閉じる'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('追加'),
        ),
      ],
    );
  }
}
