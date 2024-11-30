import 'dart:convert';
import 'package:get/get.dart';
import 'package:top_up_bd/SharedPreferencesInstance.dart';
import 'package:top_up_bd/data/api_urls.dart';
import 'package:top_up_bd/data/models/order_model.dart';
import 'package:http/http.dart' as http;

class OrderController extends GetxController {
  var isLoading = true.obs; // To track the loading state
  var orders = <OrderModel>[].obs; // To store fetched orders
  RxString userID = ''.obs;
  RxString userName = ''.obs;
  RxString userPhone = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
    showProfileOrder();
  }

  load()async{
   userID.value = await  SharedPreferencesInstance.sharedPreferencesGet("userID") ?? '';
   userName.value = await  SharedPreferencesInstance.sharedPreferencesGet("username") ?? '';
   userPhone.value = await  SharedPreferencesInstance.sharedPreferencesGet("phonenumber") ?? '';
   print(userPhone.value);
   print(userName.value);
  }


   Future showProfileOrder() async {
    isLoading.value = true;
    List<OrderModel> myFullData = [];
      http.Response response = await http
          .post(Uri.parse("${ApiUrls.mainUrls}/showprofileorder.php?api_key=emon"), body: {
        "user_id": await SharedPreferencesInstance.sharedPreferencesGet('userID') ?? userID.value
      });
      Map body = jsonDecode(response.body);
      print(body);
      List myList = body['data'];
      for (var element in myList) {
        myFullData.add(OrderModel.fromJson(element));
      }
    isLoading.value = false;
      orders.value = myFullData;
  }
}
