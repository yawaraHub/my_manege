import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_manege/app/parts/category_select/category_select_sc.dart';

class ScheduleDidAdd extends StatefulWidget {
  const ScheduleDidAdd({Key? key}) : super(key: key);

  @override
  State<ScheduleDidAdd> createState() => _ScheduleDidAddState();
}

class _ScheduleDidAddState extends State<ScheduleDidAdd> {
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context, TimeOfDay selectedTime,
      Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        onTimeSelected(picked); // 時間を選択したらコールバックを呼び出して状態を更新
      });
    } else {
      // キャンセルされた場合、デフォルトの時間を設定
      setState(() {
        onTimeSelected(TimeOfDay(hour: 0, minute: 0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(labelColor: Colors.black, tabs: [
                Tab(
                  text: '予定',
                ),
                Tab(
                  text: '実際',
                )
              ]),
              Expanded(
                child: TabBarView(children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CategorySelect();
                                  });
                            },
                            child: Text('カテゴリーを選択')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('開始時間 '),
                            TextButton(
                              child: Text(
                                "${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}",
                                style: TextStyle(fontSize: 25),
                              ),
                              onPressed: () => _selectTime(
                                  context, selectedStartTime, (time) {
                                selectedStartTime = time;
                              }),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('終了時間 '),
                            TextButton(
                              child: Text(
                                "${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}",
                                style: TextStyle(fontSize: 25),
                              ),
                              onPressed: () =>
                                  _selectTime(context, selectedEndTime, (time) {
                                selectedEndTime = time;
                              }),
                            ),
                          ],
                        ),
                        TextField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(labelText: 'メモ'),
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CategorySelect();
                                  });
                            },
                            child: Text('カテゴリーを選択')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('開始時間 '),
                            TextButton(
                              child: Text(
                                "${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}",
                                style: TextStyle(fontSize: 25),
                              ),
                              onPressed: () => _selectTime(
                                  context, selectedStartTime, (time) {
                                selectedStartTime = time;
                              }),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedStartTime = TimeOfDay.now();
                                });
                              },
                              child: Text('開始'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('終了時間 '),
                            TextButton(
                              child: Text(
                                "${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}",
                                style: TextStyle(fontSize: 25),
                              ),
                              onPressed: () =>
                                  _selectTime(context, selectedEndTime, (time) {
                                selectedEndTime = time;
                              }),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedEndTime = TimeOfDay.now();
                                });
                              },
                              child: Text('終了'),
                            ),
                          ],
                        ),
                        TextField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(labelText: '振り返り'),
                        )
                      ],
                    ),
                  ),
                ]),
              )
            ],
          ),
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
          child: Text('登録'),
        ),
      ],
    );
  }
}
