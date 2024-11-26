import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:top_up_bd/data/api_urls.dart';
import '../data/models/payment_model.dart';

class CheckOutController extends GetxController {
  var isPlacingOrder = false.obs;
  var totalAmount = 0.obs;
  var paymentMethods = <PaymentModel>[].obs;
  var selectedPaymentMethod = 0.obs;
  final formKey = GlobalKey<FormState>();
  final TextEditingController playerIDController = TextEditingController();
  RxInt paymentIndex = 0.obs;



  void loadPayment()async{
    if(paymentMethods.isEmpty){
      var response = await http.get(Uri.parse("${ApiUrls.mainUrls}/paymentapi.php?api_key=emon"));
      if(response.statusCode == 200){
        List data = jsonDecode(response.body);
        for (var element in data) {
          paymentMethods.add(PaymentModel.fromJson(element as Map<String, dynamic>));
        }
        update();
      }
    }
  }

  // Method to select payment method
  void selectPaymentMethod(int index) {
    selectedPaymentMethod.value = index;
  }

  // Method to place the order
  void placeOrder() async {
    isPlacingOrder(true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      playerIDController.clear();
      Get.snackbar('Success', 'Order placed successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order');
    } finally {
      isPlacingOrder(false);
    }
  }

  void paymentMethodSelect(int index){
    paymentIndex.value = index;
  }
}
