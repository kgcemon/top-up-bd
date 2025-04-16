import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/binddings.dart';
import 'package:top_up_bd/controller/auth/user_auth_controller.dart';
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
  await SharedPreferencesInstance.sharedPreferencesGet("token");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotifications.init();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  await AuthController.getUserToken() ?? '';
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Binding(),
      useInheritedMediaQuery: true,
      theme: ThemeData(
          useMaterial3: true,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // Transparent status bar
            statusBarIconBrightness: Brightness.light, // Dark icons for light background
            systemNavigationBarColor: Colors.transparent, // Transparent navigation bar
            systemNavigationBarIconBrightness: Brightness.dark, // Dark icons
          ),
        ),
      ),
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
