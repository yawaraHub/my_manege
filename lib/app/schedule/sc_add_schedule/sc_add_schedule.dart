import 'package:flutter/material.dart';
import 'package:my_manege/sqflite/tb_category.dart';
import 'package:my_manege/sqflite/tb_logs.dart';
import 'package:my_manege/sqflite/tb_schedules.dart';

import '../../../main.dart';

class AddSchedule extends StatefulWidget {
  final int categoryId;
  const AddSchedule({super.key, required this.categoryId});
  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  List<bool> isSelected = [true, false];
  Map<String, dynamic> categoryData = {};
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  String description = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategoryData();
  }

  _getCategoryData() async {
    categoryData = await CategoriesDao().categoryData(widget.categoryId);
    setState(() {});
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime, // 最初に表示する時刻を設定
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime, // 最初に表示する時刻を設定
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedEndTime = picked;
      });
    }
  }

  _timer() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('タイマー : ${categoryData['name']}'),
          content: Column(
            children: [],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('閉じる'),
            ),
          ],
        );
      },
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1000),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                "${selectedDate.toLocal()}".split(' ')[0],
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            ),
            Text('${categoryData['name']}'),
            //select schedule or behavior
            ToggleButtons(
              children: [
                Text('　予定　'),
                Text('行動記録'),
              ],
              isSelected: isSelected,
              onPressed: (index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              color: Colors.grey,
              selectedColor: Colors.black,
              selectedBorderColor: Colors.blue,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    _selectStartTime(context);
                  },
                  child: Text(
                      '${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}'),
                ),
                Text('~'),
                TextButton(
                  onPressed: () {
                    _selectEndTime(context);
                  },
                  child: Text(
                      '${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}'),
                ),
              ],
            ),
            //show timer
            if (isSelected[1]) ...{
              ElevatedButton(
                onPressed: () {
                  _timer();
                },
                child: Text('タイマー'),
              ),
            },
            //enter notes
            TextField(
              decoration: InputDecoration(
                  labelText: 'メモ', border: OutlineInputBorder()),
              maxLines: null,
              onChanged: (value) {
                description = value;
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
            if (isSelected[0]) {
              //Record schedule here
              SchedulesDao().insert({
                'day':
                    "${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}",
                'start_at':
                    "${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}",
                'end_at':
                    "${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}",
                'description': description,
                'category_id': widget.categoryId,
                'created_at': DateTime.now().toString(),
                'updated_at': DateTime.now().toString(),
              });
            } else {
              //Record behavior here
              LogsDao().insert({
                'day':
                    "${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}",
                'start_at':
                    "${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}",
                'end_at':
                    "${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}",
                'review': description,
                'category_id': widget.categoryId,
                'created_at': DateTime.now().toString(),
                'updated_at': DateTime.now().toString(),
              });
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return HomePage(selectedIndex: 0);
              }),
            );
          },
          child: Text('登録'),
        ),
      ],
    );
  }
}
