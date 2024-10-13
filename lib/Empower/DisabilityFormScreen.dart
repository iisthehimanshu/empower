import 'dart:math';
import 'dart:io';
import 'package:empower/Empower/MainScreen.dart';
import 'package:empower/Navigation/API/UsergetAPI.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class DisabilityFormScreen extends StatefulWidget {
  DisabilityFormScreen();

  @override
  State<DisabilityFormScreen> createState() => _DisabilityFormScreenState();
}

class _DisabilityFormScreenState extends State<DisabilityFormScreen> {
  Random random = Random();

  String? typeofuser = "";

  double cw(int w) {
    return (w * ((MediaQuery.of(context).size.width) / (360)));
  }

  double ch(int h) {
    return (h * ((MediaQuery.of(context).size.height) / (640)));
  }

  String username;

  _DisabilityFormScreenState({this.username = "Guest"});

  List<String> accessTitles = [
    'Prefer not to say',
    'Acid Attack Victim',
    'Blindness',
    'Chronic Neurological Conditions',
    'Hearing Impairment',
    'Intellectual Disability',
    'Locomotor Disability',
    'Mental Illness',
    'Multiple Sclerosis',
    'Sickle Cell Disease',
    'Speech and Language Disability',
    'Autism Spectrum Disorder',
    'Cerebral Palsy',
    'Dwarfism',
    'Hemophilia',
    'Leprosy Cured',
    'Low Vision',
    'Muscular Dystrophy',
    'Parkinson\'s Disease',
    'Specific Learning Disabilities',
    'Thalassemia',
  ];

  late List<Widget> accessibilityWid;

  List<String> disabilities = [];

  Color buttonColorglobal = Color(0xffEBEBEB);
  Color buttonColorglobalselected = Color(0xffECC113);

  String? isDisabled = "";
  DateTime? selectedDate;
  late String Username = '';
  late String Useremail = '';
  late String Userphone = '';
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    setState(() {
      isDisabled = "";
      apicall();
    });

