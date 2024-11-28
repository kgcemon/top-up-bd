import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/screens/main_nav_screen.dart';
import '../utils/AppColors.dart';

class ThankYouScreen extends StatelessWidget {
  final String orderID;
  final String date;
  final String total;
  final String playerID;
  final String product;

  const ThankYouScreen(
      {super.key,
      required this.orderID,
      required this.date,
      required this.total,
      required this.playerID,
      required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Order Complete',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100], // Reuse background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            _buildThankYouIcon(),
            const SizedBox(height: 20),
            _buildThankYouMessage(),
            const SizedBox(height: 40),
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
          _buildOrderDetailsRow('Order ID:', '$orderID '),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('Player Id:', playerID),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('Product:', '$product '),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('Total:', '$total '),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('Date:', date),
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
}
