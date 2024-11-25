import 'package:get/get.dart';

class CheckOutController extends GetxController {
  var isPlacingOrder = false.obs; // Tracks if the order is being placed
  var totalAmount = 0.obs; // Holds the total amount of the order
  var cartItems = <Map<String, dynamic>>[].obs; // Holds the cart items
  var paymentMethods = ['Cash On Delivery', 'Credit Card', 'bKash'].obs; // List of payment methods
  var selectedPaymentMethod = 0.obs; // Tracks selected payment method

  @override
  void onInit() {
    super.onInit();
    loadCartItems(); // Load cart items when the controller is initialized
  }

  // Method to load cart items (replace with actual data)
  void loadCartItems() {
    // Mock cart data
    cartItems.assignAll([
      {'name': 'Product 1', 'price': 200},
      {'name': 'Product 2', 'price': 300},
    ]);

  }

  // Method to select payment method
  void selectPaymentMethod(int index) {
    selectedPaymentMethod.value = index;
  }

  // Method to place the order
  void placeOrder() async {
    isPlacingOrder(true);
    try {
      // Simulate order placement delay
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      Get.snackbar('Success', 'Order placed successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order');
    } finally {
      isPlacingOrder(false);
    }
  }
}
