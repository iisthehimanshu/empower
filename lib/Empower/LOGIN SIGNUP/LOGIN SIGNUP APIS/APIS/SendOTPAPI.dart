import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class SendOTPAPI{

  final String baseUrl = "https://maps.iwayplus.in/auth/otp/send";

  Future<bool> sendOTP(String username) async {
    final Map<String, dynamic> data = {
      "username": username,
      "digits":4,
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
        // return HelperClass.showToast("OTP sent successfully");
    } else {
      print("SendOTPAPI--response.statusCode${response.statusCode} ${response.body}");
      return false;
    }
  }
}