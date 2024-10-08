import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'API/ScheduleAPI.dart';
import 'APIModel/CardData.dart';
import 'APIModel/Schedulemodel.dart';
import 'SessionDetail.dart';

class SpeakerProfileScreen extends StatefulWidget {
  String name;
  String designation;
  String description;
  SpeakerProfileScreen({required this.name,required this.designation,required this.description});

  @override
  State<SpeakerProfileScreen> createState() => _SpeakerProfileScreenState();
}

class _SpeakerProfileScreenState extends State<SpeakerProfileScreen> {
  ScheduleModel? schedule;
  bool isLoading = true;
  List<CardData> speakerEventList = [];


  @override
  void initState() {
    fetchSchedule();
  }

  Future<void> fetchSchedule() async {
    schedule = await ScheduleAPI.fetchschedule();


    Future.delayed(const Duration(seconds: 1)).then((e) {
      setState(() {
        isLoading = false;
      });
      makerSpeakerList(schedule!);
    });
  }

  void makerSpeakerList(ScheduleModel schedule) {
    if (schedule.data != null) {
      for (var item in schedule.data!) {
        if (item.speakerName == widget.name) {
          speakerEventList.add(item);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        leading: IconButton(
          icon: Semantics(
              label: 'Back',
              child: Icon(Icons.arrow_back, color: Color(0xff000000))),
          onPressed: () {
            Navigator.pop(context);
          },
        ), // Set your desired background color
        title: Container(
          child: Text(
            'Speaker Profile',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff000000),
            ),
          ),
        ),
      ),
      body: isLoading // Show loader while fetching data
          ? Center(
        child: LoadingAnimationWidget.stretchedDots(
          color: Color(0xffB2EFE4),
          size: screenHeight*0.18,
        ),// Show a loader
      ) :SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.28,
              width: screenWidth,
              color: Color(0xffffffff),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/speaker_image.jpg'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.designation,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "About ",
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff000000),
                  height: 24 / 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff777777),
                ),
                textAlign: TextAlign.left,
              ),
            ),


            SizedBox(height: 24),
            Container(
              height: screenHeight*0.5,
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              child: ListView.builder(
                itemCount: speakerEventList.length,
                itemBuilder: (context, index) {
                  final speaker = speakerEventList[index]; // Get the speaker data from the list
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>SessionDetail(title: speaker.eventName??"", date: speaker.eventDate??"", startDate: "", endDate: "", time: speaker.startTime??"", loc: speaker.venueName??"", hash: [""], seats: "", eventid: "", category: speaker.categories??"", subevents: speaker.subEvents?? <dynamic>[]
                            , filename: speaker.filename??"", eventType: speaker.eventType??"", bookingType: speaker.bookingType??"", description:speaker.eventDetails, moderator: speaker.moderator??"",speakerName: speaker.speakerName,dataForHiveStorageAndFurtherUse: speaker,))
                      );

                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              speaker.eventName!,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16),
                                SizedBox(width: 4),
                                Text(speaker.eventDate!),
                                SizedBox(width: 16),
                                Icon(Icons.access_time, size: 16),
                                SizedBox(width: 4),
                                Text(speaker.startTime!),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16),
                                SizedBox(width: 4),
                                Text(speaker.venueName!),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
            // _buildSection(
            //   'Events',
            //   null,
            //   child: _buildEventCard(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String? content, {Widget? child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (content != null) Text(content),
        if (child != null) child,
      ],
    );
  }
}
//
//   Widget _buildEventCard() {
//     return ListView.builder(
//         itemCount: keyNoteDataList.length,
//         itemBuilder: (context, index) {
//         final speaker = keyNoteDataList[index]; // Get the speaker data from the list
//         return Card(
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Tactile Graphics',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Text('Bob Marek, Workshop A'),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, size: 16),
//                     SizedBox(width: 4),
//                     Text('05 Oct 2023'),
//                     SizedBox(width: 16),
//                     Icon(Icons.access_time, size: 16),
//                     SizedBox(width: 4),
//                     Text('2:00pm - 5:00pm'),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(Icons.location_on, size: 16),
//                     SizedBox(width: 4),
//                     Text('TV Lounge'),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//     )
//         }
//
//
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Tactile Graphics',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             Text('Bob Marek, Workshop A'),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, size: 16),
//                 SizedBox(width: 4),
//                 Text('05 Oct 2023'),
//                 SizedBox(width: 16),
//                 Icon(Icons.access_time, size: 16),
//                 SizedBox(width: 4),
//                 Text('2:00pm - 5:00pm'),
//               ],
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.location_on, size: 16),
//                 SizedBox(width: 4),
//                 Text('TV Lounge'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }