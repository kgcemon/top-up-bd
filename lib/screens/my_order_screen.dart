import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/screens/login_screen.dart';

import '../controller/order_contrroller.dart';
import '../utils/AppColors.dart';
import '../widget/loading_animation.dart';


class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.put(OrderController());

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() => orderController.userID.value.isEmpty ? const LoginScreen() : orderController.isLoading.value
          ? const Center(child: LoadingAnimation())
          : _buildOrderList(orderController)),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('My Orders', style: AppTextStyles.appBarTitle),
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.white),
    );
  }

  Widget _buildOrderList(OrderController orderController) {
    if (orderController.orders.isEmpty) {
      return const Center(
        child: Text(
          "You have no orders.",
          style: AppTextStyles.bodyTextMedium,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: orderController.orders.length,
      itemBuilder: (context, index) {
        final order = orderController.orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderRow(
              label: 'Order No:',
              value: order['orderNumber'].toString(),
            ),
            const SizedBox(height: 8),
            _buildOrderRow(
              label: 'Date:',
              value: order['date'],
            ),
            const SizedBox(height: 8),
            _buildOrderRow(
              label: 'Status:',
              value: order['status'],
              statusColor: _getStatusColor(order['status']),
            ),
            const SizedBox(height: 8),
            _buildOrderRow(
              label: 'Amount:',
              value: '${order['amount']} BDT',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderRow({
    required String label,
    required String value,
    Color statusColor = AppColors.textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyTextSmall),
        Text(
          value,
          style: AppTextStyles.bodyTextSmall.copyWith(color: statusColor),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return AppColors.textColor;
    }
  }
}
