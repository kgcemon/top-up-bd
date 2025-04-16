import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/widget/loading_animation.dart';
import '../controller/checkout_controller.dart';
import '../utils/AppColors.dart';

class CheckOutScreen extends StatefulWidget {
  final String prices;
  final String productName;
  final String playerIDname;
  final String playerID;
  final String productID;

  const CheckOutScreen({
    super.key,
    required this.prices,
    required this.productName,
    required this.playerIDname,
    required this.playerID,
    required this.productID,
  });

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final CheckOutController checkOutController = Get.put(CheckOutController());
  TextEditingController paymentNumberController = TextEditingController();
  TextEditingController trxIDController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    checkOutController.loadPayment();
    checkOutController.load();
    super.initState();

  }

  void _showSmartPopup() async {
    bool shouldShowPopup = true;

    if (shouldShowPopup) {
      await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.grey,
                        size: 27,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "সতর্কতা",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "মা-বাবা অথবা অন্য কারো ফোন থেকে অনুমতি ছাড়া বিকাশে টাকা দিয়ে অর্ডার করলে ঐ ডায়মন্ড পাবেন না। আমারা যে কোন সময় ঐ বিকাশ নাম্বারে কল দিয়ে ভেরিফাই করবো তারপর অর্ডার ডেলিভারি করবো",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'ঠিক আছে',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }


  @override
  void dispose() {
    paymentNumberController.dispose();
    trxIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Checkout', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
        ),
      ),
    );
  }

  // Widget to display payment methods
  Widget _buildPaymentMethods(CheckOutController controller) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                height: 60,
                width: 85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.primaryColor)),
                child: FittedBox(
                    child: Text(
                  widget.playerIDname.isEmpty
                      ? widget.playerID
                      : widget.playerIDname,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      widget.productName,
                      style: AppTextStyles.bodyTextSmall.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Total: ${widget.prices}',
                    style: AppTextStyles.bodyTextSmall.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for payment details (Trx ID and Number fields)
  Widget _buildPaymentDetails(
      CheckOutController controller, double screenWidth) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => controller.paymentMethods.isEmpty
            ? const LoadingAnimation()
            : Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    'কিসে সেন্ড মানি করবেন সিলেক্ট করুন?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  GetBuilder<CheckOutController>(
                    builder: (controllers) => controller.paymentMethods.isEmpty
                        ? const LoadingAnimation()
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.paymentMethods.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: screenWidth > 600 ? 4 : 3,
                              mainAxisExtent: 70,
                            ),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Obx(
                                () => InkWell(
                                  onTap: () {
                                    print(checkOutController.paymentMethods[index].paymentName);
                                    String payName = checkOutController.paymentMethods[index].paymentName;
                                    if( payName.contains('bKash')){
                                      print("object");
                                      _showSmartPopup();
                                    }
                                    checkOutController.paymentIndex.value =
                                        index;
                                    checkOutController
                                            .selectedPaymentImg.value =
                                        "https://codmshopbd.com/myapp/${controller.paymentMethods[index].img}";
                                    print(checkOutController
                                        .selectedPaymentImg.value);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: index ==
                                              checkOutController
                                                  .paymentIndex.value
                                          ? AppColors.primaryColor.withOpacity(0.85)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: index ==
                                                  checkOutController
                                                      .paymentIndex.value
                                              ? AppColors.primaryColor
                                              : AppColors.primaryColor),
                                    ),
                                    child: Image.network(
                                        "https://codmshopbd.com/myapp/${controller.paymentMethods[index].img}"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  Text(
                    controller.paymentMethods[controller.paymentIndex.value]
                        .paymentName,
                    style: AppTextStyles.bodyTextMedium,
                  ),
                  InkWell(
                    onTap: () => _copyText(controller
                        .paymentMethods[controller.paymentIndex.value].number),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller
                              .paymentMethods[controller.paymentIndex.value]
                              .number,
                          style: AppTextStyles.bodyTextMedium,
                        ),
                        const Icon(Icons.copy, size: 20),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      controller
                          .paymentMethods[controller.paymentIndex.value].info,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  // "Number" field with validation
                  TextFormField(
                    controller: paymentNumberController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      label: const Text("Number"),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length < 11 ||
                          value.length > 15 ||
                          !value.contains("01")) {
                        return 'Please enter your number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // "Trx ID" field with validation
                  TextFormField(
                    controller: trxIDController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      label: const Text("Trx ID"),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length < 8 ||
                          value.length > 12) {
                        return 'Please enter the transaction ID';
                      }
                      return null;
                    },
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
                  if (_formKey.currentState!.validate()) {
                    controller.placeOrder(
                      productId: widget.productID,
                      bkash_number: paymentNumberController.text,
                      trxid: trxIDController.text,
                      userdata: widget.playerID,
                      itemtitle: widget.productName,
                      total: widget.prices,
                    );
                  }
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

  void _copyText(String text) {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      Get.snackbar(
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.white,
        "Copy Success",
        text,
      );
    }
  }
}
