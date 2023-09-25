import 'package:flutter/material.dart';
import 'package:my_manege/app/schedule/habit_schedule/habit_schedule_add_sc.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  List l = [
    [0, 6],
    [7, 9],
    [10, 13],
    [15, 17],
    [18, 20],
    [21, 24]
  ];
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HabitScheduleAdd(),
                  ),
                );
              },
              child: const Text('習慣スケジュールを作成'),
            ),
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
            Column(
              children: [
                //TODO:これが予定表。1時間20のheight
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 500,
                  child: Stack(children: [
                    Column(
                      children: [
                        for (int hour = 0; hour <= 24; hour++) ...{
                          Row(
                            children: [
                              Text(
                                '${hour.toString().padLeft(2, '0')}:00',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              SizedBox(
                                width: 4,
                                height: 20,
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey[400],
                                ),
                              ),
                              SizedBox(width: 4),
                            ],
                          ),
                        }
                      ],
                    ),
                    //この形のカラムが一つで一つの予定を表す。
                    for (int i = 0; i < l.length; i++) ...{
                      Column(
                        children: [
                          SizedBox(height: 10), //これはDividerが上に空白を作るからその対策
                          SizedBox(height: l[i][0].toDouble() * 20),
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Expanded(
                                child: Container(
                                  height: (l[i][1].toDouble() -
                                          l[i][0].toDouble()) *
                                      20,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(width: 5),
                            ],
                          ),
                        ],
                      ),
                    }
                  ]),
                ),
                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
