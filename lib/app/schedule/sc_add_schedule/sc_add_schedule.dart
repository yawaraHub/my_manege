import 'package:flutter/material.dart';
import 'package:my_manege/app/schedule/sc_add_schedule/sc_select_category.dart';
import 'package:my_manege/sqflite/tb_category.dart';
import 'package:my_manege/sqflite/tb_logs.dart';
import 'package:my_manege/sqflite/tb_schedules.dart';

import '../../../main.dart';

class AddSchedule extends StatefulWidget {
  final int homeIndex;
  final Map<String, dynamic> scheduleData;
  const AddSchedule(
      {super.key, required this.homeIndex, required this.scheduleData});
  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  List<bool> isSelected = [true, false];
  Map<String, dynamic> categoryData = {};
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  String description = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _getData() async {
    categoryData = await CategoriesDao()
        .categoryData(widget.scheduleData['data']['category_id']);
    List day = widget.scheduleData['data']['day'].split('/');
    selectedDate =
        DateTime(int.parse(day[0]), int.parse(day[1]), int.parse(day[2]));
    List<String> start = widget.scheduleData['data']['start_at'].split(":");
    List<String> end = widget.scheduleData['data']['end_at'].split(":");
    selectedStartTime =
        TimeOfDay(hour: int.parse(start[0]), minute: int.parse(start[1]));
    selectedEndTime =
        TimeOfDay(hour: int.parse(end[0]), minute: int.parse(end[1]));
    if (widget.scheduleData['schedule']) {
      description = widget.scheduleData['data']['description'] ?? "";
    } else {
      description = widget.scheduleData['data']['review'] ?? "";
    }
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
    return Scaffold(
      body: SingleChildScrollView(
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

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SelectCategory(
                      homeIndex: widget.homeIndex,
                    );
                  }),
                );
              },
              child: Text('${categoryData['name']}'),
            ),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomePage(selectedIndex: widget.homeIndex);
                  }),
                );
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
                    'category_id': widget.scheduleData['data']['category_id'],
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
                    'category_id': widget.scheduleData['data']['category_id'],
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
        ),
      ),
    );
  }
}
