import 'package:socket_io_client/socket_io_client.dart';
import 'Model/NotificationData.dart';
import 'PushNotifications.dart';

class NotificationSocket{
  NotificationSocket(){
    channel.connect();
  }

  static final channel = io('https://maps.iwayplus.in', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  static void receiveMessage(){
    channel.on("com.iwayplus.empower", (value){

      NotificationData notification = NotificationData.fromJson(value);
      print("notification.filepath");
      print(notification.filepath);
      print(notification.body);
      print(notification.title);
      PushNotifications.showSimpleNotificationwithImage(body: notification.body,payload: notification.body,title: notification.title, imageUrl: notification.filepath);
      //print("socketMessage${value}");
    });
    List<dynamic> receivedMessage = channel.receiveBuffer;
    //print(receivedMessage[0]);
    //print(receivedMessage);
  }

}

