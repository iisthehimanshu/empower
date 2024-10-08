import 'package:empower/Empower/HomePage.dart';
import 'package:empower/Empower/ScheduleScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Navigation/Navigation.dart';


class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex=0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int index;
  final screens = [
    HomePage(),
    Navigation(),
    ScheduleScreen(),
    HomePage(),
  ];

  @override
  void initState() {
    super.initState();
    checkPermission();
    index = widget.initialIndex;
  }
  checkPermission()async{
    await requestBluetoothConnectPermission();
  }
  // void setIDforWebSocket()async{
  //   final signInBox = await Hive.openBox('SignInDatabase');
  //   wsocket.message["userId"] = signInBox.get("userId");
  // }



  Future<void> requestBluetoothConnectPermission() async {
    final PermissionStatus permissionStatus = await Permission.bluetooth.request();
    print("permissionStatus    ----   ${permissionStatus}");
    if (permissionStatus.isGranted) {
      print("Bluetooth permission is granted");
      // Permission granted, you can now perform Bluetooth operations
    } else {
      // Permission denied, handle accordingly
      print("Bluetooth permission is denied");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelTextStyle: MaterialStateProperty.all(TextStyle(
            fontFamily: "Roboto",
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xff4B4B4B),
            height: 20/14,
          )),
        ),

        child: NavigationBar(
          backgroundColor: Color(0xffFFFFFF),
          selectedIndex: index,
          onDestinationSelected: (index)=>setState(() {
            if (index==3){
              // Check if the 4th screen is selected
              showToast('Feature coming soon');
            }
            else {
              // Switch to the selected screen for other cases
              // if (index == 1) {
              //   // Open MapScreen in full screen
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
              // } else {
              //   // Switch to the selected screen for other cases
              //   this.index = index;
              // }
              this.index = index;
            }
          }),
          destinations: [
            NavigationDestination(icon: SvgPicture.asset("assets/MainScreen_home.svg",color: Color(0xff1C1B1F)),selectedIcon: SvgPicture.asset("assets/MainScreen_home.svg",color: Color(0xff24B9B0),), label: 'Home',),
            NavigationDestination(icon: SvgPicture.asset("assets/MainScreen_Map.svg",color: Color(0xff1C1B1F)),selectedIcon: SvgPicture.asset("assets/MainScreen_Map.svg",color: Color(0xff24B9B0),), label: "Map",),
            // NavigationDestination(icon: SvgPicture.asset("assets/MainScreen_Scanner.svg",color: Color(0xff1C1B1F),),selectedIcon: SvgPicture.asset("assets/MainScreen_Scanner.svg",color: Color(0xff1C1B1F),width: 34,height: 34,), label: 'Schedule',),
            NavigationDestination(
              icon: Icon(Icons.event_outlined, color: Color(0xff1C1B1F)), // Unselected state
              selectedIcon: Icon(Icons.event_outlined, color: Color(0xff24B9B0)), // Selected state
              label: "Map",
            ),
            NavigationDestination(icon: SvgPicture.asset("assets/MainScreen_Profile.svg",color: Color(0xff1C1B1F),),selectedIcon: SvgPicture.asset("assets/MainScreen_Profile.svg",color: Color(0xff1C1B1F),), label: "Profile"),
          ],
        ),
      ),
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
}
