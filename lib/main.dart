import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/SharedPreferencesInstance.dart';
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
  SharedPreferencesInstance.sharedPreferencesGet("token");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotifications.init();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);
  runApp( DevicePreview(
    enabled: true,
    builder: (context) => const MyApp(), // Wrap your app
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
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


