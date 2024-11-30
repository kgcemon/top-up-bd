import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:top_up_bd/data/api_urls.dart';

class ThankYouController extends GetxController {
  var remainingTime = 180.obs; // Observable for time remaining
  Timer? cowntimer;
  RxBool orderStatus = false.obs;
  RxBool orderDelete = false.obs;
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void startCountdown(String orderID) {
    cowntimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTime > 0) {
        remainingTime.value--;
        print(remainingTime.value);
        if (remainingTime.value == 100) {
          recheckOrder(orderId: orderID).then(
            (value) {
              if (value) {
                cowntimer?.cancel();
              }
            },
          );
        }
      } else {
        cowntimer?.cancel();
      }
    });
  }

  waitingForNotification(var orderID) async {
    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("working");

      if (message.notification != null) {
        recheckOrder(orderId: orderID);
      }
    });
  }

  Future<bool> recheckOrder({required String orderId}) async {
    var response = await http.get(Uri.parse(
        "${ApiUrls.mainUrls}/topupbd/order-check.php?order_id=$orderId"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      if (data['status'] == 'success' &&
          data['order_status'] == 'Auto Completed') {
        cowntimer?.cancel();
        orderStatus.value = true;
        return true;
      } else if (data['order_status'] == 'Complete') {
        cowntimer?.cancel();
        orderStatus.value = true;
        return true;
      } else if (data['order_status'] ==
          '\u09aa\u09c7\u09ae\u09c7\u09a8\u09cd\u099f \u09a8\u09be \u0995\u09b0\u09be\u09df \u09a1\u09bf\u09b2\u09c7\u099f \u0995\u09b0\u09be \u09b9\u09df\u09c7\u099b\u09c7') {
        cowntimer?.cancel();
        orderDelete.value = true;
        return false;
      } else {
        orderStatus.value = false;
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  void onClose() {
    cowntimer?.cancel(); // Cancel timer when controller is disposed
    super.onClose();
  }
}