    if (disabilities != null) {
      accessibilityWid = accessTitles
          .map((title) => AccessibilityButtons(
        title: title,
        onPressed: filterPressed,
        buttonColor: disabilities!.contains(title)
            ? buttonColorglobalselected
            : buttonColorglobal,
      ))
          .toList();
    } else {
      accessibilityWid = accessTitles
          .map((title) => AccessibilityButtons(
        title: title,
        onPressed: filterPressed,
        buttonColor: buttonColorglobal,
      ))
          .toList();
    }

  }
  var signInBox = Hive.box('SignInDatabase');
  var userInfoBox=Hive.box('UserInformation');



  void apicall() async{
    await UsergetAPI().getUserDetailsApi(signInBox.get("userId"));
    await setPageInfo();
    Future.delayed(const Duration(seconds: 1)).then((e){
      setState(() {
        isLoading=false;
      });
    });
  }

  Future<void> setPageInfo() async{
    Username = userInfoBox.get("name");
    if(userInfoBox.containsKey('email') && userInfoBox.get("email") != null) {
      print("userInfoBox.get");
      print(userInfoBox.get("email"));

      Useremail = userInfoBox.get("email");
    }
    if(userInfoBox.containsKey('mobile') && userInfoBox.get("mobile") != null) {
      print("userInfoBox.get");
      print(userInfoBox.get("mobile"));
      Userphone = userInfoBox.get("mobile");
    }
    print("Username");
    print(Username);
    print(Useremail);
    print(Userphone);
  }

  void filterPressed(String title) {
    // if (fetchedlogindata!.data!.disabilities != null) {
    //   if (fetchedlogindata!.data!.disabilities!.contains(title)) {
    //     fetchedlogindata!.data!.disabilities!.remove(title);
    //     disabilities!.remove(title);
    //   } else {
    //     fetchedlogindata!.data!.disabilities!.add(title);
    //     disabilities!.add(title);
    //   }
    // } else {
    //   fetchedlogindata!.data!.disabilities = [];
    //   disabilities = [];
    //   fetchedlogindata!.data!.disabilities!.add(title);
    //   disabilities!.add(title);
    // }
    // print(title);
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          backgroundColor: Color(0xffFFFFFF),
          elevation: 0,
        ),
        body: isLoading // Show loader while fetching data
            ? Center(
              child: LoadingAnimationWidget.stretchedDots(
                color: Color(0xffB2EFE4),
                size: screenHeight*0.2,
              ),// Show a loader
            )
            : Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 80,left: 20,top: 20,right: 20), // Adjust for button space
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // height: screenHeight-244,
                            // width: screenWidth-47,
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          '${" \" Welcome to "}',
                                          style: const TextStyle(
                                            fontFamily: "Roboto",
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            height: 30/24,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        const Text(
                                          "Empower 2023 \"",
                                          style: const TextStyle(
                                            color: Color(0xff2FC8AD),
                                            fontFamily: "Roboto",
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            height: 30/24,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      "Let's get to know you better !",
                                      style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff777777),
                                        height: 23/16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: const Text(
                                    "Name",
                                    style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0e0d0d),
                                      height: 23/16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    Username,
                                    style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff777777),
                                      height: 23/16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),

                                Userphone!=''?Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Mobile Number",
                                    style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                      height: 23/16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ):Container(),
                                Userphone!=''?Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    Userphone,
                                    style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff777777),
                                      height: 23/16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ):Container(),
                                Useremail!='' && Useremail.contains("@")?Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Text(
                                    "Email",
                                    style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                      height: 23/16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ):Container(),
                                Useremail!='' && Useremail.contains("@")?Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    Useremail,
                                    style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff777777),
                                      height: 23/16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ):Container(),

                                Container(
                                  //  width: screenWidth-47,
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "Are you person with disabilities?",
                                    style: const TextStyle(
                                        fontFamily: "Roboto",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  //    height: 32,
                                  //    margin: EdgeInsets.only(top: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Radio(
                                          value: 'Yes',
                                          groupValue: isDisabled,
                                          onChanged: (value) {
                                            setState(() {
                                              isDisabled = value;
                                              // fetchedlogindata!.data!.disabilities = ["other"];
                                            });
                                          },
                                          activeColor: Color(0xff2FC8AD),
                                        ),
                                        Text('Yes'),
                                        Radio(
                                          value: 'No',
                                          groupValue: isDisabled,
                                          onChanged: (value) {
                                            setState(() {
                                              isDisabled = value;
                                              // fetchedlogindata!.data!.disabilities = [];
                                            });
                                          },
                                          activeColor: Color(0xff2FC8AD),
                                        ),
                                        Text('No'),
                                      ],
                                    )),
                                isDisabled == 'Yes'
                                    ? Container(
                                  //  margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  margin: EdgeInsets.only(top: 15,bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          child: Text(
                                            'Choose your Disability type',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff000000),
                                            ),
                                          )),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(
                                                0xffEBEBEB), // Color of the border
                                            width: 1.0, // Width of the border
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(20), // Optional: You can round the corners
                                        ),
                                        margin: EdgeInsets.only(top: 16),
                                        padding: EdgeInsets.fromLTRB(
                                            10, 10, 10, 10),
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          spacing: 10,
                                          runSpacing: 12,
                                          children: accessibilityWid,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : Container(),

                              ],
                            ),
                          )
                        ],
                      ),
                    )
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: screenWidth,
                    height: 48,

                    margin: EdgeInsets.fromLTRB(15, 0, 15, 50),
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(initialIndex: 0,),
                          ),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Color(0xff2FC8AD)
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff000000),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
          ],
        )
    );


  }

  void showToast(String mssg) {
    Fluttertoast.showToast(
      msg: mssg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  check(String? filename) {
    if (filename != null && filename.startsWith('https://')) {
      // The filename starts with 'https://'
      return true;
    } else {
      // The filename does not start with 'https://'
      return false;
    }
  }
}

class AccessibilityButtons extends StatefulWidget {
  final String title;
  final Function(String) onPressed;
  late Color buttonColor;

  AccessibilityButtons({required this.title,
        required this.onPressed,
        required this.buttonColor});

  @override
  State<AccessibilityButtons> createState() => _AccessibilityButtonsState();
}

class _AccessibilityButtonsState extends State<AccessibilityButtons> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPressed(widget.title);
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: widget.buttonColor,
          border: Border.all(
            color: Color(0xffbdbdbd), // Color of the border
            width: 1.0, // Width of the border
          ),
          borderRadius:
          BorderRadius.circular(25), // Optional: You can round the corners
        ),
        child: ElevatedButton(
            onPressed: () {
              print('${widget.title} button pressed');
              widget.onPressed(widget.title);

              setState(() {
                if (widget.buttonColor == Color(0xffEBEBEB)) {
                  widget.buttonColor = Color(0xffB2EFE4);
                } else {
                  widget.buttonColor = Color(0xffEBEBEB);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0, // Set elevation to 0 to remove the shadow
            ),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff000000),
              ),
              textAlign: TextAlign.left,
            )),
      ),
    );
  }
}
