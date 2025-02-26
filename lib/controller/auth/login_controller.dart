import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:top_up_bd/controller/auth/order_contrroller.dart';
import 'dart:convert';  // Moved jsonDecode here for clarity
import '../../utils/SharedPreferencesInstance.dart';
import '../../data/api_urls.dart';

class LoginController extends GetxController {
  final RxBool loading = false.obs;  // Keep loading reactive
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  RxMap<String, dynamic> accountResult = RxMap<String, dynamic>({});// Reactive map for result



  Future<void> googleSignIn() async {
    try {
      loading.value = true;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print("${googleUser?.id} emon");
      if (googleUser != null) {
        await SharedPreferencesInstance.sharedPreferencesSet('userID', googleUser.id);
        await SharedPreferencesInstance.sharedPreferencesSet('username', googleUser.displayName);
        await SharedPreferencesInstance.sharedPreferencesSet('phonenumber', googleUser.email);
        await SharedPreferencesInstance.sharedPreferencesSet('img', googleUser.photoUrl);
        Get.put(OrderController()).userID.value = googleUser.id;
        Get.put(OrderController()).showProfileOrder();
        Get.put(OrderController()).load();
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> loginAccount(BuildContext context) async {
    loading.value = true;  // Set loading true initially
    try {
      final http.Response response = await http.post(
        Uri.parse("${ApiUrls.mainUrls}/login.php"),
        body: {
          "phonenumber": phoneController.text.trim(),
          "password": passController.text.trim()
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);

        if (body['status'] == 'success') {
          final Map<String, dynamic> userData = body['user_data'];
          await SharedPreferencesInstance.sharedPreferencesSet('userID', userData['id']);
          await SharedPreferencesInstance.sharedPreferencesSet('username', userData['username']);
          await SharedPreferencesInstance.sharedPreferencesSet('phonenumber', userData['phonenumber']);
          accountResult.value = body;
          Get.put(OrderController()).userID.value = userData['id'];
          Get.put(OrderController()).showProfileOrder();
          Get.put(OrderController()).load();
          Get.snackbar('Success', body['message']);
        } else {
          Get.snackbar(backgroundColor: Colors.white,'Login Failed', body['message']);  // Display error message if login fails
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');  // Handle any error
    } finally {
      loading.value = false;  // Set loading false after request completion
    }
  }

  @override
  void onClose() {
    // Dispose controllers when not needed
    phoneController.dispose();
    passController.dispose();
    super.onClose();
  }
}
