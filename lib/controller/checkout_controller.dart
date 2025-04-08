import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:top_up_bd/networkCaller/NetworkCaller.dart';
import 'package:top_up_bd/utils/SharedPreferencesInstance.dart';
import 'package:top_up_bd/data/api_urls.dart';
import 'package:top_up_bd/screens/thank_you_screen.dart';
import '../data/models/UserModel.dart';
import '../data/models/payment_model.dart';
import 'auth/user_auth_controller.dart';

class CheckOutController extends GetxController {
  var isPlacingOrder = false.obs;
  var totalAmount = 0.obs;
  var paymentMethods = <PaymentModel>[].obs;
  var selectedPaymentMethod = 0.obs;
  var selectedPaymentImg = ''.obs;
  RxString? username = ''.obs;
  RxString userId = ''.obs;
  final formKey = GlobalKey<FormState>();

  RxInt paymentIndex = 0.obs;

  void load() async {
    UserData? userData = await AuthController.getUserData();
    String? userUID = userData?.user.id.toString();
    String? userName = userData?.user.username.toString();
    final mobileDeviceIdentifier = await MobileDeviceIdentifier().getDeviceId();
    print(mobileDeviceIdentifier);
    if (userUID == null) {
      await MobileDeviceIdentifier().getDeviceId().then(
        (value) async {
          userId.value = (userUID ?? value)!;
        },
      );
    }
    userId.value = userUID ?? mobileDeviceIdentifier.toString();
    username?.value = userName ?? 'Guest From New App';
  }

  // Load payment methods from the API
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
      var url =
          Uri.parse("${ApiUrls.mainUrls}/topupbd/add_order.php?api_key=emon");

      // Prepare request body
      var requestBody = {
        "product_id": productId,
        "username": username?.value,
        //"number": await SharedPreferencesInstance.sharedPreferencesGet("phonenumber") ?? '',
        "status": 'Processing',
        "user_id": userId.value,
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
          if (responseMap["status"]
              .toString()
              .contains("Transaction ID already used")) {
            Get.snackbar(
              'Error',
              responseMap["status"],
              backgroundColor: Colors.red,
              colorText: Colors.white,
              icon: const Icon(Icons.cancel, color: Colors.white),
            );
            username?.value = '';
            userId.value = '';
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
            String errorMessage =
                responseMap['message']?.toString() ?? 'Unknown error';
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

  void placeWalletDepositOrder({
    required String product,
    required String amount,
    required String paymentnumber,
    required String trxid,
  }) async {
    var token = await SharedPreferencesInstance.sharedPreferencesGet("token");

    if (paymentnumber.length > 10 &&
        paymentnumber.length < 13 &&
        trxid.length > 7 &&
        trxid.length < 12) {
      isPlacingOrder(true);
      var response = await NetworkCaller.postRequest(
          "https://app.codmshopbd.com/api/deposit-wallet", {
        "product": product,
        "amount": amount,
        "type": "bkash",
        "paymentnumber": paymentnumber,
        "trxid": trxid,
        "token": token
      });
      isPlacingOrder(false);
      if (response.responseBody["message"]
          .toString()
          .contains("Trx ID already exist")) {
        Get.snackbar(
          'Error',
          response.responseBody['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.cancel, color: Colors.white),
        );
      } else if (response.isSuccess) {
        Get.offAll(() => ThankYouScreen(
              orderID: response.responseBody['data']['id'].toString(),
              date: response.responseBody['data']['datetime'],
              total: response.responseBody['data']['total'],
              playerID: response.responseBody['data']['userdata'],
              product: response.responseBody['data']['itemtitle'],
              orderStatus: response.responseBody['data']['status'],
              paymentImg: selectedPaymentImg.value,
              paymentNumber: response.responseBody['data']['bkash_number'],
              trxID: response.responseBody['data']['trxid'],
            ));
      } else {
        Get.snackbar('Error', response.responseBody['message']);
      }
    }else{
      Get.snackbar(
          backgroundColor: Colors.red,
          colorText: Colors.white,
          'Error', 'সটিক নাম্বার এবং TRXID দিন',
        icon: const Icon(Icons.cancel, color: Colors.white),
      );
    }
  }
}
