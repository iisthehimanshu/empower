import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'LOGIN SIGNUP/SignIn.dart';
import 'MainScreen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('SignInDatabase');


  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF), // Make the status bar background transparent
      systemNavigationBarColor: Colors.white, // Set the navigation bar color (change as needed)
      systemNavigationBarIconBrightness: Brightness.dark, // Set the navigation bar icons' color (light or dark)
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isIOS = Platform.isIOS; // Check if the current platform is iOS
    bool isAndroid = Platform.isAndroid;
    if(isIOS){
      print("IOS");
    }else if(isAndroid){
      print("Android");
    }
    return MaterialApp(
      title: "IWAYPLUS",
      home: FutureBuilder<bool>(
        future: null,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final bool isUserAuthenticated = snapshot.data ?? false;

          if (!isUserAuthenticated) {
            var SignInDatabasebox = Hive.box('SignInDatabase');
            print("SignInDatabasebox.containsKey(accessToken)");
            print(SignInDatabasebox.containsKey("accessToken"));

            if(!SignInDatabasebox.containsKey("accessToken")){
              return SignIn();
            }else{
              return MainScreen(initialIndex: 1);
            } // Redirect to Sign-In screen if user is not authenticated
          } else {
            print("googleSignInUserName");
            return MainScreen(initialIndex: 0); // Redirect to MainScreen if user is authenticated
          }
        },
      ),
    );
  }
}

