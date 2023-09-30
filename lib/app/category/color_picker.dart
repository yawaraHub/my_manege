import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final String colorCode;
  final Function(String) updateCallback;
  const ColorPicker(
      {super.key, required this.colorCode, required this.updateCallback});

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late String colorCode;
  @override
  void initState() {
    super.initState();
    colorCode = widget.colorCode; // コンストラクターで受け取った値を代入
  }

  colorSelectButton(
      {required int r, required int g, required int b, required double width}) {
    String thisColor =
        '${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
    if (colorCode == thisColor) {
      return GestureDetector(
        onTap: () {
          colorCode = thisColor;
          widget.updateCallback(colorCode);
          setState(() {
            colorCode;
          });
        },
        child: CustomPaint(
          size: Size(width / 10, width / 10),
          painter: SelectedCircularColor(
            thisColor: thisColor,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          colorCode = thisColor;
          widget.updateCallback(colorCode);
          setState(() {
            colorCode;
          });
        },
        child: CustomPaint(
          size: Size(width / 15, width / 15),
          painter: CircularColor(
            thisColor: thisColor,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(int.parse("0xff$colorCode")),
          ),
          child: Text(
            '色を選択',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // ボーダーの色
              width: 2.0, // ボーダーの幅
            ),
          ),
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int j = 0; j < 4; j++) ...{
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: (k + 1) * 51,
                            g: (j * 12.75).toInt() * (k + 1),
                            b: 0,
                            width: width)
                      },
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: 255,
                            g: j * 51 + ((255 - j * 51) / 5 * k).toInt(),
                            b: k * 51,
                            width: width)
                      },
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                },
                for (int j = 0; j < 4; j++) ...{
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: 51 * (k + 1) - (j * 12.75).toInt() * (k + 1),
                            g: (k + 1) * 51,
                            b: 0,
                            width: width)
                      },
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: 255 - j * 51 + ((j * 51) / 5 * k).toInt(),
                            g: 255,
                            b: k * 51,
                            width: width)
                      },
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                },
                for (int j = 0; j < 4; j++) ...{
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: 0,
                            g: (k + 1) * 51,
                            b: (j * 12.75).toInt() * (k + 1),
                            width: width)
                      },
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: k * 51,
                            g: 255,
                            b: j * 51 + ((255 - j * 51) / 5 * k).toInt(),
                            width: width)
                      },
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                },
                for (int j = 0; j < 4; j++) ...{
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: 0,
                            g: 51 * (k + 1) - (j * 12.75).toInt() * (k + 1),
                            b: (k + 1) * 51,
                            width: width)
                      },
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: k * 51,
                            g: 255 - j * 51 + ((j * 51) / 5 * k).toInt(),
                            b: 255,
                            width: width)
                      },
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                },
                for (int j = 0; j < 4; j++) ...{
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: (j * 12.75).toInt() * (k + 1),
                            g: 0,
                            b: (k + 1) * 51,
                            width: width)
                      },
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: j * 51 + ((255 - j * 51) / 5 * k).toInt(),
                            g: k * 51,
                            b: 255,
                            width: width)
                      },
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                },
                for (int j = 0; j < 4; j++) ...{
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: (k + 1) * 51,
                            g: 0,
                            b: 51 * (k + 1) - (j * 12.75).toInt() * (k + 1),
                            width: width)
                      },
                      for (int k = 1; k < 5; k++) ...{
                        colorSelectButton(
                            r: 255,
                            g: k * 51,
                            b: 255 - j * 51 + ((j * 51) / 5 * k).toInt(),
                            width: width)
                      },
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                },
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CircularColor extends CustomPainter {
  final String thisColor; // 色を受け取るためのプロパティ

  CircularColor({
    required this.thisColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(int.parse("0xff$thisColor")) // 円の色を設定
      ..style = PaintingStyle.fill; // 塗りつぶしスタイルを設定

    final center = Offset(size.width / 2, size.height / 2); // 円の中心座標を計算
    final radius = size.width / 2; // 円の半径を設定

    // 円を描画
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SelectedCircularColor extends CustomPainter {
  final String thisColor; // 色を受け取るためのプロパティ

  SelectedCircularColor({
    required this.thisColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(int.parse("0xff$thisColor")) // 円の色を設定
      ..style = PaintingStyle.fill; // 塗りつぶしスタイルを設定

    final center = Offset(size.width / 2, size.height / 2); // 円の中心座標を計算
    final radius = size.width / 2; // 円の半径を設定

    // 円を描画
    canvas.drawCircle(center, radius, paint);

    // ✓マークを描画
    final checkPaint = Paint()
      ..color = Colors.white // ✓マークの色を設定
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0; // ✓マークの線の太さを設定

    final checkPath = Path()
      ..moveTo(center.dx - radius / 2, center.dy)
      ..lineTo(center.dx - radius / 4, center.dy + radius / 4)
      ..lineTo(center.dx + radius / 2, center.dy - radius / 2);

    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
