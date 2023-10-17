import 'package:flutter/material.dart';
import 'package:my_manege/app/schedule/sc_schedule/desplay_schedule_log_parts/circle_schedule.dart';
import 'package:my_manege/app/schedule/sc_schedule/desplay_schedule_log_parts/timetable_schedule.dart';

class ScheduleAndLogParts extends StatefulWidget {
  final bool scheduleType;
  final List<Map<String, dynamic>> schedules;
  final List<Map<String, dynamic>> logs;
  const ScheduleAndLogParts(
      {super.key,
      required this.scheduleType,
      required this.schedules,
      required this.logs});

  @override
  State<ScheduleAndLogParts> createState() => _ScheduleAndLogPartsState();
}

class _ScheduleAndLogPartsState extends State<ScheduleAndLogParts> {
  //この関数でスケジュールの表示方法を円かタイムテーブルかに分ける
  Widget switchScheduleType({required data, required type}) {
    if (type) {
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
      return TimetableSchedule(
        width: MediaQuery.of(context).size.width * 0.5,
        height: height,
        schedules: data,
      );
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
    return Row(
      children: [
        Column(
          children: [
            Text('予定'),
            switchScheduleType(
                data: widget.schedules, type: widget.scheduleType),
          ],
        ),
        Column(
          children: [
            Text('行動記録'),
            switchScheduleType(data: widget.logs, type: widget.scheduleType),
          ],
        ),
      ],
    );
  }
}
