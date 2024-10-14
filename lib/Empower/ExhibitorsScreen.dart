

import 'dart:collection';

import 'package:empower/Empower/IndivisualExhibitor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../Navigation/Elements/HelperClass.dart';
import 'API/ScheduleAPI.dart';
import 'APIModel/CardData.dart';
import 'APIModel/Schedulemodel.dart';


class ExhibitorsScreen extends StatefulWidget {
  const ExhibitorsScreen({super.key});

  @override
  State<ExhibitorsScreen> createState() => _ExhibitorsScreenState();
}

class _ExhibitorsScreenState extends State<ExhibitorsScreen>{
  ScheduleModel? schedule;
  bool isLoading = true;
  HashMap<DateTime, List<Widget>> cards = HashMap();
  List<Exhibitors> keyNoteDataList = [];
  final FocusNode _focusNode = FocusNode();
  String searchText = "";




  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    fetchSchedule();
  }

  Future<void> fetchSchedule() async {
    schedule = await ScheduleAPI.fetchschedule();


    Future.delayed(const Duration(seconds: 1)).then((e){
      setState(() {
        isLoading = false;
      });
      makerExhibitorList(schedule!);
    });
  }
  void makerExhibitorList(ScheduleModel schedule) {
    if (schedule.data != null) {
      for (var item in schedule.exhibitors!) {
        print(item.companyName);
          keyNoteDataList.add(item);
      }
    }
  }

  void filterCards(String query) {
    // Clear the widgetCards before updating
    keyNoteDataList.clear();

    setState(() {
      // Use a forEach loop to iterate over searchCards
      schedule!.exhibitors!.forEach((e) {
        if (e.companyName != null && e.companyName!.toLowerCase().contains(query.toLowerCase())) {
          keyNoteDataList.add(e);
        }
      });
    });
  }

  bool isSearching = false;

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching; // Toggle search mode
      if (!isSearching) {
        searchText = ""; // Reset search text
        filterCards(""); // Reset the list when search is closed
      }else{
        _focusNode.requestFocus();
      }
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
          title: isSearching
              ? TextField(
            focusNode: _focusNode,
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
              : Semantics(
                label: 'Exhibitors Screen',
                excludeSemantics: true,
                child: Text(
                            "Exhibitors",
                            style: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff000000),
                height: 23 / 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
              ),
          actions: [
            IconButton(
              icon: Semantics(
                  label: !isSearching? 'Search Exhibitors': 'Close text input',

                excludeSemantics: true,
                  child: Icon(isSearching ? Icons.close : Icons.search)),
              onPressed: toggleSearch, // Toggle search mode
            ),
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
                  "List of Exhibitors",
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
                label: "Exhibitors",
                header: true,
                child: ListView.builder(
                  itemCount: keyNoteDataList.length,
                  itemBuilder: (context, index) {
                    final exhibitor = keyNoteDataList[index]; // Get the speaker data from the list
                    return (exhibitor.companyName!=null)? Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => IndivisualExhibitor(name: exhibitor.companyName??"", designation: exhibitor.website??"", description: exhibitor.about??"", fromCommiteePage: false, fileName: exhibitor.filename, linkedin: exhibitor.linkedIn, venueId: exhibitor.venueId,)
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage('assets/speaker_image.jpg'),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (exhibitor.companyName==null)?'':exhibitor.companyName!, // Use speaker's name
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    (exhibitor.website==null)?Container():Text(
                                      (exhibitor.website==null)?'' :exhibitor.website!, // Use speaker's organization
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      "Booth No. ${(exhibitor.boothNo==null)?'':exhibitor.boothNo!}", // Use speaker's location
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ) : Container();
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