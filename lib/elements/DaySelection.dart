import 'package:flutter/material.dart';

import 'dayWidget.dart';

class DaySelection extends StatefulWidget {
  final List<DateTime> dateList; // List of DateTimes

  DaySelection(this.dateList, {super.key});

  @override
  _DaySelectionState createState() => _DaySelectionState();
}

class _DaySelectionState extends State<DaySelection> {
  int selectedIndex = 0; // Default selected index is the first one

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: 8,right: 8),
      width: screenWidth,
      height: 92,
      color: Color(0xff48246C),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.dateList.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index; // Set selected index on tap
              });
            },
            child: dayWidget(
              widget.dateList[index],
              index,
              isSelected: selectedIndex == index, // Pass selection state
            ),
          );
        }),
      ),
    );
  }
}