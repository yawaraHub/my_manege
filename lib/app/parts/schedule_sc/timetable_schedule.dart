import 'package:flutter/material.dart';

class TimetableSchedule {
  Widget timetableSchedule(
      {required double width,
      required double height,
      required List<Map<String, dynamic>> schedules}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(width, height), // タイムテーブルのサイズを調整
                  painter: TimetablePainter(),
                ),
                for (int i = 0; i < schedules.length; i++) ...{
                  CustomPaint(
                    size: Size(width, height),
                    painter: RoundedRectPainter(
                      scheduleData: schedules[i],
                      thisColor: schedules[i]['category_data']['color'],
                      startTime: schedules[i]['start_at'],
                      endTime: schedules[i]['end_at'],
                      categoryName: schedules[i]['category_data']['name'],
                    ),
                  ),
                }
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimetablePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;

    final TextStyle textStyle = TextStyle(
      color: Colors.grey[800],
      fontSize: 18.0,
    );

    final double slotHeight = size.height.toDouble() / 28; // 1時間あたりの高さ
    for (int i = 0; i < 25; i++) {
      final double startY = i * slotHeight;

      // 横線を描画
      canvas.drawLine(Offset(size.width - 20, startY + slotHeight / 2),
          Offset(80, startY + slotHeight / 2), linePaint);

      // 時間を描画
      final text = i < 10 ? '0$i:00' : '$i:00'; // 一桁の場合、0を前に追加
      final textSpan = TextSpan(text: text, style: textStyle);
      final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.right);
      textPainter.layout();
      final textHeight = textPainter.height;
      final offsetY = startY + (slotHeight - textHeight) / 2;
      textPainter.paint(canvas, Offset(20, offsetY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RoundedRectPainter extends CustomPainter {
  final Map<String, dynamic> scheduleData;
  final String thisColor;
  final String startTime;
  final String endTime;
  final String categoryName;

  RoundedRectPainter({
    required this.scheduleData,
    required this.thisColor,
    required this.startTime,
    required this.endTime,
    required this.categoryName,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Color(int.parse("0xbb$thisColor"));

    // 角の半径を指定
    final double cornerRadius = 5.0;

    //1時間のたかさ
    final hourHeight = size.height / 28;
    List<String> timeStartParts = startTime.split(":");
    List<String> timeEndParts = endTime.split(":");
    final int startHour = int.parse(timeStartParts[0]);
    final int startMinute = int.parse(timeStartParts[1]);
    final int endHour = int.parse(timeEndParts[0]);
    final int endMinute = int.parse(timeEndParts[1]);

    // RRect（丸みを帯びた矩形）を作成
    final RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(90, hourHeight * (startHour + startMinute / 60 + 1 / 2)),
        Offset(
            size.width - 30, hourHeight * (endHour + endMinute / 60 + 1 / 2)),
      ),
      Radius.circular(cornerRadius),
    );

    // 丸い角を持つ四角を描画
    canvas.drawRRect(roundedRect, paint);

    // categoryNameを描画
    if (hourHeight *
            ((endHour * 60 + endMinute) - (startHour * 60 + startMinute)) /
            60 >=
        40) {
      final TextSpan span = TextSpan(
        text:
            '$categoryName\n${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')} ~ ${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0, // テキストのサイズを設定
        ),
      );
      final TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(
          (size.width + 60) / 2 - tp.width / 2, // 四角形の中央に配置
          hourHeight * (startHour + startMinute / 60 + 1 / 2), // テキストの位置を調整
        ),
      );
    } else if (hourHeight *
            ((endHour * 60 + endMinute) - (startHour * 60 + startMinute)) /
            60 >=
        16) {
      final TextSpan span = TextSpan(
        text: categoryName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0, // テキストのサイズを設定
        ),
      );
      final TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(
          (size.width + 60) / 2 - tp.width / 2, // 四角形の中央に配置
          hourHeight * (startHour + startMinute / 60 + 1 / 2), // テキストの位置を調整
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
