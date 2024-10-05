import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'API/ScheduleAPI.dart';
import 'APIModel/Schedulemodel.dart';
import 'Elements/DaySelection.dart';
import 'Elements/card.dart';


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
  bool isLoading = true; // Add this flag for loading state

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

  void makeDatesWidget(ScheduleModel schedule) {
    Set<DateTime> uniquedays = Set();
    if (schedule.data != null) {
      for (Data event in schedule.data!) {
        if (event.eventDate != null) {
          DateTime eventDate = DateTime.parse(event.eventDate!);
          uniquedays.add(eventDate);
        }
        if (event.subEvents != null) {
          for (SubEvents subEvent in event.subEvents!) {
            if (subEvent.date != null) {
              DateTime subEventDate = DateTime.parse(subEvent.date!);
              uniquedays.add(subEventDate);
            }
          }
        }
      }
    }
    setState(() {
      days = uniquedays.toList()..sort();
    });
  }

  void populateCards(ScheduleModel schedule) {
    if (schedule.data != null) {
      for (Data event in schedule.data!) {
        cards.putIfAbsent(DateTime.parse(event.eventDate!), () => []);
        cards[DateTime.parse(event.eventDate!)]!.add(card(event));
      }
    }
    filterCardsForDay(0); // Load the first day by default
  }

  void filterCardsForDay(int selectedIndex) {
    DateTime selectedDay = days[selectedIndex];
    setState(() {
      currentCards = cards[selectedDay] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
          ],
        ),
        body: isLoading // Show loader while fetching data
            ? Center(
                child: LoadingAnimationWidget.stretchedDots(
                  color: Color(0xffB2EFE4),
                  size: screenHeight*0.2,
                ),// Show a loader
              )
            : Column(
                children: [
                  DaySelection(days, onDateSelected: filterCardsForDay),
                  Container(
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
                              key: ValueKey<List<Widget>>(currentCards),
                              itemCount: currentCards.length,
                              itemBuilder: (context, index) {
                                return currentCards[index];
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
    );
  }
}
