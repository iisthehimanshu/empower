import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../apimodels/Schedulemodel.dart';
import 'RefreshTokenAPI.dart';
import 'guestloginapi.dart';

class ScheduleAPI {
  static const String baseUrl = "https://maps.iwayplus.in/secured/cms/conference/event/get";
  static var signInBox = Hive.box('SignInDatabase');
  static String accessToken = signInBox.get("accessToken");
  static String refreshToken = signInBox.get("refreshToken");

  static Future<ScheduleModel?> fetchschedule() async {

    final Map<String, dynamic> data = {
      "id": "66f3dd94da553117a972caab"
    };
    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': accessToken
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      print(responseBody);
      return ScheduleModel.fromJson(responseBody);
    }else if(response.statusCode == 403){
      accessToken =  await RefreshTokenAPI.refresh();
      return fetchschedule();
    } else{
      print(response.statusCode);
    }
  }
}