import 'package:get/get.dart';
import 'package:top_up_bd/SharedPreferencesInstance.dart';

class OrderController extends GetxController {
  var isLoading = true.obs; // To track the loading state
  var orders = <Map<String, dynamic>>[].obs; // To store fetched orders
  RxString userID = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(); // Fetch orders when the controller is initialized
    load();
  }

  load()async{
   userID.value = await  SharedPreferencesInstance.sharedPreferencesGet("userID") ?? '';
  }

  // Method to fetch orders (you can replace this with your API call)
  void fetchOrders() async {
    try {
      isLoading(true); // Set loading to true while fetching data

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock orders data
      List<Map<String, dynamic>> fetchedOrders = [
        {
          'orderNumber': 123456,
          'date': '2024-11-01',
          'status': 'Pending',
          'amount': 500,
        },
        {
          'orderNumber': 654321,
          'date': '2024-11-02',
          'status': 'Completed',
          'amount': 1000,
        },
        {
          'orderNumber': 789012,
          'date': '2024-11-03',
          'status': 'Cancelled',
          'amount': 300,
        },
      ];

      // Update the orders list
      orders.assignAll(fetchedOrders);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch orders');
    } finally {
      isLoading(false); // Set loading to false after fetching
    }
  }
}
