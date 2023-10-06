import 'dart:math';

import 'package:flutter/material.dart';

class CircleSchedule {
  Widget circleSchedule(
      {required double width, required List<Map<String, dynamic>> schedules}) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(width - 50, width - 50),
                  painter: ClockPainter(),
                ),
                CustomPaint(
                  size: Size(width - 80, width - 80),
                  painter: WhiteCircle(),
                ),
                for (int i = 0; i < schedules.length; i++) ...{
                  CustomPaint(
                    size: Size(width - 85, width - 85),
                    painter: FunShape(
                      scheduleData: schedules[i],
                      thisColor: schedules[i]['thisColor'],
                      // 色を指定
                      startTime: schedules[i]['startTime'],
                      // 開始時間
                      endTime: schedules[i]['endTime'],
                      // 終了時間
                      categoryName: schedules[i]['categoryName'], //カテゴリー名
                    ),
                  ),
                }
              ],
            ),
            SizedBox(height: width * 0.1)
          ],
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2 * 0.99;
    final double lineLength = 10.0;

    final Paint paint = Paint()
      ..color = Colors.black // 目盛りの色
      ..strokeWidth = 2.0;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final double startAngle = -pi / 2; // 開始角度（12時の位置）

    for (int hour = 0; hour < 24; hour++) {
      final double angle = startAngle + (2 * pi * (hour / 24));

      final double lineX = centerX + (radius - lineLength) * cos(angle);
      final double lineY = centerY + (radius - lineLength) * sin(angle);
      final Offset lineStart = Offset(centerX, centerY);
      final Offset lineEnd = Offset(lineX, lineY);

      // 線を描画
      canvas.drawLine(lineStart, lineEnd, paint);

      // テキストを描画
      final double textX = centerX + (radius) * 1.02 * cos(angle);
      final double textY = centerY + (radius) * 1.02 * sin(angle);
      textPainter.text = TextSpan(
        text: hour.toString(), // 0から23までの数字
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 20.0,
        ),
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
              textX - textPainter.width / 2, textY - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class WhiteCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white // 円の色
      ..style = PaintingStyle.fill; // 塗りつぶしスタイル

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = (size.width - 8) / 2;

    // 円を描画
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class FunShape extends CustomPainter {
  final Map<String, dynamic> scheduleData;
  final String thisColor; // 色を受け取るためのプロパティ
  final String startTime; // 開始角度を受け取るためのプロパティ
  final String endTime; // 弧の角度を受け取るためのプロパティ
  final String categoryName;

  FunShape(
      {required this.scheduleData,
      required this.thisColor,
      required this.startTime,
      required this.endTime,
      required this.categoryName});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(int.parse("0xff$thisColor")) // 扇の色
      ..style = PaintingStyle.fill; // 塗りつぶしスタイル

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    List<String> timeStartParts = startTime.split(":");
    List<String> timeEndParts = endTime.split(":");
    final int startHour = int.parse(timeStartParts[0]);
    final int startMinute = int.parse(timeStartParts[1]);
    final int startSecond = int.parse(timeStartParts[2]);
    final int endHour = int.parse(timeEndParts[0]);
    final int endMinute = int.parse(timeEndParts[1]);
    final int endSecond = int.parse(timeEndParts[2]);
    final double startAngle =
        pi / 12 / 60 * (startHour * 60 + startMinute) - pi / 2; // 開始角度
    final double sweepAngle = pi /
        12 /
        60 *
        ((endHour * 60 + endMinute) - (startHour * 60 + startMinute)); // 弧の角度

    // 扇を描画
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      sweepAngle,
      true, // trueで扇を描画、falseで円環を描画
      paint,
    );
    if (sweepAngle >= pi / 6) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text:
              '$categoryName\n${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')} ~ ${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();
      final double textX = centerX +
          radius * 0.85 * cos(startAngle + sweepAngle / 2) -
          textPainter.width / 2;
      final double textY = centerY +
          radius * 0.85 * sin(startAngle + sweepAngle / 2) -
          textPainter.height / 2;

      textPainter.paint(canvas, Offset(textX, textY));
    } else {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: categoryName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();
      final double textX = centerX +
          radius * 0.80 * cos(startAngle + sweepAngle / 2) -
          textPainter.width / 2;
      final double textY = centerY +
          radius * 0.80 * sin(startAngle + sweepAngle / 2) -
          textPainter.height / 2;

      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
