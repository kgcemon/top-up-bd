import 'dart:convert';
import 'package:get/get.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:top_up_bd/data/api_urls.dart';

class ThankYouController extends GetxController {
  var remainingTime = 180.obs; // Observable for time remaining
  Timer? _timer;
  RxBool orderStatus = false.obs;

  void startCountdown(String orderID) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime.value--;
        print(remainingTime.value);
        if (remainingTime.value == 100) {
          recheckOrder(orderId: orderID).then(
            (value) {
              if (value) {
                _timer?.cancel();
              }
            },
          );
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<bool> recheckOrder({required String orderId}) async {
    var response = await http.get(Uri.parse(
        "${ApiUrls.mainUrls}/topupbd/order-check.php?order_id=$orderId"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success' &&
          data['order_status'] == 'Auto Completed') {
        orderStatus.value = true;
        return true;
      } else if (data['order_status'] == 'Complete') {
        orderStatus.value = true;
        return true;
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
    _timer?.cancel(); // Cancel timer when controller is disposed
    super.onClose();
  }
}
