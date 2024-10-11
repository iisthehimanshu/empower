import 'dart:convert';
import 'package:empower/Navigation/Elements/HelperClass.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../Empower/API/guestloginapi.dart';

class RefreshTokenAPI {

  static String baseUrl = "https://dev.iwayplus.in/api/refreshToken?API_KEY=be349f00-b6cb-11ee-b352-d74b1ab1edff";

  static Future<String> refresh() async {
    var signInBox = Hive.box('SignInDatabase');
    String refreshToken = signInBox.get("refreshToken");

    final Map<String, dynamic> data = {
      "refreshToken": refreshToken
    };

    final response = await http.post(
      Uri.parse(baseUrl), body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("REFRESH TOKEN DATA FROM API");
      Map<String, dynamic> responseBody = json.decode(response.body);
      final newAccessToken = responseBody["accessToken"];
      signInBox.delete("accessToken");
      print(signInBox.get("accessToken"));
      signInBox.put("accessToken", newAccessToken);
      print(signInBox.get("accessToken"));
      return newAccessToken;
    } else {
      print("REFRESH TOKEN DATA FROM API");
      print(Exception);
      print(response.statusCode);
      HelperClass.showToast("Site Under Maintenance");
      throw Exception('Failed to load data');
    }
  }
}