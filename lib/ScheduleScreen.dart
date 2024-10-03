import 'dart:collection';

import 'package:empower/elements/DaySelection.dart';
import 'package:empower/elements/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'api/ScheduleAPI.dart';
import 'apimodels/Schedulemodel.dart';
import 'elements/dayWidget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin{
  ScheduleModel? schedule;
  List<DateTime> days = [];
  HashMap<DateTime,List<Widget>> cards = HashMap();
  late TabController tabBarController;
  List<Widget> currentCards = []; // List to store the filtered cards



  @override
  void initState() {
    tabBarController = TabController(length: 2, vsync: this);
    fetchSchedule();
    super.initState();
  }

  Future<void> fetchSchedule() async {
    schedule = await ScheduleAPI.fetchschedule();
    makeDatesWidget(schedule!);
    populateCards(schedule!);
  }

  void makeDatesWidget(ScheduleModel schedule){
    Set<DateTime> uniquedays = Set();
    if (schedule.data != null) {
      for (Data event in schedule.data!) {
        if (event.eventDate != null) {
          DateTime eventDate = DateTime.parse(event.eventDate!);
          uniquedays.add(eventDate);
        }
        // If sub-events also need to be considered:
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

  void populateCards(ScheduleModel schedule){
    if(schedule.data != null){
      for(Data event in schedule.data!){
        cards.putIfAbsent(DateTime.parse(event.eventDate!), ()=>[]);
        cards[DateTime.parse(event.eventDate!)]!.add(card(event));
      }
    }
    filterCardsForDay(days.length-(days.length-1));
  }
  // Method to filter cards for the selected day
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
        appBar: AppBar(
          title: Text(
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
          centerTitle: true,
          backgroundColor:Color(0xff48246C),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.search,color: Colors.white,))
          ],
        ),
        body: Container(
          child: Column(
            children: [
              DaySelection(days, onDateSelected: filterCardsForDay),
              TabBar(
                controller: tabBarController,
                tabs: const [
                  Tab(text: 'Ongoing'), // First tab heading
                  Tab(text: 'My favourite'), // Second tab heading
                ],
                indicatorColor: Colors.yellow,
                indicatorSize: TabBarIndicatorSize.tab,// Customize the indicator color
              ),
              Expanded(
                child: TabBarView(
                  controller: tabBarController,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20,top: 20,right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Semantics(
                              // Provide a label for accessibility
                              label: 'Filter',
                              child: Container(
                                child: SvgPicture.asset("assets/filter.svg"),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          const SizedBox(height: 20),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500), // Animation duration
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return FadeTransition(opacity: animation, child: child); // Fade transition
                              },
                              child: ListView.builder(
                                key: ValueKey<List<Widget>>(currentCards), // Unique key for changes
                                itemCount: currentCards.length,
                                itemBuilder: (context, index) {
                                  return currentCards[index]; // Display cards
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.red,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
