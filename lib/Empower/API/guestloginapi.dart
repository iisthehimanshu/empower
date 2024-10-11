import 'dart:convert';
import 'package:http/http.dart' as http;

import '../APIModel/guestloginmodel.dart';

class guestApi {

  static const String baseUrl = "https://maps.iwayplus.in/auth/guest";

  static Future<guestloginmodel> guestlogin() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      print("GUEST API");
      return guestloginmodel.fromJson(responseBody);
    } else {
      print(response.statusCode);
      throw Exception('Failed to load data');
    }
  }
}
