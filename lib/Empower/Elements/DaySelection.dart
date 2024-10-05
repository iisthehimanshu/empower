import 'package:flutter/cupertino.dart';

import 'dayWidget.dart';



class DaySelection extends StatefulWidget {
  final List<DateTime> dateList;
  final Function(int) onDateSelected; // Add a callback function

  DaySelection(this.dateList, {super.key, required this.onDateSelected});

  @override
  _DaySelectionState createState() => _DaySelectionState();
}

class _DaySelectionState extends State<DaySelection> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      width: screenWidth,
      height: 92,
      color: Color(0xffF1FFFE),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.dateList.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onDateSelected(index); // Call the callback
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0), // Add horizontal margin (or adjust as needed)
              child: dayWidget(
                widget.dateList[index],
                index,
                isSelected: selectedIndex == index,
              ),
            ),
          );
        }),
      ),
    );
  }
}
