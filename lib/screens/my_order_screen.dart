import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/data/models/order_model.dart';
import 'package:top_up_bd/screens/auth/login_screen.dart';
import '../controller/order_contrroller.dart';
import '../utils/AppColors.dart';
import '../widget/loading_animation.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    orderController.showProfileOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() => orderController.userID.value.isEmpty
          ? LoginScreen()
          : orderController.isLoading.value
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

  Widget _buildOrderCard(OrderModel order) {
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
              value: order.id,
              isBold: true,
            ),
            const SizedBox(height: 8),
            _buildOrderRow(
              label: 'Product:',
              value: order.itemtitle,
              isBold: false,
            ),
            const SizedBox(height: 8),
            _buildOrderRow(
              label: 'Player ID:',
              value: order.userdata,
              isBold: false,
            ),
            const SizedBox(height: 8),
            _buildOrderRow(
              label: 'Status:',
              value: order.status,
              statusColor: _getStatusColor(order.status),
              isBold: false,
            ),
            const SizedBox(height: 8),
            _buildOrderRow(
              label: 'Amount:',
              value: '${order.total} BDT',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderRow({
    required String label,
    required String value,
    required bool isBold,
    Color statusColor = AppColors.textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyTextSmall),
        Text(value,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: statusColor)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'processing' || 'Payment Verified':
        return Colors.orange;
      case 'Completed' || 'Auto Completed':
        return Colors.green;
      case 'পেমেন্ট না করায় ডিলিট করা হয়েছে':
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}
