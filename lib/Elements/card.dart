import 'package:flutter/material.dart';

import '../apimodels/Schedulemodel.dart';

class card extends StatelessWidget {
  Data data;
  card(this.data, {super.key});

  List<Widget> getGenere(){
    List<Widget> widgets = [];
    widgets.add(Container(
      padding: EdgeInsets.only(left: 6,right: 6,top: 2, bottom: 2),decoration: BoxDecoration(
      color: Color(0xff48246C),
      borderRadius: BorderRadius.circular(2), // Set the border radius
    ),child: Text(
      "${data.categories}",
      style: const TextStyle(
        fontFamily: "Roboto",
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        height: 18/12,
      ),
      textAlign: TextAlign.left,
    ),));
    for(int i = 0; i<data.genre!.length; i++){
      if(i==2) break;
      widgets.add(Container(
        margin: EdgeInsets.only(left: 4),
        padding: EdgeInsets.only(left: 6,right: 6,top: 2, bottom: 2),
        decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set the border color
          width: 1.0, // Set the border width
        ),
        borderRadius: BorderRadius.circular(2), // Set the border radius
      ),child: Text(
        "${data.genre![i]}",
        style: const TextStyle(
          fontFamily: "Roboto",
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xff010100),
          height: 18/12,
        ),
        textAlign: TextAlign.left,
      ),));
    }
    if(data.genre!.length>2){
      widgets.add(Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          "+${data.genre!.length-2}",
          style: const TextStyle(
            fontFamily: "Roboto",
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xff010100),
            height: 18/12,
          ),
          textAlign: TextAlign.left,
        ),
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      height: 121,
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: data.isEventHappeningNow()?Color(0xff48246C):Colors.white,
        border: Border.all(
          color: Color(0xffEBEBEB), // Set the border color
          width: 1.0, // Set the border width
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 121,
            color: Color(0xffECC113),
          ),
          Container(
            padding: EdgeInsets.only(left: 12,top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: getGenere(),
                ),
                SizedBox(height: 2,),
                Text(
                  "${data.eventName}",
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff010100),
                    height: 23/16,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 2,),
                Row(
                  children: [
                    Icon(Icons.access_time_outlined),
                    SizedBox(width: 8,),
                    Text(
                      "${data.startTime} - ${data.endTime}",
                      style: const TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff010100),
                        height: 20/14,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
                SizedBox(height: 2,),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 8,),
                    Text(
                      "${data.venueName}",
                      style: const TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff010100),
                        height: 20/14,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
