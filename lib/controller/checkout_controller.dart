import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:top_up_bd/utils/SharedPreferencesInstance.dart';
import 'package:top_up_bd/data/api_urls.dart';
import 'package:top_up_bd/screens/thank_you_screen.dart';
import '../data/models/payment_model.dart';

class CheckOutController extends GetxController {
  var isPlacingOrder = false.obs;
  var totalAmount = 0.obs;
  var paymentMethods = <PaymentModel>[].obs;
  var selectedPaymentMethod = 0.obs;
  var selectedPaymentImg = ''.obs;
  RxString? username = ''.obs;
  RxString? userId = ''.obs;
  final formKey = GlobalKey<FormState>();

  RxInt paymentIndex = 0.obs;

  void load()async{
    userId?.value = await SharedPreferencesInstance.sharedPreferencesGet("userID") ?? '55545';
    username?.value = await SharedPreferencesInstance.sharedPreferencesGet("username") ?? 'Guest From New App';
  }


  // Load payment methods from the API
  void loadPayment() async {
    if (paymentMethods.isEmpty) {
      var response = await http.get(
          Uri.parse("${ApiUrls.mainUrls}/paymentapi.php?api_key=emon"));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        for (var element in data) {
          paymentMethods
              .add(PaymentModel.fromJson(element as Map<String, dynamic>));
        }
        selectedPaymentImg.value =
        "https://codmshopbd.com/myapp/${paymentMethods[0].img}";
        update();
      } else {
        Get.snackbar('Error', 'Failed to load payment methods');
      }
    }
  }

  // Select a payment method
  void selectPaymentMethod(int index) {
    selectedPaymentMethod.value = index;
  }

  // Method to place the order
  void placeOrder({
    required String productId,
    required String bkash_number,
    required String trxid,
    required String itemtitle,
    required String userdata,
    required String total,
  }) async {
    if (userdata.isEmpty) {
      Get.snackbar('Error', 'Player ID cannot be empty');
      return;
    }

    var token = await SharedPreferencesInstance.sharedPreferencesGet("token");

    // Show loading spinner
    isPlacingOrder(true);
    try {
      // API URL
      var url = Uri.parse("${ApiUrls.mainUrls}/topupbd/add_order.php?api_key=emon");

      // Prepare request body
      var requestBody = {
        "product_id": productId,
        "username": username?.value,
        //"number": await SharedPreferencesInstance.sharedPreferencesGet("phonenumber") ?? '',
        "status": 'Processing',
        "user_id": userId?.value,
        "bkash_number": bkash_number,
        "trxid": trxid,
        "userdata": userdata,
        "itemtitle": itemtitle,
        "total": total.replaceAll("৳", ""),
        "token": token,
      };

      // Send POST request
      var response = await http.post(url, body: requestBody);

      print(response.body);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData is List && responseData.isNotEmpty) {
          var responseMap = responseData[0];
          // Check if the transaction ID has already been used
          if (responseMap["status"].toString().contains("Transaction ID already used")) {
            Get.snackbar(
              'Error',
              responseMap["status"],
              backgroundColor: Colors.red,
              colorText: Colors.white,
              icon: const Icon(Icons.cancel, color: Colors.white),
            );
            username?.value = '';
            userId?.value = '';
          } else if (responseMap['status'] == 'sucess') {
            // Success: Order placed
            Get.snackbar('Success', 'Order placed successfully!');
            Get.offAll(() => ThankYouScreen(
              orderID: responseMap["id"],
              date: responseMap["datetime"],
              total: total,
              playerID: userdata,
              product: itemtitle,
              orderStatus: responseMap["order"],
              paymentImg: selectedPaymentImg.value,
              paymentNumber: bkash_number,
              trxID: trxid,
            ));
          } else {
            // Failure: Show error message
            String errorMessage = responseMap['message']?.toString() ?? 'Unknown error';
            Get.snackbar('Error', 'Failed to place order: $errorMessage');
          }
        } else {
          Get.snackbar('Error', 'Invalid response format.');
        }
      } else {
        Get.snackbar('Error', 'Failed to place order. Please try again later.');
      }
    } catch (e) {
      // Handle any exceptions
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      // Hide the loading spinner
      isPlacingOrder(false);
    }
  }

  // Handle payment method selection
  void paymentMethodSelect(int index) {
    paymentIndex.value = index;
  }
}
