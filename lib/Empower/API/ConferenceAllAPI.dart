import 'dart:convert';
import 'package:empower/Empower/APIModel/ConferenceAllAPIModel.dart';
import 'package:empower/Empower/DATABASE/BOX/ConferenceAllDataBaseModelBOX.dart';
import 'package:empower/Empower/DATABASE/BOX/ScheduleApiModelBOX.dart';
import 'package:empower/Empower/DATABASE/DATABASEMODEL/ScheduleApiModel.dart';
import 'package:empower/Navigation/Elements/HelperClass.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../Navigation/API/RefreshTokenAPI.dart';
import '../APIModel/Schedulemodel.dart';
import '../DATABASE/DATABASEMODEL/ConferenceAllDataBaseModel.dart';
import 'guestloginapi.dart';

class ConferenceAllApi {
  static const String baseUrl = "https://maps.iwayplus.in/secured/cms/conferences/all";
  static var signInBox = Hive.box('SignInDatabase');
  static String accessToken = signInBox.get("accessToken");

  static Future<ConferenceAllAPIModel?> fetchdata({bool fetchFromInternet = false}) async {
    String refreshToken = signInBox.get("refreshToken");
    final ConferenceBox = ConferenceAllDataBaseModelBOX.getData();

    if(!fetchFromInternet && ConferenceBox.containsKey("66f3dd94da553117a972caab")){
      print("ConferenceAllApi DATA FROM DATABASE");
      Map<String, dynamic> responseBody = ConferenceBox.get("66f3dd94da553117a972caab")!.responseBody;
      return ConferenceAllAPIModel.fromJson(responseBody);
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': accessToken
      },
    );
    if (response.statusCode == 200) {
      print("ConferenceAllApi DATA FROM API ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      final eventData = ConferenceAllDataBaseModel(responseBody:responseBody);
      ConferenceBox.put("66f3dd94da553117a972caab", eventData);
      eventData.save();
      return ConferenceAllAPIModel.fromJson(responseBody);
    }else if(response.statusCode == 403){
      print("ConferenceAllApi DATA FROM API AFTER 403");
      print(refreshToken);
      accessToken =  await RefreshTokenAPI.refresh();
      return ConferenceAllApi.fetchdata();
    } else{
      HelperClass.showToast("No Internet connection");
      print(response.statusCode);
    }
  }
}