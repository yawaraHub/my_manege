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
  late List<Map<String, dynamic>> schedules = [];
  late List<Map<String, dynamic>> logs = [];

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
        "${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}");

    for (int i = 0; i < originalLogs.length; i++) {
      logs.add({});
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
        "${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}");
    List<Map<String, dynamic>> originalAllSchedules =
        await SchedulesDao().queryAllRows();
    for (int i = 0; i < originalSchedules.length; i++) {
      schedules.add({});
      schedules[i]['id'] = originalSchedules[i]['id'];
      schedules[i]['day'] = originalSchedules[i]['day'];
      schedules[i]['start_at'] = originalSchedules[i]['start_at'];
      schedules[i]['end_at'] = originalSchedules[i]['end_at'];
      schedules[i]['description'] = originalSchedules[i]['description'];
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
      selectedDate = picked;
      schedules = [];
      logs = [];
      _getLogs();
      _getSchedules();
      setState(() {});
    }
  }

  //TODO:スケジュールかやったことか両方を表示するのかを判定しそれを円かタイムテーブルで表示するのかを判定し、そのWidgetを生成する

  //この関数でスケジュールの表示方法を円かタイムテーブルかに分ける
  Widget switchScheduleType(data) {
    if (scheduleType) {
      double height = 0;
      //このIF文で画面目一杯のタイムテーブルか高さが400のタイムテーブルにしている。
      double size = (Scaffold.of(context).appBarMaxHeight ?? 0) +
          MediaQuery.of(context).size.height -
          kBottomNavigationBarHeight;

      if (size < 400) {
        height = 400;
      } else {
        height = size;
      }
      return TimetableSchedule().timetableSchedule(
          width: MediaQuery.of(context).size.width * 0.5,
          height: height,
          schedules: data);
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
      return CircleSchedule()
          .circleSchedule(width: size * 0.5, schedules: data);
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
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    "${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}",
                    style: TextStyle(fontSize: 30, color: Colors.blueAccent),
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
            Row(
              children: [
                Column(
                  children: [
                    Text('予定'),
                    switchScheduleType(schedules),
                  ],
                ),
                Column(
                  children: [
                    Text('行動記録'),
                    switchScheduleType(logs),
                  ],
                ),
              ],
            ),
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
