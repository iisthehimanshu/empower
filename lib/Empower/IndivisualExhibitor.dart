import 'package:empower/Navigation/Elements/HelperClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../Navigation/Navigation.dart';
import 'API/ScheduleAPI.dart';
import 'APIModel/CardData.dart';
import 'APIModel/Schedulemodel.dart';
import 'SessionDetail.dart';

class IndivisualExhibitor extends StatefulWidget {
  String name;
  String designation;
  String description;
  bool fromCommiteePage;
  String speakerID;
  String? fileName;
  String? linkedin;
  String? venueId;
  IndivisualExhibitor({required this.name,required this.designation,required this.description,required this.fromCommiteePage,required this.fileName, required this.linkedin, required this.venueId, this.speakerID= ''});

  @override
  State<IndivisualExhibitor> createState() => _IndivisualExhibitorState();
}

class _IndivisualExhibitorState extends State<IndivisualExhibitor> {
  ScheduleModel? schedule;
  bool isLoading = true;
  List<CardData> speakerEventList = [];
  String localname = '';
  String localdesignation='';
  String localdescription='';


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
      if(widget.speakerID!=""){
        print("YESSSSSSSSSS");
        for (var item in schedule!.speakers!) {
          if(item.sId == widget.speakerID){
            localname = item.name!;
            localdesignation = item.designation!;
            localdescription = item.about!;
          }
        }
      }
      makerSpeakerList(schedule!);
    });

    print(localname);
  }

  void makerSpeakerList(ScheduleModel schedule) {
    if (schedule.data != null) {
      for (var item in schedule.data!) {
        if(widget.speakerID!=""){
          if (item.speakerName == localname) {
            speakerEventList.add(item);
          }
        }else {
          if (item.speakerName == widget.name) {
            speakerEventList.add(item);
          }
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
            'Exhibitor',
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
              padding: EdgeInsets.only(bottom: 24),
              width: screenWidth,
              color: Color(0xffffffff),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.fileName==null?CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/speaker_image.jpg'),
                  ):GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: CircleAvatar(
                                radius: 150, // Larger size for the pop out image
                                backgroundColor: Color(0xffB2EFE4),
                                backgroundImage: NetworkImage("https://maps.iwayplus.in/uploads/${widget.fileName}"),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xffB2EFE4),
                      backgroundImage: NetworkImage("https://maps.iwayplus.in/uploads/${widget.fileName}"),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.speakerID!=""? localname : widget.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: (){
                      HelperClass.launchURL(widget.speakerID!=""? localdesignation : widget.designation);
                    },
                    child: Text(
                      widget.speakerID!=""? localdesignation : widget.designation,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
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
                widget.speakerID!=""? localdescription : widget.description,
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
            (widget.linkedin != null && widget.linkedin!.isNotEmpty)?InkWell(
              onTap: (){
                HelperClass.launchURL(widget.linkedin!);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                      width: 24,
                      margin: EdgeInsets.only(left: 22),
                      child: SvgPicture.asset("assets/linkedin.svg")),
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 20),
                    child: Text(
                      HelperClass.truncateString(widget.linkedin!, 35),
                      style: const TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff777777),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ):Container(),


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
                          MaterialPageRoute(builder: (context)=>SessionDetail(title: speaker.eventName??"", date: speaker.eventDate??"", startDate: "", endDate: "", time: speaker.startTime??"", loc: speaker.venueName??"", hash: [""], seats: "", eventid: speaker.sId??"", category: speaker.categories??"", subevents: speaker.subEvents?? <dynamic>[]
                            , filename: speaker.filename??"", eventType: speaker.eventType??"", bookingType: speaker.bookingType??"", description:speaker.eventDetails, moderator: speaker.moderator??"",speakerName: speaker.speakerName,speakerID: speaker.speakerId,dataForHiveStorageAndFurtherUse: speaker, venueId: speaker.venueId,))
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
            ),
            // _buildSection(
            //   'Events',
            //   null,
            //   child: _buildEventCard(),
            // ),
            (widget.venueId == null || widget.venueId!.isEmpty) ?Container():ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffECC113), // Button background color
                fixedSize: Size(screenWidth, 72), // Width and height
                padding: const EdgeInsets.only(bottom: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Square borders
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Navigation(directLandID: widget.venueId!,),
                  ),
                );
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Direction",
                      style: const TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff171717),
                      ),
                    ),
                    Icon(Icons.turn_right_outlined, color: Color(0xff171717)), // Icon color
                  ],
                ),
              ),
            )
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