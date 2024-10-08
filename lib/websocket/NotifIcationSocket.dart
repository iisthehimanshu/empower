
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart';

import '../Navigation/websocket/PushNotifications.dart';
import 'Model/NotificationData.dart';

class NotificationSocket{
  NotificationSocket(){
    channel.connect();
  }

  static final channel = io('https://dev.iwayplus.in', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  static void receiveMessage(){
    channel.on("com.iwayplus.empower", (value){
      NotificationData notification = NotificationData.fromJson(value);
      PushNotifications.showSimpleNotification(body: notification.title,payload: notification.body,title: notification.title);
      print("socketMessage${value}");
    });
    List<dynamic> receivedMessage = channel.receiveBuffer;
    print(receivedMessage);
  }

}

