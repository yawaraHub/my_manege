import 'package:flutter/material.dart';
import 'package:my_manege/app/parts/schedule_sc/circle_schedule.dart';
import 'package:my_manege/app/parts/schedule_sc/timetable_schedule.dart';
import 'package:my_manege/app/schedule/goal_add_sc.dart';
import 'package:my_manege/app/schedule/sc_add_schedule/sc_select_category.dart';
import 'package:my_manege/sqflite/tb_category.dart';
import 'package:my_manege/sqflite/tb_logs.dart';
import 'package:my_manege/sqflite/tb_schedules.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  // List<Map<String, dynamic>> schedules = [
  //   {
  //     'thisColor': '006666',
  //     'startTime': '08:40:00',
  //     'endTime': '10:50:00',
  //     'categoryName': 'Math'
  //   },
  //   {
  //     'thisColor': '660066',
  //     'startTime': '12:10:00',
  //     'endTime': '13:11:00',
  //     'categoryName': 'English'
  //   },
  // ];
  // List<Map<String, dynamic>> logs = [
  //   {
  //     'thisColor': '006666',
  //     'startTime': '08:40:00',
  //     'endTime': '09:40:00',
  //     'categoryName': 'Math'
  //   },
  //   {
  //     'thisColor': '660066',
  //     'startTime': '10:10:00',
  //     'endTime': '11:11:00',
  //     'categoryName': 'English'
  //   },
  // ];
  List<Map<String, dynamic>> schedules = [];
  List<Map<String, dynamic>> logs = [];
  List<Map<String, dynamic>> displayType = [
    {'bool': true, 'name': '予定'},
    {'bool': false, 'name': '行動記録'},
    {'bool': false, 'name': '予定\n＆\n行動記録'}
  ];

  bool scheduleType = true;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLogs();
    _getSchedules();
  }

  _getLogs() async {
    List<Map<String, dynamic>> originalLogs = await LogsDao().getSameDayData(
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}");

    for (int i = 0; i < originalLogs.length; i++) {
      logs[i]['id'] = originalLogs[i]['id'];
      logs[i]['day'] = originalLogs[i]['day'];
      logs[i]['start_at'] = originalLogs[i]['start_at'];
      logs[i]['end_at'] = originalLogs[i]['end_at'];
      logs[i]['review'] = originalLogs[i]['review'];
      logs[i]['category_id'] = originalLogs[i]['category_id'];
      logs[i]['created_at'] = originalLogs[i]['created_at'];
      logs[i]['updated_at'] = originalLogs[i]['updated_at'];
      logs[i]['deleted_at'] = originalLogs[i]['deleted_at'];
      logs[i]['category_data'] =
          await CategoriesDao().categoryData(originalLogs[i]['category_id']);
    }
    setState(() {});
  }

  _getSchedules() async {
    List<
        Map<String,
            dynamic>> originalSchedules = await SchedulesDao().getOneDaySchedule(
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}");
    for (int i = 0; i < originalSchedules.length; i++) {
      schedules[i]['id'] = originalSchedules[i]['id'];
      schedules[i]['day'] = originalSchedules[i]['day'];
      schedules[i]['start_at'] = originalSchedules[i]['start_at'];
      schedules[i]['end_at'] = originalSchedules[i]['end_at'];
      schedules[i]['review'] = originalSchedules[i]['description'];
      schedules[i]['category_id'] = originalSchedules[i]['category_id'];
      schedules[i]['created_at'] = originalSchedules[i]['created_at'];
      schedules[i]['updated_at'] = originalSchedules[i]['updated_at'];
      schedules[i]['deleted_at'] = originalSchedules[i]['deleted_at'];
      schedules[i]['category_data'] = await CategoriesDao()
          .categoryData(originalSchedules[i]['category_id']);
    }
    setState(() {});
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

  //TODO:スケジュールかやったことか両方を表示するのかを判定しそれを円かタイムテーブルで表示するのかを判定し、そのWidgetを生成する

  Widget displayTypeButton() {
    for (int i = 0; i < displayType.length; i++) {
      if (displayType[i]['bool']) {
        return SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              displayType[i]['bool'] = false;
              if (i == displayType.length - 1) {
                displayType[0]['bool'] = true;
              } else {
                displayType[i + 1]['bool'] = true;
              }
              setState(() {
                displayType;
              });
            },
            child: Text(
              displayType[i]['name'],
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
    return ElevatedButton(
        onPressed: () {
          setState(() {
            displayType[1]['bool'] = true;
          });
        },
        child: Text(displayType[0]['name']));
  }

  //この関数でスケジュールの表示方法を円かタイムテーブルかに分ける
  Widget switchScheduleType() {
    if (scheduleType) {
      double height = 0;
      //このIF文で画面目一杯のタイムテーブルか高さが400のタイムテーブルにしている。
      if (MediaQuery.of(context).size.height -
              Scaffold.of(context).appBarMaxHeight! -
              kBottomNavigationBarHeight <
          400) {
        height = 400;
      } else {
        height = MediaQuery.of(context).size.height -
            Scaffold.of(context).appBarMaxHeight! -
            kBottomNavigationBarHeight;
      }
      return TimetableSchedule().timetableSchedule(
          width: MediaQuery.of(context).size.width,
          height: height,
          schedules: schedules);
    } else {
      double size;
      //横か縦のどちらが大きいかを判断し、小さい方に合わせて円の大きさを決める。
      if (MediaQuery.of(context).size.width <
          MediaQuery.of(context).size.height -
              Scaffold.of(context).appBarMaxHeight! -
              kBottomNavigationBarHeight) {
        size = MediaQuery.of(context).size.width;
      } else {
        size = MediaQuery.of(context).size.height -
            Scaffold.of(context).appBarMaxHeight! -
            kBottomNavigationBarHeight;
      }
      return CircleSchedule().circleSchedule(width: size, schedules: schedules);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('目標'),
                subtitle: Column(
                  children: [],
                ),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return GoalAdd();
                      },
                    );
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                displayTypeButton(),
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
                Switch(
                  value: scheduleType,
                  onChanged: (newValue) {
                    setState(() {
                      scheduleType = newValue;
                    });
                  },
                ),
              ],
            ),
            switchScheduleType(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SelectCategory();
            },
          );
        },
      ),
    );
  }
}
