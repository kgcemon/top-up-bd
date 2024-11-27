import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:top_up_bd/data/api_urls.dart';
import 'package:top_up_bd/screens/thank_you_screen.dart';
import '../data/models/payment_model.dart';

class CheckOutController extends GetxController {
  var isPlacingOrder = false.obs;
  var totalAmount = 0.obs;
  var paymentMethods = <PaymentModel>[].obs;
  var selectedPaymentMethod = 0.obs;
  final formKey = GlobalKey<FormState>();

  RxInt paymentIndex = 0.obs;

  void loadPayment() async {
    if (paymentMethods.isEmpty) {
      var response = await http
          .get(Uri.parse("${ApiUrls.mainUrls}/paymentapi.php?api_key=emon"));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        for (var element in data) {
          paymentMethods
              .add(PaymentModel.fromJson(element as Map<String, dynamic>));
        }
        update();
      }
    }
  }

  // Method to select payment method
  void selectPaymentMethod(int index) {
    selectedPaymentMethod.value = index;
  }

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

    // Show loading spinner
    isPlacingOrder(true);
    try {
      // API URL
      var url = Uri.parse("${ApiUrls.mainUrls}/add_order.php?api_key=emon");

      // Prepare request body
      var requestBody = {
        "product_id": productId,
        "username": "emon",
        "number": "018255555444",
        "status": 'Processing',
        "user_id": "555",
        "bkash_number": bkash_number,
        "trxid": trxid,
        "userdata": userdata,
        "itemtitle": itemtitle,
        "total": total,
        "token": "token",
      };

      // Send POST request
      var response = await http.post(url, body: requestBody);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Check if the response is a List
        if (responseData is List) {
          // Access the first element of the list
          var responseMap = responseData[0];

          // Debugging: Print the map
          print("Response Map: $responseMap");

          bool trxIDAlreadyUsed = responseMap["status"]
              .toString()
              .contains("Transaction ID already used. Please try again");

          if (trxIDAlreadyUsed) {
            Get.snackbar(
                backgroundColor: Colors.red,
                colorText: Colors.white,
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                'Error',
                responseMap["status"]);
          } else if (responseMap['status'] == 'sucess') {
            print("Order placed: $responseMap");


            // Show success message
            Get.snackbar('Success', 'Order placed successfully!');

            // Navigate to thank you screen
            Get.offAll(() => const ThankYouScreen());
          } else {
            String errorMessage =
                responseMap['message']?.toString() ?? 'Unknown error';
            Get.snackbar('Error', 'Failed to place order: $errorMessage');
          }
        } else {
          print("Unexpected response format: Not a List");
          Get.snackbar(
              'Error', 'Failed to place order. Invalid response format.');
        }
      } else {
        print("Error: Received status code ${response.statusCode}");
        Get.snackbar('Error', 'Failed to place order. Please try again later.');
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar('Error',
          'An error occurred while placing the order. Please check your connection.');
    } finally {
      // Hide loading spinner
      isPlacingOrder(false);
    }
  }

  void paymentMethodSelect(int index) {
    paymentIndex.value = index;
  }
}
