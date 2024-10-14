import 'dart:convert';
import 'package:empower/Empower/DATABASE/BOX/ScheduleApiModelBOX.dart';
import 'package:empower/Empower/DATABASE/DATABASEMODEL/ScheduleApiModel.dart';
import 'package:empower/Navigation/Elements/HelperClass.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Navigation/API/RefreshTokenAPI.dart';
import '../APIModel/Schedulemodel.dart';
import 'guestloginapi.dart';

class ScheduleAPI {
  static const String baseUrl = "https://maps.iwayplus.in/secured/cms/conference/event/get";
  static var signInBox = Hive.box('SignInDatabase');
  static String accessToken = signInBox.get("accessToken");

  static Future<ScheduleModel?> fetchschedule({bool fetchFromInternet = false}) async {
    final ScheduleBox = ScheduleApiModelBox.getData();
    String refreshToken = signInBox.get("refreshToken");


    // DateTime currentDate = DateTime.now();
    // List<DateTime> specificDates = [
    //   DateTime(2024, 10, 17),
    //   DateTime(2024, 10, 18),
    //   DateTime(2024, 10, 19),
    // ];
    // var versionBox = Hive.box('VersionData');
    // DateTime? matchedDate;
    //
    //
    // for (var date in specificDates) {
    //   if (currentDate.year == date.year &&
    //       currentDate.month == date.month &&
    //       currentDate.day == date.day) {
    //     matchedDate = date;
    //     break;
    //   }
    // }
    //
    //
    //
    // bool isMatchingDate = specificDates.any((date) => currentDate.year == date.year &&
    //     currentDate.month == date.month &&
    //     currentDate.day == date.day);
    //
    // // Use a consistent date format (yyyy-MM-dd)
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    //
    // // Format the matchedDate to string
    // String? matchedDateString = matchedDate != null ? formatter.format(matchedDate) : null;
    //
    // if (matchedDate != null && versionBox.containsKey(matchedDateString)) {
    //   bool? count = versionBox.get(matchedDateString); // Get the stored value
    //
    //   print("Stored value for date ($matchedDateString): $count");
    //   print("Keys in versionBox: ${versionBox.keys}");
    //   print("Values in versionBox: ${versionBox.values}");
    //
    //   // Check if the date matches and the stored value is `true`
    //   if (isMatchingDate && count == true) {
    //     print("EVENT DATE");
    //
    //     // Update the value for the matched date
    //     versionBox.put(matchedDateString, false);
    //     print("Updated value after event: ${versionBox.get(matchedDateString)}");
    //   } else {
    //     print("NORMAL DATE");
    //   }
    // }


    if(!fetchFromInternet && ScheduleBox.containsKey("66f3dd94da553117a972caab")){
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
      print(refreshToken);
      accessToken =  await RefreshTokenAPI.refresh();
      return ScheduleAPI.fetchschedule();
    } else{
      HelperClass.showToast("No Internet connection");
      print(response.statusCode);
    }
  }
}