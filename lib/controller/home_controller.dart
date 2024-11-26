import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:top_up_bd/data/api_urls.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var products = [].obs;
  var isLoading = true.obs;
  var playerIsLoading = false.obs;
  int selectedProductIndex = -1;
  RxString homeImage = ''.obs;
  RxString playerID = ''.obs;


  // Function to fetch products from the API
  void fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiUrls.mainUrls}/topupbd/topupbd.php?category_id=15'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
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
        Uri.parse(ApiUrls.sliderImageUrls),
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


  Future<bool> playerIdCheck({required String uid})async{
    playerIsLoading.value = true;
    var response = await http.get(Uri.parse("https://codzshop.com/uidchecker/new.php?id=$uid"));
    playerIsLoading.value = false;
    print(response.body);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      bool isValid = data['error'] != null;
      if(isValid){
        playerID.value = data['error'];
        return false;
      }else if(!isValid){
        playerID.value = data['nickname'];

        playerIsLoading.value = false;
      }
      return true;
    }else{
      playerIsLoading.value = false;
      return true;
    }
  }

}
