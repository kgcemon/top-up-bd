import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:top_up_bd/controller/auth/order_contrroller.dart';
import 'package:top_up_bd/controller/auth/profile_Controller.dart';
import 'package:top_up_bd/controller/home_controller.dart';
import 'package:top_up_bd/data/models/UserModel.dart';
import 'package:top_up_bd/controller/auth/user_auth_controller.dart';
import '../../networkCaller/NetworkCaller.dart';
import '../../utils/SharedPreferencesInstance.dart';
import '../../data/api_urls.dart';

class LoginController extends GetxController {
  final RxBool loading = false.obs;  // Keep loading reactive
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();



  Future<void> googleSignIn() async {
    try {
      loading.value = true;

      // Google Sign-In Process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Network request to login with Google token
        var response = await NetworkCaller.postRequest('${ApiUrls.mainUrls2}/login-with-google', {
          "token": googleAuth.idToken,
        });

        if (response.statusCode == 200) {
          // Save user data and token
          AuthController.saveUserData(UserData.fromJson(response.responseBody));
          AuthController.saveUserToken(response.responseBody['token'].toString());

          final Map<String, dynamic> body = response.responseBody;
          final Map userData = body['user'];

          // Check if user data is not empty
          if (userData.isNotEmpty) {
            String userIUD = userData['id'].toString();
            // Update OrderController with user ID and load profile orders
            OrderController orderController = Get.put(OrderController());
            orderController.userID.value = userIUD;
            orderController.showProfileOrder();
            orderController.load();
            Get.put(HomeController()).isLoginUsers();
            // Show success message
            Get.snackbar('Success', body['message']);

            // Save Google user photo URL to shared preferences
            if (googleUser.photoUrl != null) {
              await SharedPreferencesInstance.sharedPreferencesSet('img', googleUser.photoUrl);
            }
          }
        } else {
          // Show error message if response is not successful
          Get.snackbar('Error', response.responseBody['message'] ?? 'Login failed');
        }

        // Sign in with Firebase using Google credentials
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
        } catch (firebaseError) {
          // Handle Firebase sign-in error
          Get.snackbar('Firebase Error', firebaseError.toString());
        }
      }
    } catch (e) {
      // General error handling
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false; // Loading indicator turned off
    }
  }


  Future<void> loginAccount(BuildContext context) async {
    loading.value = true;
    try {
       var response = await NetworkCaller.postRequest('${ApiUrls.mainUrls2}/login',
         {
          "phone": phoneController.text.trim(),
          "password": passController.text.trim()
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.responseBody;
          final Map userData = body['user'];
        AuthController.saveUserData(UserData.fromJson(response.responseBody));
        AuthController.saveUserToken(response.responseBody['token']);
        String userIUD = userData['id'].toString();
        if(userData.isNotEmpty){
          Get.put(OrderController()).userID.value = userIUD;
          Get.put(OrderController()).showProfileOrder();
          Get.put(OrderController()).load();
          Get.put(ProfileController()).showBalance();
          Get.snackbar('Success', body['message']);
        }

      }else if(response.statusCode == 404){
        print(response.errorMessage);
        Get.snackbar('Login Failed', "Number Or Password Wrong");
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error: $e');
    } finally {
      loading.value = false;
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
