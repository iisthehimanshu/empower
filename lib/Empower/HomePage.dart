
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:empower/Empower/CommiteeScreen.dart';
import 'package:empower/Empower/SpeakerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';

import 'package:shared_preferences/shared_preferences.dart';


import 'package:url_launcher/url_launcher.dart';

import '../Navigation/Navigation.dart';
import '../NotificationScreen.dart';
import 'Elements/ImageSlider.dart';
import 'ExhibitorsScreen.dart';
import 'MyScheduleScreen.dart';
import 'ScheduleScreen.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  List<String> images = [
    'https://www.empower24.in/img/empower%202024.png'

  ];
  List<String> imagesSemantic = [
    'Corousal Image'
  ];



  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20,left: 20,bottom: 10),
                      child: Semantics(
                        label: "Empower 2024",
                          excludeSemantics: true,
                          child: Image.asset("assets/download.png",scale: 4,)
                      )
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.notifications_none_outlined),
                    color: Color(0xff18181b),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              InkWell(
                onTap: () {

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> ScheduleScreen()));

                },
                child: Semantics(
                  child: Container(
                    width: screenWidth,
                    margin: EdgeInsets.only(bottom: 4),
                    // height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xffffffff),
                            Color(0xffffffff)
                          ],
                          stops: [0.1, 0.1]
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 12, 0, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: screenWidth - 40,
                            height: screenHeight*0.045,
                            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: Color(0xffbdbdbd)),
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  // BoxShadow(
                                  //     color: Colors.black26,
                                  //     offset: Offset.zero,
                                  //     spreadRadius: 0,
                                  //     blurRadius: 4,
                                  //     blurStyle: BlurStyle.outer)
                                ]
                              //borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 11),
                                  child: Icon(
                                    Icons.search,
                                    size: 26,
                                    color: Color(0xffB3B3B3),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 8),
                                    child: Text(
                                      "Search ",
                                      style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xffbdbdbd),
                                        height: 23/14,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                // Container(
                                //     margin: EdgeInsets.only(right: 9),
                                //     child: Icon(Icons.mic_none_outlined,
                                //         size: 25,
                                //         color: Color(0xffBDBDBD))),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              Expanded(
                child: SingleChildScrollView(

                  child: Column(
                    children: [
                      ImageSlider(images: images,imagesSemantics: imagesSemantic,),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Semantics(
                          header: true,
                          child: Text(
                            "Explore",
                            style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff242222),
                              height: 26/20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                        child: Semantics(
                          header: true,
                          child: Wrap(
                            runSpacing: 30,
                            spacing: 30,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Navigation()));
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset('assets/HomePage_Navigation.svg'),
                                    Text(
                                      "Navigation",
                                      style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff000000),
                                        height: 18/12,
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ScheduleScreen()));
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset('assets/HomePage_Eventagenda.svg'),
                                    Text(
                                      "Schedule",
                                      style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff000000),
                                        height: 18/12,
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyScheduleScreen()));
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset('assets/HomePage_Myschedule.svg'),
                                    Text(
                                      "My schedule",
                                      style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff000000),
                                        height: 18/12,
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Speakerscreen()));

                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset('assets/HomePage_Speaker.svg'),
                                    Text(
                                      "Speaker",
                                      style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff000000),
                                        height: 18/12,
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Commiteescreen()));
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset('assets/HomePage_ProgramCommitee.svg'),
                                    Text(
                                      "Commitee",
                                      style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff000000),
                                        height: 18/12,
                                      ),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ExhibitorsScreen()));
                                  },
                                  child: Column(
                                    children: [
                                      SvgPicture.asset('assets/HomePage_Exhibitor.svg',height: 32,),
                                      Text(
                                        "Exhibitors",
                                        style: const TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff000000),
                                          height: 18/12,
                                        ),
                                        textAlign: TextAlign.left,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white12, // Divider color
                        thickness: 10, // Divider thickness
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20,top: 20),
                        child: Semantics(
                          header: true,
                          child: Text(
                            "Sponsors",
                            style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff242222),
                              height: 26/20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                          child: Row(
                            children: [
                              Semantics(
                                  label: "Google",
                                  excludeSemantics: true,
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Image.asset("assets/HomePage_google_logo.png",scale: 30,))
                              ),
                              Semantics(
                                  label: "Microsoft",
                                  excludeSemantics: true,
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Image.asset("assets/HomePage_microsoftLogo.png",scale: 5,))),
                              Semantics(
                                  label: "Global Disability Innovation Hub",
                                  excludeSemantics: true,
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20),

                                      child: Image.asset("assets/sponsor1.jpg",scale: 8,))),
                              Semantics(
                                  label: "National Centre for Promotion of Employment for Disabled People",
                                  excludeSemantics: true,
                                  child: Container(
                                      margin: EdgeInsets.only(left: 20,top: 10,right: 20),

                                      child: Image.asset("assets/sponsor2.png",scale: 15,)))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20,top: 20),
                        child: Semantics(
                          header: true,
                          child: Text(
                            "Organizers",
                            style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff242222),
                              height: 26/20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal, // Enable horizontal scrolling

                          child: Row(
                            children: [
                              Semantics(
                                  label: "IIIT Bangalore",
                                  excludeSemantics: true,
                                  child: Container(
                                      margin: EdgeInsets.only(left: 5),

                                      child: Container(
                                          margin: EdgeInsets.only(left: 5),

                                          child: Image.asset("assets/organizer1.png",scale: 10,)))),
                              Semantics(
                                  label: "Social Justice Department",
                                  excludeSemantics: true,
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10),

                                      child: Image.asset("assets/organizer2.png",scale: 1.5,))),

                              Semantics(
                                  label: "NISH",
                                  excludeSemantics: true,
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10,right: 20),

                                      child: Image.asset("assets/organizer3.png",scale: 6,))),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20,top: 20),
                        child: Semantics(
                          header: true,
                          child: Text(
                            "Partners",
                            style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff242222),
                              height: 26/20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Semantics(
                                label: "WHO",
                                excludeSemantics: true,
                                child: Image.asset("assets/HomePage_WorldHealthORG.png",scale: 2.5,)),
                            Semantics(
                                label: "KMTC",
                                excludeSemantics: true,
                                child: Image.asset("assets/partner2.jpg",scale: 8,)),
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 20,top: 20),
                        child: Semantics(
                          header: true,
                          child: Text(
                            "Information",
                            style: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff242222),
                              height: 26/20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),

                      Semantics(
                        label:'Venue Information',
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                label: '',
                                child: Container(
                                  margin: EdgeInsets.only(left: 14,top: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        //  margin: EdgeInsets.only(right: 16),
                                        width: 24,
                                        height: 24,
                                        child: SvgPicture.asset(
                                          'assets/HomePage_calendar.svg',
                                          width: 24,
                                          height: 24,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(maxWidth: screenWidth - 88),
                                        margin: EdgeInsets.only(top: 4,left: 12),
                                        child: Text(
                                          "Oct 17th - 19th",
                                          style: const TextStyle(
                                            fontFamily: "Roboto",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff777777),
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black12,
                                indent: screenWidth*0.02,
                              ),
                              Semantics(
                                label:'',
                                child: Container(
                                  margin: EdgeInsets.only(left: 14,top: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        //  margin: EdgeInsets.only(right: 16),
                                        width: 24,
                                        height: 24,
                                        child: SvgPicture.asset(
                                          'assets/HomePage_location_on.svg',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only( right: 14,left: 12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(maxWidth: screenWidth*0.7),
                                              child: Text(
                                                "National Institute of Speech and Hearing, 4/564 NISH Road Thiruvananthapuram, Kerala, 695017, India",
                                                style: const TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff777777),
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black12,
                                indent: screenWidth*0.02,
                              ),
                              Semantics(
                                label:'',
                                child: Container(
                                  margin: EdgeInsets.only(left: 14,top: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        //  margin: EdgeInsets.only(right: 16),
                                        width: 24,
                                        height: 24,
                                        child: SvgPicture.asset(
                                          'assets/HomePage_call.svg',
                                          width: 24,
                                          height: 24,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 14,left: 12),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 4),
                                              constraints: BoxConstraints(maxWidth: screenWidth - 88),
                                              child: Text(
                                                "+91-4712944666",
                                                style: const TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff777777),
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black12,
                                indent: screenWidth*0.02,
                              ),
                              Semantics(
                                label:'',
                                child: Container(
                                  margin: EdgeInsets.only(left: 14,top: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        //  margin: EdgeInsets.only(right: 16),
                                        width: 24,
                                        height: 24,
                                        child: SvgPicture.asset(
                                          'assets/HomePage_mail.svg',
                                          width: 24,
                                          height: 24,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(maxWidth: screenWidth - 88),
                                              child: Text(
                                                "empower2024@nish.ac.in",
                                                style: const TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff777777),
                                                  height: 20/14,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),

                                          ],
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
                    ],
                  ),
                ),
              )


            ],
          )



      ),
    );
  }
}

//
// class ImageSlider extends StatefulWidget {
//   late List<String> images;
//   late List<String> imagesSemantics;
//
//
//   ImageSlider({required this.images, required this.imagesSemantics});
//   @override
//   _ImageSliderState createState() => _ImageSliderState();
// }
//
// class _ImageSliderState extends State<ImageSlider> {
//   int _currentImageIndex = 0;
//   int _ImageIndex = 0;
//
//
//   // List<String>? images = [
//   //   //'https://maps.iwayplus.in/uploads/Frame%20471.png',
//   //   // 'https://purplefest.goa.gov.in/wp-content/uploads/2023/10/SLIDER_PURPLE_FEST_INAUGRAL.jpg',
//   //   // 'https://purplefest.goa.gov.in/wp-content/uploads/2023/09/Gallery_1.jpg',
//   //   // 'https://maps.iwayplus.in/uploads/Gallery_13.jpg',
//   //   // 'https://purplefest.goa.gov.in/wp-content/uploads/2023/09/Gallery_9.jpg',
//   //   // 'https://maps.iwayplus.in/uploads/Gallery_6.jpg',
//   //   // Add more image URLs or local assets as needed
//   // ];
//
//   @override
//   Widget build(BuildContext context) {
//
//     if(_ImageIndex>widget.images.length){
//       _ImageIndex=0;
//     }
//     return Column(
//       children: [
//         CarouselSlider(
//           options: CarouselOptions(
//             enlargeCenterPage: true,
//             autoPlay: false,
//             aspectRatio: 16 / 9,
//             autoPlayCurve: Curves.fastOutSlowIn,
//             enableInfiniteScroll: true,
//             autoPlayAnimationDuration: Duration(milliseconds: 800),
//             viewportFraction: 1.0,
//             onPageChanged: (index, _) {
//               setState(() {
//                 _currentImageIndex = index;
//                 _ImageIndex = index;
//               });
//             },
//
//
//           ),
//
//
//           items: widget.images.map((item) {
//             return Builder(
//               builder: (BuildContext context) {
//
//                 return Semantics(
//                   label: "Header Image",
//                   child: GestureDetector(
//                     onTap: (){
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext dialogContext) {
//                           return Dialog(
//                             child: GestureDetector(
//                               onTap: () {
//
//                               },
//
//                               child: Semantics(
//                                 label:widget.imagesSemantics[_ImageIndex],
//                                 child: Container(
//                                   width: MediaQuery.of(dialogContext).size.width,
//                                   height: MediaQuery.of(dialogContext).size.width /14*9 ,
//
//                                   child: PhotoView(
//                                     imageProvider: NetworkImage(item),
//                                     minScale: PhotoViewComputedScale.contained * 0.8,
//                                     maxScale: PhotoViewComputedScale.covered * 2.0,
//                                     initialScale: PhotoViewComputedScale.contained,
//                                   ),
//
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       margin: EdgeInsets.symmetric(horizontal: 0.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white54,
//                       ),
//                       child: Image.network(
//                         item,
//                         fit: BoxFit.cover,
//                       ),
//
//                     ),
//                   ),
//                 );
//               },
//
//             );
//           }).toList(),
//
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: widget.images!.map((url) {
//             int index = widget.images!.indexOf(url);
//             return Container(
//               width: 8.0,
//               height: 8.0,
//               margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _currentImageIndex == index
//                     ? Color(0xffECC113)
//                     : Colors.grey.withOpacity(0.5),
//               ),
//
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
//
// //Abassadors carousel
// class ImageSliderAmb extends StatefulWidget {
//   @override
//   _ImageSliderAmbState createState() => _ImageSliderAmbState();
// }
//
// class _ImageSliderAmbState extends State<ImageSliderAmb> {
//   int _currentImageIndex = 0;
//
//
//
//   List<String> images = [
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Saurabh-Prasad.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Shrutilata.jpeg',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Smitha-Sadasivan.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Sonali-Mukherjee.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Swasti-Mehta.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Aditi-Gangrade-1.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Vishant-Nagvekar.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Radesh-Varty.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Anubha.jpeg',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Reshma-Valliappan.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Chaitanya-Mukund.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Disha-Pandya.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Dr.-Anubha-mahajan.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Dr.-Shanthipriya-Silva.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Ekta-Bhyan.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/k-vaishali.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Nomesh-Verma.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Pooja-Gupta.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Prasad-Joshi.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Prashant-Naik.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/priya-lal.png',
//     'https://purplefest.goa.gov.in/wp-content/uploads/2023/12/Puneet.jpeg'
//   ];
//
//   Map<String, String> disabilityMap = {
//     'Saurabh-Prasad.png': 'Ambassadors for Person with Blindness.',
//     'Shrutilata.jpeg': 'Ambassadors for Person with multiple disabilities including deaf blindness.',
//     'Smitha-Sadasivan.png': 'Ambassadors for Person with Multiple Sclerosis.',
//     'Sonali-Mukherjee.png': 'Ambassadors for Person with Acid Attack Survivor .',
//     'Swasti-Mehta.png': 'Ambassadors for Person with Intellectual Disability.',
//     'Aditi-Gangrade-1.png': 'Ambassadors for Person with Autism Spectrum Disorder.',
//     'Vishant-Nagvekar.png': 'Ambassadors for Person with Locomotor Disability.',
//     'Radesh-Varty.png': 'Ambassadors for Person with Hemophilia.',
//     'Anubha.jpeg': 'Ambassadors for Person with Chronic Neurological conditions.',
//     'Reshma-Valliappan.png': 'Ambassadors for Person with Mental Illness.',
//     'Chaitanya-Mukund.png': 'Ambassadors for Person with Cerebral Palsy.',
//     'Disha-Pandya.png': 'Ambassadors for Person with Dwarfism.',
//     'Dr.-Anubha-mahajan.png': 'Ambassadors for Person with Chronic Neurological conditions.',
//     'Dr.-Shanthipriya-Silva.png': 'Ambassadors for Person with Parkinson\'s disease.',
//     'Ekta-Bhyan.png': 'Ambassadors for Person with Spinal Cord Injury.',
//     'k-vaishali.png': 'Ambassadors for Person with Specific Learning Disabilities .',
//     'Nomesh-Verma.png': 'Ambassadors for Person with Sickle Cell disease.',
//     'Pooja-Gupta.png': 'Ambassadors for Person with Thalassemia.',
//     'Prasad-Joshi.png': 'Ambassadors for Person with Deaf.',
//     'Prashant-Naik.png': 'Ambassadors for Person with Low Vision.',
//     'priya-lal.png': 'Ambassadors for Person with Leprosy Cured Person.',
//     'Puneet.jpeg': 'Ambassadors for Person with Speech and Language disability.',
//   };
//   // Populate the HashMap
//
//   String getSubstringBeforeDot(String inputString) {
//     // Split the string using '.' as the delimiter
//     List<String> parts = inputString.split('.');
//
//     // Get the substring before the first '.'
//     String substringBeforeDot = parts[0];
//     return substringBeforeDot;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black12,
//       margin: EdgeInsets.only(left: 20, top: 16, right: 20),
//       child: CarouselSlider(
//         options: CarouselOptions(
//           height:200.0,
//           enlargeCenterPage: true,
//           autoPlay: false,
//           //aspectRatio: 16 / 9,
//           autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
//           enableInfiniteScroll: false,
//           autoPlayAnimationDuration: Duration(seconds: 20),
//           viewportFraction: 1.0,
//           onPageChanged: (index, _) {
//             setState(() {
//               _currentImageIndex = index;
//             });
//           },
//
//         ),
//         items: images.map((item) {
//           return Builder(
//             builder: (BuildContext context) {
//               return Container(
//                 margin: EdgeInsets.symmetric(horizontal: 0.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white54,
//                 ),
//                 child: Image.network(
//                   item,
//                   fit: BoxFit.fitHeight,
//                   semanticLabel: item.substring(57, item.length - 3) + disabilityMap[item.substring(57, item.length)]!+" slide right for next",
//                 ),
//               );
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
//
//
//
// String formatEmail(String inputString) {
//   List<String> parts = inputString.split(' ');
//
//   if (parts.length > 0) {
//     return parts.sublist(0).join('\n');
//   } else {
//     return ""; // Return an empty string if no content found after space
//   }
// }