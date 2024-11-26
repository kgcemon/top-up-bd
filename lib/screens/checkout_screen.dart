import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/widget/loading_animation.dart';
import '../controller/checkout_controller.dart';
import '../utils/AppColors.dart';

class CheckOutScreen extends StatefulWidget {
  final img;
  final prices;
  final productName;

  const CheckOutScreen(
      {super.key,
        required this.img,
        required this.prices,
        required this.productName});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final CheckOutController checkOutController = Get.put(CheckOutController());

  @override
  void initState() {
    checkOutController.loadPayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPaymentMethods(checkOutController),
              SizedBox(height: screenHeight * 0.02),
              _buildPaymentDetails(checkOutController, screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildPlaceOrderButton(checkOutController),
            ],
          ),
        ),
      ),
    );
  }


  // Widget to display payment methods
  Widget _buildPaymentMethods(CheckOutController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product: ${widget.productName}',
                style: AppTextStyles.bodyTextSmall.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Total: ${widget.prices} BDT',
                style: AppTextStyles.bodyTextSmall.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for payment details (Trx ID and Number fields)
  Widget _buildPaymentDetails(CheckOutController controller, double screenWidth) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => controller.paymentMethods.isEmpty? const LoadingAnimation() : Column(
          children: [
            const Text(
              'কিসে পেমেন্ট করবেন সিলেক্ট করুন?',
              style: AppTextStyles.bodyTextSmall,
            ),
            const SizedBox(height: 10),
            GetBuilder<CheckOutController>(
              builder: (controllers) => controller.paymentMethods.isEmpty
                  ? const LoadingAnimation()
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.paymentMethods.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 4 : 3,
                  mainAxisExtent: 70,
                ),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Obx(() => InkWell(
                    onTap: () => checkOutController.paymentIndex.value = index,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: index == checkOutController.paymentIndex.value ? AppColors.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: index == checkOutController.paymentIndex.value ? AppColors.primaryColor : AppColors.primaryColor),
                      ),
                      child: Image.network(
                          "https://codmshopbd.com/myapp/${controller.paymentMethods[index].img}"),
                    ),
                  ),),
                ),
              ),
            ),
            Text(
              "${controller.paymentMethods[controller.paymentIndex.value].paymentName} Send Money",
              style: AppTextStyles.bodyTextMedium,
            ),
            Text(
              controller.paymentMethods[controller.paymentIndex.value].number,
              style: AppTextStyles.bodyTextMedium,
            ),
            Text(
              controller.paymentMethods[controller.paymentIndex.value].info,
              style: AppTextStyles.bodyTextSmall,
            ),
            TextField(
              controller: controller.playerIDController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.white,
                label: const Text("Number"),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.white,
                label: const Text("Trx ID"),
              ),
            ),
          ],
        )),
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
              : const Text('Place Order',
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
