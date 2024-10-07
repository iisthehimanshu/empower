import 'package:empower/Empower/APIModel/Schedulemodel.dart';
import 'package:flutter/material.dart';

import '../APIModel/CardData.dart';
import '../SessionDetail.dart';


class card extends StatelessWidget {
  CardData data;
  card(this.data, {super.key});

  List<Widget> getGenere(){
    List<Widget> widgets = [];
    data.categories!.isNotEmpty? widgets.add(Container(
      padding: EdgeInsets.only(left: 6,right: 6,top: 2, bottom: 2),decoration: BoxDecoration(
      color: Color(0xffB2EFE4),
      borderRadius: BorderRadius.circular(2), // Set the border radius
    ),child: Text(
      "${data.categories}",
      style: const TextStyle(
        fontFamily: "Roboto",
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        height: 18/12,
      ),
      textAlign: TextAlign.left,
    ),)) : ();
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
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
          MaterialPageRoute(builder: (context)=>SessionDetail(title: data.eventName??"", date: data.eventDate??"", startDate: "", endDate: "", time: data.startTime??"", loc: data.venueName??"", hash: [""], seats: "", eventid: data.sId!, category: data.categories??"", subevents: data.subEvents?? <dynamic>[]
              , filename: data.filename??"", eventType: data.eventType??"", bookingType: data.bookingType??"", description:data.eventDetails, moderator: data.moderator??"",speakerName: data.speakerName,dataForHiveStorageAndFurtherUse: data,))
        );

      },
      child: Container(
        width: screenWidth,
        height: screenHeight*0.15,
        margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: data.isEventHappeningNow()?Color(0xff48246C):Colors.white,
          borderRadius: BorderRadius.circular(8.0), // Clip the image to rounded corners
          border: Border.all(
            color: Colors.black12, // Set the border color
            width: 1.0, // Set the border width
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: screenHeight*0.15,
              // color: Color(0xffECC113),
              decoration: BoxDecoration(
                color: Color(0xff2FC8AD),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)), // Clip the image to rounded corners
              ),
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
                  SizedBox(height: 10,),
                  Container(

                    child: Text(
                      "${data.eventName}",
                      style: const TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff000000),
                        height: 23/16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 4,),
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
                  SizedBox(height: 4,),
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
      ),
    );
  }
}
