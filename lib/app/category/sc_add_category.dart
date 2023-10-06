import 'package:flutter/material.dart';
import 'package:my_manege/app/category/color_picker.dart';
import 'package:my_manege/main.dart';
import 'package:my_manege/sqflite/tb_category.dart';

class AddOrEditCategory extends StatefulWidget {
  final Map<String, dynamic> categoryData;
  const AddOrEditCategory({super.key, required this.categoryData});

  @override
  State<AddOrEditCategory> createState() => _AddOrEditCategoryState();
}

class _AddOrEditCategoryState extends State<AddOrEditCategory> {
  TextEditingController _nameController = TextEditingController();
  String nameError = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.categoryData['name'];
  }

  displayError(String e) {
    if (e != '') {
      return Text(
        e,
        style: TextStyle(color: Colors.red),
      );
    } else {
      return SizedBox();
    }
  }

  addOrEditText() {
    if (widget.categoryData['created_at'] == '') {
      return Text('追加');
    } else {
      return Text('編集');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              onChanged: (newValue) {
                widget.categoryData['name'] = newValue;
              },
              decoration: InputDecoration(labelText: 'カテゴリー名'),
            ),
            displayError(nameError),
            ColorPicker(
              colorCode: widget.categoryData['color'],
              updateCallback: (newColor) {
                setState(() {
                  widget.categoryData['color'] = newColor;
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
          onPressed: () async {
            if (widget.categoryData['name'] == "") {
              setState(() {
                nameError = 'カテゴリー名を入力してください';
              });
            } else {
              print(widget.categoryData);
              if (widget.categoryData['created_at'] == '') {
                widget.categoryData['created_at'] = DateTime.now().toString();
                widget.categoryData['updated_at'] = DateTime.now().toString();
                await CategoriesDao().insert(widget.categoryData);
              } else {
                widget.categoryData['updated_at'] = DateTime.now().toString();
                await CategoriesDao().update(widget.categoryData);
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return HomePage(selectedIndex: 3);
                }),
              );
            }
          },
          child: addOrEditText(),
        ),
      ],
    );
  }
}
