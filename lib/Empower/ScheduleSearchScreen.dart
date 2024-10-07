import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'API/ScheduleAPI.dart';
import 'APIModel/CardData.dart';
import 'APIModel/Schedulemodel.dart';
import 'Elements/card.dart';

class ScheduleScreenSearch extends StatefulWidget {
  const ScheduleScreenSearch({super.key});

  @override
  State<ScheduleScreenSearch> createState() => _ScheduleScreenSearchState();
}

class _ScheduleScreenSearchState extends State<ScheduleScreenSearch>{
  ScheduleModel? schedule;
  List<DateTime> days = [];
  HashMap<DateTime, List<CardData>> cards = HashMap();
  List<CardData> searchCards = []; // List to store the filtered cards
  List<Widget> widgetCards = []; // List to store the filtered cards
  bool isLoading = true; // Add this flag for loading state
  bool isSearching = false; // Track if search mode is enabled
  String searchText = ""; // Store the search text




  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
      for (CardData event in schedule.data!) {
        if (event.eventDate != null) {
          DateTime eventDate = DateTime.parse(event.eventDate!);
          uniquedays.add(eventDate);
        }
      }
    }
    setState(() {
      days = uniquedays.toList()..sort();
    });
  }

  void populateCards(ScheduleModel schedule) {
    if (schedule.data != null) {
      for (CardData event in schedule.data!) {
        searchCards.add(event);
        // cards.putIfAbsent(DateTime.parse(event.eventDate!), () => []);
        // cards[DateTime.parse(event.eventDate!)]!.add(event);
      }
    }
    showCard();
  }


  void showCard(){
    print("searchCards.length");
    print(searchCards.length);
    searchCards.forEach((e){
      widgetCards.add(card(e));
    });
    setState(() {

    });
  }

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching; // Toggle search mode
      if (!isSearching) {
        searchText = ""; // Reset search text
        filterCards(""); // Reset the list when search is closed
      }
    });
  }
  void filterCards(String query) {
    // Clear the widgetCards before updating
    widgetCards.clear();

    setState(() {
      // Use a forEach loop to iterate over searchCards
      searchCards.forEach((e) {
        if (e.eventName != null && e.eventName!.toLowerCase().contains(query.toLowerCase())) {
          widgetCards.add(card(e));
        }
      });
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
          title: isSearching
              ? TextField(
            onChanged: (value) {
              searchText = value;
              filterCards(searchText);
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff000000),
              height: 23 / 16,
            ),
          )
              : Text(
            "Schedule Search",
            style: const TextStyle(
              fontFamily: "Roboto",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff000000),
              height: 23 / 16,
            ),
            textAlign: TextAlign.left,
          ),
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: toggleSearch, // Toggle search mode
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
            : Column(
          children: [

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
                        itemCount: widgetCards.length,
                        itemBuilder: (context, index) {
                          return widgetCards[index];
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