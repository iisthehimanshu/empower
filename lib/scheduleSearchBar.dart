import 'package:flutter/material.dart';

class scheduleSearchBar extends StatelessWidget {
  const scheduleSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      height: 56,
      color: Color(0xff48246C),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,))),
          Text(
            "Schedule",
            style: const TextStyle(
              fontFamily: "Roboto",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xffffffff),
              height: 23/16,
            ),
            textAlign: TextAlign.left,
          ),
          Container(
              child: IconButton(onPressed: (){}, icon: Icon(Icons.search,color: Colors.white,))),
        ],
      ),
    );
  }
}
