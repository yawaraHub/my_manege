import 'package:flutter/material.dart';
import 'package:my_manege/app/parts/schedule_sc/circle_schedule.dart';
import 'package:my_manege/app/parts/schedule_sc/timetable_schedule.dart';
import 'package:my_manege/app/schedule/goal_add_sc.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<Map<String, dynamic>> schedules = [
    {
      'thisColor': '006666',
      'startTime': 60.0,
      'endTime': 180.0,
      'categoryName': 'Math'
    },
    {
      'thisColor': '660066',
      'startTime': 180.0,
      'endTime': 400.0,
      'categoryName': 'English'
    },
  ];
  List<Map<String, dynamic>> dones = [
    {
      'thisColor': '002222',
      'startTime': 500.0,
      'endTime': 620.0,
      'categoryName': 'Math'
    },
    {
      'thisColor': '993399',
      'startTime': 680.0,
      'endTime': 740.0,
      'categoryName': 'English'
    },
    {
      'thisColor': '993399',
      'startTime': 800.0,
      'endTime': 900.0,
      'categoryName': 'English'
    },
  ];

  List<Map<String, dynamic>> displayType = [
    {'bool': true, 'name': 'Schedule'},
    {'bool': false, 'name': 'done'},
    {'bool': false, 'name': 'both'}
  ];

  bool scheduleType = true;
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
            child: Text(displayType[i]['name']),
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
    );
  }
}
