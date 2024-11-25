import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var products = [].obs;
  var isLoading = true.obs;
  int selectedProductIndex = -1;
  RxString homeImage = ''.obs;


  // Function to fetch products from the API
  void fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://codmshopbd.com/myapp/api/topupbd/topupbd.php?category_id=15'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

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


  // Function to fetch products from the API
  void fetchSliderImage() async {
    try {
      final response = await http.get(
        Uri.parse('https://codmshopbd.com/myapp/api/sliderimageshow.php?api_key=emon'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        homeImage.value = "https://codmshopbd.com/myapp/${data[0]}";
        print(homeImage.value);
      } else {
      }
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
}
