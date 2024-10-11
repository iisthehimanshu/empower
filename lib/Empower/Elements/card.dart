import 'package:empower/Empower/APIModel/Schedulemodel.dart';
import 'package:empower/Navigation/Elements/HelperClass.dart';
import 'package:flutter/material.dart';

import '../APIModel/CardData.dart';
import '../SessionDetail.dart';

class card extends StatelessWidget {
  final CardData data;
  card(this.data, {super.key});

  List<Widget> getGenere() {
    List<Widget> widgets = [];
    // Display the categories in a capsule-like container
    if (data.categories != null && data.categories!.isNotEmpty) {
      widgets.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Color(0xffB2EFE4),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            "${data.categories}",
            style: const TextStyle(
              fontFamily: "Roboto",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              height: 18 / 12,
            ),
          ),
        ),
      );
    }

    // Display up to two genres
    for (int i = 0; i < data.genre!.length && i < 2; i++) {
      widgets.add(
        Container(
          margin: EdgeInsets.only(left: 4),
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            "${data.genre![i]}",
            style: const TextStyle(
              fontFamily: "Roboto",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff010100),
              height: 18 / 12,
            ),
          ),
        ),
      );
    }

    // If there are more than 2 genres, show a "+x" indicator
    if (data.genre!.length > 2) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            "+${data.genre!.length - 2}",
            style: const TextStyle(
              fontFamily: "Roboto",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff010100),
              height: 18 / 12,
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionDetail(
              title: data.eventName ?? "",
              date: data.eventDate ?? "",
              startDate: "",
              endDate: "",
              time: data.startTime ?? "",
              loc: data.venueName ?? "",
              hash: [""],
              seats: "",
              eventid: data.sId!,
              category: data.categories ?? "",
              subevents: data.subEvents ?? <dynamic>[],
              filename: data.filename ?? "",
              eventType: data.eventType ?? "",
              bookingType: data.bookingType ?? "",
              description: data.eventDetails,
              moderator: data.moderator ?? "",
              speakerName: data.speakerName,
              speakerID: data.speakerId,
              dataForHiveStorageAndFurtherUse: data,
            ),
          ),
        );
      },
      child: Container(
        height: 121,
        width: screenWidth,
        margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: data.isCurrentDateTimeBetween(
              data.startTime!, data.endTime!, data.eventDate!)
              ? Color(0xffF1FFFE)
              : data.eventName!.contains("Lunch")
              ? Color(0xffBDBDBD)
              : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align top
          children: [
            // Left colored strip
            Container(
              width: 10,
              height: double.infinity, // Makes the strip stretch to the content height
              decoration: BoxDecoration(
                color: Color(0xff2FC8AD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),

            // Event details
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories and Genres
                    Row(
                      children: getGenere(),
                    ),
                    SizedBox(height: 8),

                    // Event name with ellipsis if it's too long
                    Flexible(
                      child: Text(
                        "${HelperClass.truncateString(data.eventName!, 40)}", // Limit to 40 characters
                        style: const TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff000000),
                          height: 23 / 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4),

                    // Time and location
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "${data.startTime} - ${data.endTime}",
                          style: const TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff010100),
                            height: 20 / 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            "${data.venueName}",
                            style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff010100),
                              height: 20 / 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
