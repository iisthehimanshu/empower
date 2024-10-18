import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:empower/Empower/DATABASE/DATABASEMODEL/ConferenceAllDataBaseModel.dart';
import 'package:empower/Empower/DATABASE/DATABASEMODEL/ScheduleApiModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'Empower/EventsState.dart';
import 'Empower/LOGIN SIGNUP/SignIn.dart';
import 'Empower/MainScreen.dart';
import 'Empower/websocket/NotifIcationSocket.dart';
import 'Empower/websocket/PushNotifications.dart';
import 'Empower/websocket/UserLog.dart';
import 'Navigation/DATABASE/DATABASEMODEL/BeaconAPIModel.dart';
import 'Navigation/DATABASE/DATABASEMODEL/BuildingAPIModel.dart';
import 'Navigation/DATABASE/DATABASEMODEL/BuildingAllAPIModel.dart';
import 'Navigation/DATABASE/DATABASEMODEL/DataVersionLocalModel.dart';
import 'Navigation/DATABASE/DATABASEMODEL/FavouriteDataBase.dart';
import 'Navigation/DATABASE/DATABASEMODEL/LandMarkApiModel.dart';
import 'Navigation/DATABASE/DATABASEMODEL/LocalNotificationAPIDatabaseModel.dart';
import 'Navigation/DATABASE/DATABASEMODEL/OutDoorModel.dart';
import 'Navigation/DATABASE/DATABASEMODEL/PatchAPIModel.dart';
import 'Navigation/DATABASE/DATABASEMODEL/PolyLineAPIModel.dart';
import 'Navigation/DATABASE/DATABASEMODEL/SignINAPIModel.dart';
import 'Navigation/DATABASE/DATABASEMODEL/WayPointModel.dart';
import 'Navigation/Elements/deeplinks.dart';
import 'Navigation/Elements/locales.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  debugPaintSizeEnabled = false;

  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  PushNotifications.localNotiInit();

  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(LandMarkApiModelAdapter());
  await Hive.openBox<LandMarkApiModel>('LandMarkApiModelFile');
  Hive.registerAdapter(PatchAPIModelAdapter());
  await Hive.openBox<PatchAPIModel>('PatchAPIModelFile');
  Hive.registerAdapter(PolyLineAPIModelAdapter());
  await Hive.openBox<PolyLineAPIModel>("PolyLineAPIModelFile");
  Hive.registerAdapter(BuildingAllAPIModelAdapter());
  await Hive.openBox<BuildingAllAPIModel>("BuildingAllAPIModelFile");
  Hive.registerAdapter(FavouriteDataBaseModelAdapter());
  await Hive.openBox<FavouriteDataBaseModel>("FavouriteDataBaseModelFile");
  Hive.registerAdapter(BeaconAPIModelAdapter());
  await Hive.openBox<BeaconAPIModel>('BeaconAPIModelFile');
  Hive.registerAdapter(BuildingAPIModelAdapter());
  await Hive.openBox<BuildingAPIModel>('BuildingAPIModelFile');
  Hive.registerAdapter(SignINAPIModelAdapter());
  await Hive.openBox<SignINAPIModel>('SignINAPIModelFile');
  Hive.registerAdapter(OutDoorModelAdapter());
  await Hive.openBox<OutDoorModel>('OutDoorModelFile');
  Hive.registerAdapter(WayPointModelAdapter());
  await Hive.openBox<WayPointModel>('WayPointModelFile');
  Hive.registerAdapter(DataVersionLocalModelAdapter());
  await Hive.openBox<DataVersionLocalModel>('DataVersionLocalModelFile');
  Hive.registerAdapter(LocalNotificationAPIDatabaseModelAdapter());
  await Hive.openBox<LocalNotificationAPIDatabaseModel>('LocalNotificationAPIDatabaseModel');

  Hive.registerAdapter(ScheduleApiModelAdapter());
  await Hive.openBox<ScheduleApiModel>('ScheduleApiModelFile');

  Hive.registerAdapter(ConferenceAllDataBaseModelAdapter());
  await Hive.openBox<ConferenceAllDataBaseModel>('ConferenceAllDataBaseModelBOX');
  await Hive.openBox('Favourites');
  await Hive.openBox('UserInformation');
  await Hive.openBox('testingSave');
  await Hive.openBox('Filters');
  await Hive.openBox('SignInDatabase');
  await Hive.openBox('LocationPermission');
  await Hive.openBox('VersionData');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WakelockPlus.enable();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFFFFF), // Make the status bar background transparent
      systemNavigationBarColor: Colors.white, // Set the navigation bar color (change as needed)
      systemNavigationBarIconBrightness: Brightness.dark, // Set the navigation bar icons' color (light or dark)
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  wsocket soc = wsocket('com.iwayplus.empower24');
  final FlutterLocalization localization = FlutterLocalization.instance;
  void ontranslatedLanguage(Locale? locale){
    setState(() {

    });
  }

  void configureLocalization(){
    localization.init(mapLocales: LOCALES, initLanguageCode: 'en');
    localization.onTranslatedLanguage = ontranslatedLanguage;
  }

  @override
  void initState() {
    configureLocalization();
    Eventsstate.checkForUpdate();
    super.initState();
  }

  void _initDeepLinkListener(BuildContext c) async {
    _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen((Uri? uri) {
      print("URI ${uri.toString()}");
      Deeplink.deeplinkConditions(uri, c);
    });
  }

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
      debugShowCheckedModeBanner: false,

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
              _initDeepLinkListener(context);
              return MainScreen(initialIndex: 0);
            } // Redirect to Sign-In screen if user is not authenticated
          } else {
            _initDeepLinkListener(context);
            print("googleSignInUserName");
            return MainScreen(initialIndex: 0); // Redirect to MainScreen if user is authenticated
          }
        },
      ),
      supportedLocales: [
        Locale('en'), // English
        Locale('hi'), // Hindi
        // Locale('es'), // Spanish
        // Locale('fr'), // French
        // Locale('de'), // German
        Locale('ta'), // Tamil
        Locale('te'), // Telugu
        Locale('pa'), // Punjabi
      ],
      localizationsDelegates: localization.localizationsDelegates,
    );
  }
}

