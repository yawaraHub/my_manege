import 'package:flutter/material.dart';

class HabitScheduleAdd extends StatefulWidget {
  const HabitScheduleAdd({Key? key}) : super(key: key);

  @override
  State<HabitScheduleAdd> createState() => _HabitScheduleAddState();
}

class _HabitScheduleAddState extends State<HabitScheduleAdd> {
  int days = 7;
  List l = [
    [4, 5],
    [0, 10],
    [15, 20],
    [5, 7],
    [9, 20],
    [12, 14],
    [4, 13]
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: '名前'),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      decoration: InputDecoration(labelText: '日数'),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('作製'),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < days; i++) ...{
                      Column(
                        children: [
                          Text('${i + 1}日目'),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('予定'),
                          ),
                          //TODO:これが予定表。1時間20のheight
                          SizedBox(
                            width: 100,
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
                                              fontSize: 10,
                                              color: Colors.black),
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
                              Column(
                                children: [
                                  SizedBox(
                                      height: 10), //これはDividerが上に空白を作るからその対策
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
                            ]),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    }
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
