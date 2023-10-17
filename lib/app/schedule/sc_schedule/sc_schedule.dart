import 'package:flutter/material.dart';
import 'package:my_manege/app/schedule/sc_add_schedule/sc_select_category.dart';
import 'package:my_manege/app/schedule/sc_schedule/desplay_schedule_log_parts/scp_schedule_log.dart';
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
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
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
                  onPressed: () {},
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
            ScheduleAndLogParts(
                scheduleType: scheduleType, schedules: schedules, logs: logs),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return SelectCategory(
                homeIndex: 0,
              );
            }),
          );
        },
      ),
    );
  }
}
