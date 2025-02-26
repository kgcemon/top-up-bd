import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:top_up_bd/data/api_urls.dart';

import '../data/models/news_model.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var products = [].obs;
  var news = <NewsModel>[].obs;
  var isLoading = true.obs;
  var playerIsLoading = false.obs;
  int selectedProductIndex = -1;
  RxString homeImage = ''.obs;
  RxString playerID = ''.obs;
  RxString catName = ''.obs;


  // Function to fetch products from the API
  void fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiUrls.mainUrls}/topupbd/topupbd.php?category_id=15'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (kDebugMode) {
          print(data);
        }
        catName.value = data['data']['category']['catagory_name'];
        products.value = data['data']['products'];
      } else {
        Get.snackbar('Error', 'Failed to load products');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  fetchNews() async {
    try {
   if(news.isEmpty){
     final response =
     await http.get(Uri.parse("https://codmshopbd.com/myapp/newsapi.php"));
     if (response.statusCode == 200) {
       List data = jsonDecode(response.body);
       for (var element in data) {
         news.add(NewsModel.fromJson(element));
       }
     }
   }
    } catch (e) {
      Get.snackbar("Error", "$e");
    }
  }

  void fetchSliderImage() async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrls.sliderImageUrls),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        homeImage.value = "https://codmshopbd.com/myapp/${data[0]}";
        if (kDebugMode) {
          print(homeImage.value);
        }
      } else {}
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  void selectProduct(int index) {
    selectedProductIndex = index;
    update();
  }

  Future<bool> playerIdCheck({required String uid}) async {
    if (kDebugMode) {
      print(uid);
    }
    playerIsLoading.value = true;
    playerID.value = '';
    try {
      var response = await http.get(
        Uri.parse(
          ApiUrls.uidChecker(uid),
        ),
      );
      playerIsLoading.value = false;
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        bool isValid = data['error'] != null &&
            !data['error']
                .toString()
                .contains("HTTP Error during POST request");
        bool isValidRegion = data['region'] != null && data['region'] != "BD";
        if (isValid) {
          playerID.value = "আইডি ভুল সঠিক আইডি দিন";
          return false;
        } else if (isValidRegion) {
          playerID.value = "Give only Bangladeshi Uid";
          return false;
        } else {
          Get.back();
          playerID.value = data['nickname'];
          playerIsLoading.value = false;
          return true;
        }
      } else if (response.statusCode == 200 &&
          response.body.contains("HTTP Error during POST request")) {
        return true;
      } else if (response.statusCode == 500) {
        return true;
      } else {
        playerIsLoading.value = false;
        return true;
      }
    } catch (e) {
      // Catch any errors (network issues, JSON issues, etc.)
      playerIsLoading.value = false;
      if (kDebugMode) {
        print("Error occurred: $e");
      }
      return true; // Return false in case of an error
    }
  }
}
