import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'API/ScheduleAPI.dart';
import 'APIModel/CardData.dart';
import 'APIModel/Schedulemodel.dart';
import 'Elements/DaySelection.dart';
import 'Elements/card.dart';
import 'ScheduleSearchScreen.dart';


class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  ScheduleModel? schedule;
  List<DateTime> days = [];
  HashMap<DateTime, List<Widget>> cards = HashMap();

  late TabController tabBarController;
  List<Widget> currentCards = []; // List to store the filtered cards
  HashMap<String, List<Widget>> currentMap = HashMap(); // List to store the filtered cards
  bool isLoading = true; // Add this flag for loading state

  List<CardData> allEventData = [];
  HashMap<DateTime, HashMap<String,List<Widget>>> finalMap = HashMap();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    tabBarController = TabController(length: 2, vsync: this);
    fetchSchedule();
    super.initState();
  }

  Future<void> fetchSchedule() async {
    schedule = await ScheduleAPI.fetchschedule();
    makeDatesWidget(schedule!);
    populateCards(schedule!);
    Future.delayed(const Duration(seconds: 1)).then((e){
      setState(() {
        isLoading=false;
      });
    });
  }

  void getThemes(ScheduleModel schedule){
    if(schedule.themesAndSessions != null){
      List<ThemesAndSessions> themeAndSession = schedule.themesAndSessions!;
      print("themeAndSession");
      print(themeAndSession);
      HashMap<String,List<Widget>> themeMap = HashMap();
      for (var currentTheme in themeAndSession){
        List<Widget> themenEvents = [];
        DateTime currentKey = DateTime.now();
        if(themeMap.containsKey(currentTheme.themeName)){
          themeMap.putIfAbsent(currentTheme.themeName!,()=>[]);
        }else {
          print("currentTheme.eventIds");
          print(currentTheme.eventIds);
          currentTheme.eventIds!.forEach((E) {
            schedule.data!.forEach((event) {
              if (event.sId == E) {
                currentKey = DateTime.parse(event.eventDate!);
                themenEvents.add(card(event));
                print("Found ${currentKey}");
              }else{

              }
            });
          });
        }

        themeMap[currentTheme.themeName!] = themenEvents;
        finalMap[currentKey] = themeMap;
      }
      print("finalMap.keys");
      print(finalMap.keys);
      print(finalMap.values);

    }else{
      print("themenull");
    }

  }

  void makeDatesWidget(ScheduleModel schedule) {
    Set<DateTime> uniquedays = Set();
    if (schedule.data != null) {
      for (CardData event in schedule.data!) {
        if (event.eventDate != null) {
          DateTime eventDate = DateTime.parse(event.eventDate!);
          uniquedays.add(eventDate);
        }
        // if (event.subEvents != null) {
        //   for (var subEvent in event.subEvents!) {
        //     if (subEvent. != null) {
        //       DateTime subEventDate = DateTime.parse(subEvent.date!);
        //       uniquedays.add(subEventDate);
        //     }
        //   }
        // }
      }
    }
    setState(() {
      days = uniquedays.toList()..sort();
    });
  }

  void populateCards(ScheduleModel schedule) {
    if (schedule.data != null) {
      for (CardData event in schedule.data!) {
        cards.putIfAbsent(DateTime.parse(event.eventDate!), () => []);
        cards[DateTime.parse(event.eventDate!)]!.add(card(event));
        allEventData.add(event);
      }
      print("allEventData.length");
      print(allEventData.length);
    }
    getThemes(schedule);
    filterCardsForDay(0); // Load the first day by default
  }

  void filterCardsForDay(int selectedIndex) {
    DateTime selectedDay = days[selectedIndex];
    setState(() {
      if(finalMap[selectedDay] != null) {
        currentMap = finalMap[selectedDay]!;
      }else{
        currentMap = HashMap();
      }
      currentCards = cards[selectedDay] ?? [];

    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<String> keys = currentMap.keys.toList();


    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
            "Schedule",
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
            IconButton(
              icon: Semantics(
                label: 'Search Events',
                  child: Icon(Icons.search)),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScheduleScreenSearch()),
                );
              }, // Toggle search mode
            ),
          ],
        ),
        body: isLoading // Show loader while fetching data
            ? Center(
                child: LoadingAnimationWidget.stretchedDots(
                  color: Color(0xffB2EFE4),
                  size: screenHeight*0.2,
                ),// Show a loader
              )
            : SingleChildScrollView(
              child: Column(
                  children: [
                    Semantics(
                      label: "Session Dates",
                      header: true,
                        child: DaySelection(days, onDateSelected: filterCardsForDay)),
                    Semantics(
                      label: "Session Events",
                      header: true,
                      child: Container(
                        height: screenHeight*0.8,
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // InkWell(
                            //   onTap: () {},
                            //   child: Semantics(
                            //     label: 'Filter',
                            //     child: SvgPicture.asset("assets/filter.svg"),
                            //   ),
                            // ),

                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                                child: ListView.builder(
                                  itemCount: keys.length, // Number of keys (categories)
                                  itemBuilder: (context, index) {
                                    String key = keys[keys.length-index-1];          // Get the current key (category)
                                    List<Widget> widgets = currentMap[key] ?? [];  // Get the widgets for the current key

                                    // Create a column that shows the key (as text) and the widgets below it
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(

                                          padding: const EdgeInsets.all(8.0),
                                          margin:EdgeInsets.only(top: 10),
                                          child: Text(
                                            key,  // Render the key (category name)
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Column(
                                          children: widgets, // Render the list of widgets under the key
                                        ),
                                          // Optional divider between categories
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 400,
                    //   color: Colors.teal,
                    //   child: Expanded(
                    //     child: AnimatedSwitcher(
                    //       duration: const Duration(milliseconds: 500),
                    //       transitionBuilder: (Widget child,
                    //           Animation<double> animation) {
                    //         return FadeTransition(
                    //             opacity: animation, child: child);
                    //       },
                    //       child: ListView.builder(
                    //         itemCount: keys.length, // Number of keys (categories)
                    //         itemBuilder: (context, index) {
                    //           String key = keys[index];          // Get the current key (category)
                    //           List<Widget> widgets = currentMap[key] ?? [];  // Get the widgets for the current key
                    //
                    //           // Create a column that shows the key (as text) and the widgets below it
                    //           return Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Text(
                    //                   key,  // Render the key (category name)
                    //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    //                 ),
                    //               ),
                    //               Column(
                    //                 children: widgets, // Render the list of widgets under the key
                    //               ),
                    //               Divider(),  // Optional divider between categories
                    //             ],
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // TabBar(
                    //   controller: tabBarController,
                    //   tabs: const [
                    //     Tab(text: 'Ongoing'),
                    //     Tab(text: 'My favourite'),
                    //   ],
                    //   indicatorColor: Colors.yellow,
                    //   indicatorSize: TabBarIndicatorSize.tab,
                    // ),
                    // Expanded(
                    //   child: TabBarView(
                    //     controller: tabBarController,
                    //     children: [
                    //
                    //       Container(
                    //         color: Colors.red,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
            ),
      ),
    );
  }
}
