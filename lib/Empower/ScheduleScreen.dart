import 'dart:collection';

import 'package:empower/Empower/Elements/MainScreenController.dart';
import 'package:empower/Empower/MainScreen.dart';
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
  List<String> keys = []; // Declare this at the class level


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
      HashSet<String> eventsWithThemes = HashSet(); // To track events that are part of a theme

      for (var currentTheme in themeAndSession){
        HashMap<String,List<Widget>> themeMap = HashMap();
        List<Widget> themenEvents = [];

        if (currentTheme.eventIds != null) {
          currentTheme.eventIds!.forEach((eventId) {
            schedule.data!.forEach((event) {
              if (event.sId == eventId) {
                themenEvents.add(card(event));
                eventsWithThemes.add(event.sId!); // Add event ID to the set
              }
            });
          });
        }

        themeMap[currentTheme.themeName!] = themenEvents;
        DateTime themeDate = DateTime.parse(currentTheme.dates![0]);
        if (finalMap.containsKey(themeDate)) {
          finalMap[themeDate]![currentTheme.themeName!] = themenEvents;
        } else {
          finalMap[themeDate] = themeMap;
        }
      }

      // Process events without themes
      List<Widget> eventsWithoutThemes = [];
      for (var event in schedule.data!) {
        if (!eventsWithThemes.contains(event.sId)) {
          eventsWithoutThemes.add(card(event));
        }
      }

      if (eventsWithoutThemes.isNotEmpty) {
        for (DateTime date in days) {
          if (finalMap.containsKey(date)) {
            finalMap[date]!['Open Events'] = eventsWithoutThemes;
          } else {
            finalMap[date] = HashMap<String, List<Widget>>()..putIfAbsent('Open Events', () => eventsWithoutThemes);
          }
        }
      }
    } else {
      print("No themes found");
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
      }
    }
    setState(() {
      days = uniquedays.toList()..sort();
    });
  }

  void populateCards(ScheduleModel schedule) {
    if (schedule.data != null) {
      schedule.data!.sort((a, b) {
        DateTime dateA = DateTime.parse(a.eventDate!);
        DateTime dateB = DateTime.parse(b.eventDate!);

        // If the eventDate is the same, compare the startTime
        if (dateA.compareTo(dateB) == 0) {
          // Compare start times if eventDate is the same
          TimeOfDay timeA = TimeOfDay(
            hour: int.parse(a.startTime!.split(':')[0]),
            minute: int.parse(a.startTime!.split(':')[1]),
          );
          TimeOfDay timeB = TimeOfDay(
            hour: int.parse(b.startTime!.split(':')[0]),
            minute: int.parse(b.startTime!.split(':')[1]),
          );
          return timeA.hour == timeB.hour
              ? timeA.minute.compareTo(timeB.minute)
              : timeA.hour.compareTo(timeB.hour);
        }

        // Compare event dates
        return dateA.compareTo(dateB);
      });
      for (CardData event in schedule.data!) {
        DateTime eventDate = DateTime.parse(event.eventDate!);
        cards.putIfAbsent(eventDate, () => []);
        cards[eventDate]!.add(card(event));
        allEventData.add(event);
      }
      getThemes(schedule); // Call getThemes to process events with and without themes
      filterCardsForDay(0); // Load the first day by default
    }
  }

  void filterCardsForDay(int selectedIndex) {
    DateTime selectedDay = days[selectedIndex];

    setState(() {
      if(finalMap[selectedDay] != null) {
        currentMap = finalMap[selectedDay]!;

        // Sort the keys (theme names) based on the number in the theme name
        List<String> sortedKeys = currentMap.keys.toList()
          ..sort((a, b) {
            // Extract numbers from the theme names and sort based on that
            int extractNumber(String themeName) {
              final match = RegExp(r'\d+').firstMatch(themeName);
              print("returning ${match != null ? int.parse(match.group(0)!) : 0} for $themeName");
              return match != null ? int.parse(match.group(0)!) : 0;
            }

            return extractNumber(a).compareTo(extractNumber(b));
          });
        print("sortedKeys $sortedKeys");

        // Update state variable 'keys' with sorted list
        keys = sortedKeys;
      } else {
        currentMap = HashMap();
        keys = [];
      }

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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 0,)),
              );
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
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10,bottom: 10),
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
                                  itemCount: keys.length,
                                  itemBuilder: (context, index) {
                                    String key = keys[index];  // Use the sorted keys
                                    List<Widget> widgets = currentMap[key] ?? []; // Get the widgets for the current key

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                            color: Color(0xffEBEBEB),
                                            border: Border.all(color: Color(0xff777777), width: 0.5),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            key,  // Render the sorted key (theme name)
                                            style: const TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff000000),
                                              height: 23/16,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: widgets, // Render the list of widgets under the key
                                        ),
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
                  ],
                ),
            ),
      ),
    );
  }
}
