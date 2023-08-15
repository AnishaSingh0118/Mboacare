import 'dart:math';
import 'package:flutter/material.dart';

class ChipWidget extends StatefulWidget {
  final String title;
  const ChipWidget(this.title, {super.key});

  @override
  State<ChipWidget> createState() => _ChipWidgetState();
}

class _ChipWidgetState extends State<ChipWidget> {
  final colorsArray = [
    {
      "id": "1",
      "colorName": Colors.red,
      "colorValue": Colors.red[50],
    },
    {
      "id": "2",
      "colorName": Colors.green,
      "colorValue": Colors.green[50],
    },
    {
      "id": "3",
      "colorName": Colors.blueGrey,
      "colorValue": Colors.blueGrey[50],
    },
    {
      "id": "4",
      "colorName": Colors.orange,
      "colorValue": Colors.orange[50],
    },
    {
      "id": "5",
      "colorName": Colors.cyan,
      "colorValue": Colors.cyan[50],
    },
  ];
  @override
  Widget build(BuildContext context) {
    final randomIndex = Random().nextInt(colorsArray.length);
    final randomColorMap = colorsArray[randomIndex];
    Color color = randomColorMap['colorName'] as Color;
    Color colorShade = randomColorMap['colorValue'] as Color;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: colorShade,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: color,
              width: 1.0,
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.title,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
