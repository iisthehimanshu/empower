import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:empower/Navigation/Elements/HelperClass.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../APIMODELS/LocalNotificationAPIModel.dart';
import '../DATABASE/BOXES/LocalNotificationAPIDatabaseModelBOX.dart';
import '../DATABASE/DATABASEMODEL/LocalNotificationAPIDatabaseModel.dart';

class LocalNotificationAPI{

  final String baseUrl = kDebugMode? 'https://maps.iwayplus.in/secured/get-notifications?page=-1&appId=com.iwayplus.empower24' : 'https://maps.iwayplus.in/secured/get-notifications?page=-1&appId=com.iwayplus.empower24';
  static var signInBox = Hive.box('SignInDatabase');
  String accessToken = signInBox.get("accessToken");
  String refreshToken = signInBox.get("refreshToken");
  final NotifiBox = LocalNotificationAPIDatabaseModelBOX.getData();




  Future<List<NotificationsInLocalNotificationModule>> getNotifications()async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    bool deviceConnected = false;

    if(connectivityResult.contains(ConnectivityResult.mobile)){
      deviceConnected = true;
    }else if(connectivityResult.contains(ConnectivityResult.wifi) ){
      deviceConnected = true;
    }



    if(!deviceConnected){
      HelperClass.showToast("No Internet Connection!!");
      print("LocalNotificationAPI DATA FROM DATABASE");
      if(NotifiBox.containsKey("com.iwayplus.empower24")){
        Map<String, dynamic> responseBody = NotifiBox.get("com.iwayplus.empower24")!.responseBody;
        LocalNotificationAPIModel notificationData =LocalNotificationAPIModel.fromJson(responseBody);
        List<NotificationsInLocalNotificationModule> notificationsList = notificationData.notifications!;
        return notificationsList;
      }

    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': accessToken
      },
    );


    if (response.statusCode == 200) {
      print("LocalNotificationAPI DATA FROM API");
      Map<String, dynamic> responseBody =  json.decode(response.body);
      LocalNotificationAPIModel notificationData =LocalNotificationAPIModel.fromJson(responseBody);
      List<NotificationsInLocalNotificationModule> notificationsList = notificationData.notifications!;
      final notificationSaveData = LocalNotificationAPIDatabaseModel(responseBody: responseBody);
      NotifiBox.put("com.iwayplus.empower24", notificationSaveData);
      notificationSaveData.save();
      return notificationsList;
    }
    else {
    print(response.reasonPhrase);
    return [];
    }
  }

}