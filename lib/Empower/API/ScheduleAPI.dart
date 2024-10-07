import 'dart:convert';
import 'package:empower/Empower/DATABASE/BOX/ScheduleApiModelBOX.dart';
import 'package:empower/Empower/DATABASE/DATABASEMODEL/ScheduleApiModel.dart';
import 'package:empower/Navigation/Elements/HelperClass.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../Navigation/API/RefreshTokenAPI.dart';
import '../APIModel/Schedulemodel.dart';
import 'guestloginapi.dart';

class ScheduleAPI {
  static const String baseUrl = "https://maps.iwayplus.in/secured/cms/conference/event/get";
  static var signInBox = Hive.box('SignInDatabase');
  static String accessToken = signInBox.get("accessToken");

  static Future<ScheduleModel?> fetchschedule() async {
    final ScheduleBox = ScheduleApiModelBox.getData();

    if(ScheduleBox.containsKey("66f3dd94da553117a972caab")){
      print("SCHEDULE DATA FORM DATABASE ");
      Map<String, dynamic> responseBody = ScheduleBox.get("66f3dd94da553117a972caab")!.responseBody;
      return ScheduleModel.fromJson(responseBody);
    }

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
      print("SCHEDULE DATA FROM API ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      final scheduleData = ScheduleApiModel(responseBody: responseBody);
      ScheduleBox.put("66f3dd94da553117a972caab", scheduleData);
      scheduleData.save();
      print("responseBody.runtimeType");
      print(responseBody.runtimeType);
      print(responseBody);
      return ScheduleModel.fromJson(responseBody);
    }else if(response.statusCode == 403){
      print("SCHEDULE DATA FROM API AFTER 403");
      accessToken =  await RefreshTokenAPI.refresh();
      return ScheduleAPI.fetchschedule();
    } else{
      HelperClass.showToast("No Internet connection");
      print(response.statusCode);
    }
  }
}