import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/screens/main_nav_screen.dart';
import '../utils/AppColors.dart';
import 'dart:async'; // Import for Timer

class ThankYouScreen extends StatefulWidget {
  final String orderID;
  final String date;
  final String total;
  final String playerID;
  final String product;
  final String orderStatus;

  const ThankYouScreen(
      {super.key,
      required this.orderID,
      required this.date,
      required this.total,
      required this.playerID,
      required this.orderStatus,
      required this.product});

  @override
  _ThankYouScreenState createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  late Timer _timer;
  int _remainingTime = 180; // 3 minutes in seconds

  @override
  void initState() {
    super.initState();
    // Check for "Auto Topup" instead of "processing"
    if (widget.orderStatus == "processing") {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  String get _formattedTime {
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
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
      backgroundColor: Colors.white, // Reuse background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildThankYouIcon(),
            // const SizedBox(height: 20),
            // _buildThankYouMessage(),
            const SizedBox(height: 10),
            // Show countdown only for "Auto Topup"
            if (widget.orderStatus == "processing") _buildCountdownTimer(),
            _buildOrderSummary(),
            const Spacer(),
            _buildContinueShoppingButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThankYouIcon() {
    return const Icon(
      Icons.check_circle_outline,
      color: AppColors.primaryColor,
      size: 80,
    );
  }

  Widget _buildThankYouMessage() {
    return Column(
      children: [
        Text(
          'Thank You!',
          style: AppTextStyles.bodyTextLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Your order has been placed successfully.',
          style: AppTextStyles.bodyTextSmall.copyWith(color: AppColors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
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

  Widget _buildCountdownTimer() {
    return _formattedTime == "0:00"
        ? const Padding(
          padding: EdgeInsets.only(bottom: 18.0,),
          child: Text(
              "data",
              style: AppTextStyles.bodyTextMedium,
            ),
        )
        : Container(
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
                  'Auto Topup in Progress...',
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
                    _formattedTime,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
