import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:top_up_bd/data/models/UserModel.dart';
import 'package:top_up_bd/utils/SharedPreferencesInstance.dart';
import 'package:top_up_bd/data/api_urls.dart';
import 'package:http/http.dart' as http;
import '../../data/models/order_history_model.dart';
import '../../utils/AppColors.dart';
import 'user_auth_controller.dart';

class OrderController extends GetxController {
  RxString imgUrl = ''.obs;
  var isLoading = true.obs;
  var orders = <OrderData>[].obs; // Now using OrderData type
  RxString userID = ''.obs;
  RxString userName = ''.obs;
  RxString userPhone = ''.obs;
  Rx<Pagination?> pagination = Rx<Pagination?>(null); // Holds pagination data
  RxBool isFetchingNextPage = false.obs;
  Rx<OrderData?> problemOrderData = Rx<OrderData?>(null);
  RxBool haveProblem = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();

  }

  // Method to initialize user data and device ID
  load() async {
    try {
      UserData? userData = await AuthController.getUserData();
      String? userUID = userData?.user.id.toString();

      // Fetch device ID
      String? deviceID = await MobileDeviceIdentifier().getDeviceId();
      userID.value =
          userUID ?? deviceID ?? ''; // Ensuring userID is always non-null

      userName.value = userData?.user.username ?? '';
      userPhone.value = userData?.user.phonenumber ?? '';

      // Retrieve profile image URL
      imgUrl.value =
          await SharedPreferencesInstance.sharedPreferencesGet("img") ?? '';

      // Fetch and display orders
      showProfileOrder().then((value) => checkProblemOrder(),);
    } catch (e) {
      print("Error during load: $e");
    }
  }

  // Fetch and display the user's orders
  Future<void> showProfileOrder({int page = 1}) async {
    if (userID.value.isEmpty) {
      print('User ID is not available.');
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        headers: {"accept": "application/json"},
        Uri.parse("${ApiUrls.mainUrls2}/my-orders/${userID.value}?page=$page"),
      );

      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);

        if (body.containsKey('status') && body['status'] == true) {
          OrderResponse orderResponse = OrderResponse.fromJson(body);

          if (page == 1) {
            orders.value = orderResponse.data; // First page, reset list
          } else {
            orders.addAll(
                orderResponse.data); // Append additional data for next pages
          }

          pagination.value = orderResponse.pagination;
        } else {
          print('No data found or request failed');
        }
      } else {
        print('Failed to load orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching orders: $e');
    } finally {
      isLoading.value = false;
      isFetchingNextPage.value = false; // Reset fetching flag
    }
  }

  // Checks if more data is available based on pagination
  bool get hasMoreData {
    return pagination.value != null &&
        pagination.value!.currentPage < pagination.value!.lastPage;
  }

  // Loads the next page of orders
  Future<void> loadNextPage() async {
    if (hasMoreData && !isFetchingNextPage.value) {
      isFetchingNextPage.value = true;
      int nextPage = pagination.value!.currentPage + 1;
      await showProfileOrder(page: nextPage);
    }
  }

  checkProblemOrder() {
    for (var element in orders) {
        if(element.status == 'Auto Failed'){
          Get.dialog(Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                            Get.back();
                        },
                        child: const Icon(
                          Icons.cancel_rounded,
                          color: Colors.grey,
                          size: 27,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "অর্ডার নাম্বার ${element.id ?? ''} ",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${element.userdata}"" ${element.api_response!['message'].toString().contains("Invalid") ? 'এই প্লেয়ার আইডি ভুল দিয়েছেন তাই ডেলিভারি হচ্ছে না দয়া করে 01828861788 এই নাম্বারে whatsApp এ অর্ডার নাম্বার এবং সঠিক আইডি দিন ভুল হওয়া অর্ডার রাত ১০ টায় দেওয়া হয় তাই রাত ১০ টার আগেই যোগাযোগ করুন' : element.api_response!['message'].toString()}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'ঠিক আছে',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          problemOrderData.value = element;
          haveProblem.value = true;
        }
      }
  }
}
