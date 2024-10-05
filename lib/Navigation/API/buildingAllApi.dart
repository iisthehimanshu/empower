import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as g;
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../Empower/API/guestloginapi.dart';
import '../APIMODELS/buildingAll.dart';
import '../DATABASE/BOXES/BuildingAllAPIModelBOX.dart';
import '../DATABASE/DATABASEMODEL/BuildingAllAPIModel.dart';


class buildingAllApi {
  final String baseUrl = kDebugMode? "https://maps.iwayplus.in/secured/building/all" : "https://maps.iwayplus.in/secured/building/all";
  String token = "";
  static String selectedID="66ffc655cc539c610889cb98";
  static String selectedBuildingID="66ffc655cc539c610889cb98";
  static String selectedVenue="66ffc655cc539c610889cb98";
  static Map<String,g.LatLng> allBuildingID = {
    "66ffc655cc539c610889cb98":g.LatLng(8.52677872475676, 76.89836919307709)

  };
  // static String selectedID="65d8833adb333f89456e6519";
  // static String selectedBuildingID="65d8833adb333f89456e6519";
  // static String selectedVenue="65d8833adb333f89456e6519";
  // static Map<String,g.LatLng> allBuildingID = {"65d8835adb333f89456e687f": g.LatLng( 28.947238, 77.100917),
  //   "65d8833adb333f89456e6519": g.LatLng(28.947236, 77.101992),
  //   "65d8825cdb333f89456d0562": g.LatLng( 28.945987, 77.10206)
  // };
  static String outdoorID = "";

  static var signInBox = Hive.box('SignInDatabase');
  String accessToken = signInBox.get("accessToken");
  String refreshToken = signInBox.get("refreshToken");



  Future<List<buildingAll>> fetchBuildingAllData() async {
    final BuildingAllBox = BuildingAllAPIModelBOX.getData();
    accessToken = signInBox.get("accessToken");

    if(BuildingAllBox.length!=0){
      print("BUILDINGALL API DATA FROM DATABASE");
      print(BuildingAllBox.length);
      List<dynamic> responseBody = BuildingAllBox.getAt(0)!.responseBody;
      List<buildingAll> buildingList = responseBody
          .where((data) => data['initialBuildingName'] != null)
          .map((data) => buildingAll.fromJson(data))
          .toList();
      return buildingList;
    }


    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': accessToken
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      final buildingData = BuildingAllAPIModel(responseBody: responseBody);
      print("BUILDING API DATA FROM API");
      BuildingAllBox.add(buildingData);
      buildingData.save();
      List<buildingAll> buildingList = responseBody
          .where((data) => data['initialBuildingName'] != null)
          .map((data) => buildingAll.fromJson(data))
          .toList();
      return buildingList;

    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load data');
    }
  }
  // Method to set the stored string
  static Future<void> setStoredString(String value) async {
    selectedID = value;
    return;
  }

  // Method to get the stored string
  static String getStoredString() {
    return selectedID;
  }

  static void setStoredAllBuildingID(HashMap<String,g.LatLng> value){
    allBuildingID = value;
  }

  static Map<String,g.LatLng> getStoredAllBuildingID(){
    return allBuildingID;
  }


  // Method to set the stored string
  static void setStoredVenue(String value) {
    selectedVenue = value;
    //print("Set${selectedID}");
  }

  static void setSelectedBuildingID(String value)async{
    print("inside inside set id $value");
    selectedBuildingID = value;
    return;
  }

  static String getSelectedBuildingID() {
    return selectedBuildingID;
  }

  // Method to get the stored string
  static String getStoredVenue() {
    //print(selectedID);
    return selectedVenue;
  }

}