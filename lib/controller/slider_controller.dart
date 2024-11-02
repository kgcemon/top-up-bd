import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SliderController extends GetxController {
  var sliderImages = <String>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchSliderImages();
    super.onInit();
  }

  void fetchSliderImages() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          'https://codmshopbd.com/myapp/api/sliderimageshow.php?api_key=emon'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        sliderImages.value = jsonData.cast<String>();
      } else {
        Get.snackbar('Error', 'Failed to fetch slider images');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching slider images');
    } finally {
      isLoading(false);
    }
  }
}
