

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'API/ScheduleAPI.dart';
import 'APIModel/Schedulemodel.dart';
import 'SpeakerProfileScreen.dart';


class Speakerscreen extends StatefulWidget {
  const Speakerscreen({super.key});

  @override
  State<Speakerscreen> createState() => _SpeakerscreenState();
}

class _SpeakerscreenState extends State<Speakerscreen>{
  ScheduleModel? schedule;
  bool isLoading = true;
  HashMap<DateTime, List<Widget>> cards = HashMap();
  List<Speakers> speakerDataList = [];


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    fetchSchedule();
  }

  Future<void> fetchSchedule() async {
    schedule = await ScheduleAPI.fetchschedule();
    print("schedule");
    print(schedule);


    Future.delayed(const Duration(seconds: 1)).then((e){
      setState(() {
        isLoading = false;
      });
      makerSpeakerList(schedule!);
    });
  }
  void makerSpeakerList(ScheduleModel schedule) {

    if (schedule.speakers != null) {
      print("schedule.speakers.length");
      print(schedule.speakers!.length);
      for (var item in schedule.speakers!) {
        if(item != null){
          speakerDataList.add(item);
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF1FFFE),
          leading: IconButton(
            icon: Semantics(
                label: 'Back',
                child: Icon(Icons.arrow_back, color: Color(0xff000000))),
            onPressed: () {
              Navigator.pop(context);
            },
          ), // Set your desired background color
          title: Text(
            "Speakers",
            style: const TextStyle(
              fontFamily: "Roboto",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff000000),
              height: 23/16,
            ),
            textAlign: TextAlign.left,
          ),
          actions: [
          ],
        ),
       body: isLoading // Show loader while fetching data
           ? Center(
             child: LoadingAnimationWidget.stretchedDots(
               color: Color(0xffB2EFE4),
               size: screenHeight*0.18,
             ),// Show a loader
           ) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Semantics(
               header: true,
               child: Container(
                 margin: EdgeInsets.only(left: 20,top: 20),
                 child: Text(
                   "List of Speaker",
                   style: const TextStyle(
                     fontFamily: "Roboto",
                     fontSize: 18,
                     fontWeight: FontWeight.w700,
                     color: Color(0xff000000),
                     height: 24/18,
                   ),
                   textAlign: TextAlign.left,
                 ),
               ),
             ),
              const SizedBox(height: 20,),
              Expanded(
                child: Semantics(
                  label: "Speakers",
                  header: true,
                  child: ListView.builder(
                    itemCount: speakerDataList.length,
                    itemBuilder: (context, index) {
                      final speaker = speakerDataList[index]; // Get the speaker data from the list
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SpeakerProfileScreen(name: speakerDataList[index].name!,designation: speakerDataList[index].designation!,description: speakerDataList[index].about!, fromCommiteePage: false,)),
                          );

                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xff777777), // Set the border color
                              width: 1.0, // Set the border width
                            ),
                            borderRadius: BorderRadius.circular(4), // Set the border radius
                          ),

                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xffB2EFE4),
                                backgroundImage: NetworkImage(speaker.filename??""), // Use speaker's image URL
                              ),
                              VerticalDivider(
                                width: 20, // Space between the widgets
                                thickness: 3, // Thickness of the divider
                                color: Colors.black, // Color of the divider
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      speaker.name??"",
                                      style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff000000),
                                        height: 23/16,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 2,),
                                    Text(
                                      speaker.designation??"",
                                      style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff0e0d0d),
                                        height: 20/14,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    // SizedBox(height: 2,),
                                    //
                                    // Text(
                                    //   speaker.,
                                    //   style: const TextStyle(
                                    //     fontFamily: "Roboto",
                                    //     fontSize: 14,
                                    //     fontWeight: FontWeight.w400,
                                    //     color: Color(0xff777777),
                                    //     height: 20/14,
                                    //   ),
                                    //   textAlign: TextAlign.left,
                                    // ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )


            ],

       ),
      ),
    );
  }

}