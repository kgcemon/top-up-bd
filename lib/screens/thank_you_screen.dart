import 'package:flutter/material.dart';

import '../utils/AppColors.dart';


class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Complete',
          style: AppTextStyles.bodyTextLarge,
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
          Text(
            'Order Summary',
            style: TextStyle(fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,),
          ),
          const SizedBox(height: 10),
          _buildOrderDetailsRow('Order ID:', '12345678'),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('Date:', '25 November 2024'),
          const SizedBox(height: 5),
          _buildOrderDetailsRow('Total:', 'BDT 1,200'),
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
        // Navigate to home or shopping screen
        Navigator.of(context).pop(); // Or implement proper navigation
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
        style: TextStyle(fontWeight: FontWeight.bold,
          color: Colors.white,),
      ),
    );
  }
}
