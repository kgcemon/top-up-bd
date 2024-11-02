import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:top_up_bd/data/models/categoryModel.dart';



class GameController extends GetxController {
  var games = <CategoryModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchGames();
    super.onInit();
  }

  void fetchGames() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          'https://codmshopbd.com/myapp/api/item_and_amount_list.php?api_key=emon'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        games.value = jsonData.map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch data from server');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching data');
    } finally {
      isLoading(false);
    }
  }
}
