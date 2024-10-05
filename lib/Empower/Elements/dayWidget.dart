import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class dayWidget extends StatelessWidget {
  final DateTime dateTime;
  final bool isSelected;
  final int index;

  dayWidget(this.dateTime, this.index, {required this.isSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Day ${index+1}",
          style: TextStyle(
            fontFamily: "Roboto",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isSelected ? const Color(0xff2FC8AD) : Color(0xffBDBDBD),
            height: 20 / 14,
          ),
          textAlign: TextAlign.left,
        ),
        Container(
          width: 54,
          height: 54,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? const Color(0xff2FC8AD) : Color(0xffBDBDBD),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${dateTime.day}",
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000),
                  height: 23 / 16,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                DateFormat('MMM').format(dateTime),
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                  height: 18 / 12,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }
}