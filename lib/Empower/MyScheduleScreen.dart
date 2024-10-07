import 'package:empower/Empower/Elements/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'API/ScheduleAPI.dart';
import 'APIModel/Schedulemodel.dart';


class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen>{
  ScheduleModel? schedule;
  bool isLoading = true;
  List<Widget> bookmarkedListWidget = [];


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    fetchSchedule();
  }
  static var testBox = Hive.box('testingSave');

  Future<void> fetchSchedule() async {
    schedule = await ScheduleAPI.fetchschedule();

    testBox.keys.forEach((currentValue){
      for(var currentScheduleData in schedule!.data!){
        if(currentScheduleData.sId == currentValue){
          bookmarkedListWidget.add(card(currentScheduleData));
          setState(() {
          });
        }
      }
    });


    Future.delayed(const Duration(seconds: 1)).then((e){
      setState(() {
        isLoading = false;
      });

    });
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
            "My Schedule",
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
            Container(
              margin: EdgeInsets.only(left: 20,top: 20),
              child: Semantics(
                header: true,
                child: Text(
                  "List of Bookmarked Events",
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 3500),
                transitionBuilder: (Widget child,
                    Animation<double> animation) {
                  return FadeTransition(
                      opacity: animation, child: child);
                },
                child: ListView.builder(
                  key: ValueKey<List<Widget>>(bookmarkedListWidget),
                      itemCount: bookmarkedListWidget.length,
                      itemBuilder: (context, index) {
                        return bookmarkedListWidget[index];
                      },
                    ),
                  )
            )


          ],

        ),
      ),
    );
  }

}