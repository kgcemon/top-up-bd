import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:top_up_bd/data/api_urls.dart';

class RegisterScreenController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Add form key
  final RxBool loading = false.obs;

  // Text controllers for input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController =
      TextEditingController(); // Add confirm password controller


  /// Method to create an account
  Future<void> createAccount(BuildContext context) async {
    if (loading.value) return;

    try {
      loading.value = true;

      final response = await http.post(
        Uri.parse('${ApiUrls.mainUrls}/addaccount.php?api_key=emon'),
        body: {
          "username": nameController.text.trim(),
          "phonenumber": phoneController.text.trim(),
          "password": passController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print(response.body);
        if (body['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully please login!')),
          );
          Get.back();
        } else if (body['message'] ==
            "\u0986\u09aa\u09a8\u09be\u09b0 \u098f\u0987 \u09a8\u09be\u09ae\u09cd\u09ac\u09be\u09b0\u09c7 \u098f\u0995\u09be\u0989\u09a8\u09cd\u099f \u0995\u09b0\u09be \u0986\u099b\u09c7 \u09a6\u09df\u09be \u0995\u09b0\u09c7 \u09b2\u0997\u0987\u09a8 \u0995\u09b0\u09c1\u09a8") {
          Get.back();
          Get.snackbar(backgroundColor: Colors.white,"Message", "${body['message']}");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('${body['message']}',
                  style: const TextStyle(color: Colors.white)),
            ),
          );
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to create account.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      loading.value = false;
    }
  }
}
