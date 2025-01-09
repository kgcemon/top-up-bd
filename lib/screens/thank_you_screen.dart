import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/screens/main_nav_screen.dart';
import '../controller/thank_you_screen_controller.dart';
import '../utils/AppColors.dart';

class ThankYouScreen extends StatefulWidget {
  final String orderID;
  final String date;
  final String total;
  final String playerID;
  final String product;
  final String orderStatus;
  final String paymentImg;
  final String paymentNumber;
  final String trxID;

  const ThankYouScreen({
    super.key,
    required this.orderID,
    required this.date,
    required this.total,
    required this.playerID,
    required this.orderStatus,
    required this.product,
    required this.paymentImg,
    required this.paymentNumber,
    required this.trxID,
  });

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  // Initialize the controller
  final ThankYouController controller = Get.put(ThankYouController());

  @override
  void initState() {
    super.initState();
    controller.waitingForNotification(widget.orderID);
    // Start the countdown if orderStatus is "processing"
    if (widget.orderStatus == "Auto Topup") {
      controller.startCountdown(widget.orderID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Thank You',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildThankYouIcon(controller),
            const SizedBox(height: 10),
            Obx(() => controller.orderDelete.value
                ? const Card(
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                          'পেমেন্ট না করায় আপনার অর্ডার ডিলিট করা হয়েছে দয়া করে ভিডিও দেখে অর্ডার করুন',style: TextStyle(color: Colors.white),),
                    ))
                : const Text("")),
            if (widget.orderStatus == "Auto Topup" ||
                widget.orderStatus == "Payment Verified")
              _buildCountdownTimer(controller),
            _buildOrderSummary(controller),
            const SizedBox(height: 10,),

            paymentSumery(),


            const Spacer(),
            _buildContinueShoppingButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThankYouIcon(ThankYouController controller) {
    return Obx(() => controller.orderDelete.value
        ? const Icon(
            Icons.cancel,
            color: Colors.red,
            size: 80,
          )
        : const Icon(
            Icons.check_circle_outline,
            color: AppColors.primaryColor,
            size: 80,
          ));
  }

  Widget _buildOrderSummary(ThankYouController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          _buildOrderDetailsRow('Order ID:', '${widget.orderID} '),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('Player Id:', widget.playerID),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('Product:', '${widget.product} '),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('Total:', '${widget.total} '),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('Date:', widget.date),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyTextSmall.copyWith(color: AppColors.grey),
        ),
        Text(
          value,
          style: AppTextStyles.bodyTextSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueShoppingButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.offAll(() => const MainNavScreen());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
      ),
      child: const Text(
        'Continue Shopping',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCountdownTimer(ThankYouController controller) {
    return Obx(() => controller.remainingTime.value == 0 ||
            controller.orderStatus.value == true ||
            widget.orderStatus == "Payment Verified"
        ? Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Column(
              children: [
                Text(
                  controller.orderStatus.value == true
                      ? 'অভিনন্দন!'
                      : "আপনার অর্ডার রিসিভ হয়েছে",
                  style: AppTextStyles.bodyTextMedium,
                ),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: Text(widget.orderStatus == "Payment Verified"
                        ? "আপনার পেমেন্ট গ্রহণ করা হয়েছে। অনুগ্রহ করে ৫-১০ মিনিট অপেক্ষা করুন, আপনার অর্ডার সম্পূর্ণ করতে।"
                        : controller.orderStatus.value == true
                            ? "আমরা আনন্দের সাথে জানাচ্ছি যে আপনার ডায়মন্ড ডেলিভারি সম্পূর্ণ হয়েছে। আশা করছি, আপনি আমাদের সেবায় সন্তুষ্ট। \nআপনার যদি কোনো প্রশ্ন থাকে বা ভবিষ্যতে আরও কোনো সহায়তার প্রয়োজন হয়, আমাদের সাথে যোগাযোগ করতে দ্বিধা করবেন না।"
                            : controller.orderDelete.value
                                ? 'আমরা আপনার অর্ডার পেয়েছি আপনি যদি পেমেন্ট করে থাকেন ৫ থেকে ১০ মিনিটের মধ্যই আপনার অর্ডার ডেলিভারি দেওয়া হবে'
                                : "আমরা আপনার অর্ডার পেয়েছি আপনি যদি পেমেন্ট করে থাকেন ৫ থেকে ১০ মিনিটের মধ্যই আপনার অর্ডার ডেলিভারি দেওয়া হবে"),
                  ),
                )
              ],
            ),
          )
        : controller.orderDelete.value == false
            ? Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/delivery.gif",
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Top Up in Progress...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        "${controller.remainingTime.value ~/ 60}:${(controller.remainingTime.value % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Text(''));
  }

  paymentSumery(){
    return
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Image.network(widget.paymentImg,height: 35,width: 55,),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('Number:', widget.paymentNumber),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('TrxID:', '${widget.trxID} '),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
