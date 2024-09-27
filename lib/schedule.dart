import 'dart:collection';

import 'package:empower/elements/DaySelection.dart';
import 'package:empower/elements/card.dart';
import 'package:empower/scheduleSearchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'api/scheduleapi.dart';
import 'apimodels/schedulemodel.dart';
import 'elements/dayWidget.dart';

class schedule extends StatefulWidget {
  const schedule({super.key});

  @override
  State<schedule> createState() => _scheduleState();
}

class _scheduleState extends State<schedule> with SingleTickerProviderStateMixin{
  scheduleModel? schedule;
  List<DateTime> days = [];
  HashMap<DateTime,List<Widget>> cards = HashMap();
  late TabController tabBarController;


  @override
  void initState() {
    // TODO: implement initState
    tabBarController = TabController(length: 2, vsync: this);
    fetchSchedule();
    super.initState();
  }

  Future<void> fetchSchedule() async {
    schedule = await scheduleapi.fetchschedule();
    makeDatesWidget(schedule!);
    populateCards(schedule!);
  }

  void makeDatesWidget(scheduleModel schedule){
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

  void populateCards(scheduleModel schedule){
    if(schedule.data != null){
      for(Data event in schedule.data!){
        cards.putIfAbsent(DateTime.parse(event.eventDate!), ()=>[]);
        cards[DateTime.parse(event.eventDate!)]!.add(card(event));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              scheduleSearchBar(),
              DaySelection(days),
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
                          SingleChildScrollView(
                            child: Column(
                              children: cards,
                            ),
                          )
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
