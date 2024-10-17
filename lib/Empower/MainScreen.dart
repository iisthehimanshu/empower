import 'package:empower/Empower/HomePage.dart';
import 'package:empower/Empower/ScheduleScreen.dart';
import 'package:empower/Empower/websocket/NotifIcationSocket.dart';
import 'package:empower/Empower/websocket/UserLog.dart';
import 'package:empower/Navigation/DATABASE/BOXES/LandMarkApiModelBox.dart';
import 'package:empower/Navigation/Elements/HelperClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Navigation/DATABASE/BOXES/BeaconAPIModelBOX.dart';
import '../Navigation/DATABASE/BOXES/BuildingAllAPIModelBOX.dart';
import '../Navigation/DATABASE/BOXES/PatchAPIModelBox.dart';
import '../Navigation/DATABASE/BOXES/PolyLineAPIModelBOX.dart';
import '../Navigation/DATABASE/BOXES/WayPointModelBOX.dart';
import '../Navigation/DATABASE/BOXES/OutDoorModelBOX.dart';

import '../Navigation/Navigation.dart';
import 'Elements/MainScreenController.dart';
import 'ProfilePage.dart';
import 'QrScanner.dart';


class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex=0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final screens = [
    HomePage(),
    Navigation(),
    QRScannerScreen(),
    ScheduleScreen(),
    ProfilePage(),
  ];

  late int index;

  @override
  void initState() {
    super.initState();
    NotificationSocket.receiveMessage();
    index=widget.initialIndex;
    checkPermission();
    setIDforWebSocket();
    checkForUpdate();
  }

  checkPermission()async{
    await requestNotificationPermission();
    await requestBluetoothConnectPermission();
  }
  // void setIDforWebSocket()async{
  //   final signInBox = await Hive.openBox('SignInDatabase');
  //   wsocket.message["userId"] = signInBox.get("userId");
  // }
  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        print("Notification permission granted");
      } else {
        print("Notification permission denied");
      }
    }
  }

  void setIDforWebSocket()async{
    final signInBox = await Hive.openBox('SignInDatabase');
    print("user id ${signInBox.get("userId")}");
    wsocket.message["userId"] = signInBox.get("userId");
  }

  Future<void> checkForUpdate() async {
    final newVersion = NewVersionPlus(
      androidId: 'com.iwayplus.empower',
      iOSId: 'com.iwayplus.empower',
    );

    try {
      final status = await newVersion.getVersionStatus();

      handleAppUpdate(status!.storeVersion,status!.localVersion);
    } catch (e) {
      print('Error checking for updates: $e');

    }
  }

  Future<void> handleAppUpdate(String currVersion, String localVersion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get current app version
    String currentVersion = currVersion;

    // Fetch stored version from preferences
    String? storedVersion = prefs.getString('appVersion')??localVersion;

    // Check if the app was updated (if stored version is different from the current version)
    print(storedVersion);
    bool hasHandledUpdate = prefs.getBool('hasHandledUpdate') ?? false;

    if (!hasHandledUpdate) {
      print("entereddd");
      // App has been updated - run your reset logic
      final BeaconBox = BeaconAPIModelBOX.getData();
      final BuildingAllBox = BuildingAllAPIModelBOX.getData();
      final LandMarkBox = LandMarkApiModelBox.getData();
      final PatchBox = PatchAPIModelBox.getData();
      final PolyLineBox = PolylineAPIModelBOX.getData();
      final WayPointBox = WayPointModeBOX.getData();
      final OutBuildingBox = OutDoorModeBOX.getData();

      BeaconBox.clear();
      BuildingAllBox.clear();
      LandMarkBox.clear();
      PatchBox.clear();
      PolyLineBox.clear();
      WayPointBox.clear();
      OutBuildingBox.clear();
      print("clearedafterupdate");



      //showToast("Database Cleared ${BeaconBox.length},${BuildingAllBox.length},${LandMarkBox.length},${PatchBox.length},${PolyLineBox.length},${WayPointBox.length},${OutBuildingBox.length}");

      await resetBluetooth();  // Reset Bluetooth adapter or any other necessary reset logic

      // Mark that the update has been handled to avoid running the reset again
      await prefs.setBool('hasHandledUpdate', true);
      // Update the stored version to the current version
      await prefs.setString('appVersion', currentVersion);


    }
  }

  Future<void> resetBluetooth() async {
    // Turn Bluetooth off
    try {
      await FlutterBluePlus.turnOff().timeout(Duration(seconds: 20)); // Increased timeout to 20s
    } catch (e) {
      print('Failed to turn off Bluetooth: $e');
    }
    // Turn Bluetooth on after a short delay
    await Future.delayed(Duration(seconds: 2));
    await FlutterBluePlus.turnOn();
  }




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
      bottomNavigationBar: Semantics(
        label: "Navigation Tab",
        header: true,
        child: NavigationBarTheme(
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
            onDestinationSelected:(index)=>setState((){
              if(index==1){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Navigation()),
                );
              }
             else {
                this.index=index;
              }
            }),
            destinations: [
              Semantics(
                label: "Home",
                  child: NavigationDestination(icon: SvgPicture.asset("assets/MainScreen_home.svg",color: Color(0xff1C1B1F)),selectedIcon: SvgPicture.asset("assets/MainScreen_home.svg",color: Color(0xff24B9B0),), label: 'Home',)),
              Semantics(
                  label: "Map",
                  child: NavigationDestination(icon: SvgPicture.asset("assets/MainScreen_Map.svg",color: Color(0xff1C1B1F)),selectedIcon: SvgPicture.asset("assets/MainScreen_Map.svg",color: Color(0xff24B9B0),), label: "Map",)),
              Semantics(
                  label: "QR Scan",
                  child: NavigationDestination(icon: SvgPicture.asset("assets/MainScreen_Scanner.svg",color: Color(0xff1C1B1F),),selectedIcon: SvgPicture.asset("assets/MainScreen_Scanner.svg",color: Color(0xff1C1B1F),width: 34,height: 34,), label: 'Scan',)),
              Semantics(
                label: "Schedule",
                child: NavigationDestination(icon: Icon(Icons.event_outlined, color: Color(0xff1C1B1F)), // Unselected state
                  selectedIcon: Icon(Icons.event_outlined, color: Color(0xff24B9B0)), // Selected state
                  label: "Schedule",
                ),
              ),
              Semantics(
                label: "Profile",
                  child: NavigationDestination(icon: SvgPicture.asset("assets/MainScreen_Profile.svg",color: Color(0xff1C1B1F),),selectedIcon: SvgPicture.asset("assets/MainScreen_Profile.svg",color: Color(0xff1C1B1F),), label: "Profile")),
            ],
          ),
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
