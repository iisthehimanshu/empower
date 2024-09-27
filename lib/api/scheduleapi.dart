import 'dart:convert';
import 'package:http/http.dart' as http;

import '../apimodels/schedulemodel.dart';
import 'guestloginapi.dart';

class scheduleapi {
  static const String baseUrl = "https://dev.iwayplus.in/secured/cms/conference/event/get";

  static Future<scheduleModel?> fetchschedule({String id = "6555b2061c3bd126c337d52e"}) async {
    final Map<String, dynamic> data = {
      "id": id
    };
    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': await guestApi.guestlogin().then((value){
          return value.accessToken!;
        })
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      return scheduleModel.fromJson(responseBody);
    }
  }
}