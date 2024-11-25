import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/checkout_controller.dart';
import '../utils/AppColors.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CheckOutController checkOutController = Get.put(CheckOutController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(checkOutController),
            const SizedBox(height: 20),
            _buildPaymentMethods(checkOutController),
            const Spacer(),
            _buildPlaceOrderButton(checkOutController),
          ],
        ),
      ),
    );
  }

  // Widget to display order summary
  Widget _buildOrderSummary(CheckOutController controller) {
    return Obx(
          () => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Summary',
                style: AppTextStyles.bodyTextSmall,
              ),
              const SizedBox(height: 10),
              Text(
                'Total: ${controller.totalAmount.value} BDT',
                style: AppTextStyles.bodyTextSmall.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return ListTile(
                    title: Text(item['name'], style: AppTextStyles.productTitle),
                    trailing: Text('${item['price']} BDT',
                        style: AppTextStyles.productPrice),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display payment methods
  Widget _buildPaymentMethods(CheckOutController controller) {
    return Obx(
          () => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Methods',
                style: AppTextStyles.bodyTextSmall,
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.paymentMethods.length,
                itemBuilder: (context, index) {
                  final paymentMethod = controller.paymentMethods[index];
                  return ListTile(
                    leading: Radio(
                      value: index,
                      groupValue: controller.selectedPaymentMethod.value,
                      onChanged: (int? value) {
                        controller.selectPaymentMethod(value!);
                      },
                    ),
                    title: Text(paymentMethod, style: AppTextStyles.productTitle),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for "Place Order" button
  Widget _buildPlaceOrderButton(CheckOutController controller) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
            () => ElevatedButton(
          onPressed: controller.isPlacingOrder.value
              ? null
              : () {
            controller.placeOrder();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: AppColors.primaryColor,
            disabledBackgroundColor: AppColors.grey,
          ),
          child: controller.isPlacingOrder.value
              ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
          )
              : const Text('Place Order', style: AppTextStyles.bodyTextSmall),
        ),
      ),
    );
  }
}
