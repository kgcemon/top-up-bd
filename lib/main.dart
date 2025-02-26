import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:top_up_bd/utils/SharedPreferencesInstance.dart';
import 'package:top_up_bd/screens/main_nav_screen.dart';
import 'package:top_up_bd/utils/AppColors.dart';
import 'PushNotifications.dart';
import 'firebase_options.dart';
import 'local_notification_service.dart';


Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    LocalNotificationService.display(message);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SharedPreferencesInstance.sharedPreferencesGet("token");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotifications.init();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Transparent status bar
    systemNavigationBarColor: Colors.transparent, // Transparent navigation bar
    systemNavigationBarIconBrightness: Brightness.dark, // Adjust icon brightness
    statusBarIconBrightness: Brightness.dark, // Status bar icon brightness
  ));

  runApp( const MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      useInheritedMediaQuery: true,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const MainNavScreen(),
    );
  }
}

showNotificationDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        title: const Center(
            child: Text(
              "Notification",
              style: TextStyle(color: AppColors.primaryColor),
            )),
        content: Text(
          message,
          style: const TextStyle(color: AppColors.primaryColor),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: const Size(double.infinity, 45),
                backgroundColor: AppColors.primaryColor),
            child: const Text(
              "OK",
              style: TextStyle(color: AppColors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


