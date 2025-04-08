import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:top_up_bd/screens/order/order_destails_screen.dart';
import '../../controller/auth/order_contrroller.dart';
import '../../data/models/order_history_model.dart';
import '../../helper/TimeDifferenceMaker.dart';
import '../../utils/AppColors.dart';
import '../../widget/loading_animation.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final OrderController orderController = Get.put(OrderController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    load();
    _scrollController.addListener(_onScroll);
  }

  load() async {
    await MobileDeviceIdentifier().getDeviceId().then(
          (value) {
        print(value);
        orderController.showProfileOrder();
      },
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load the next page of data when the user scrolls to the bottom
      if (orderController.hasMoreData && !orderController.isLoading.value) {
        orderController.loadNextPage(); // Load more data
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(() => orderController.isLoading.value && orderController.orders.isEmpty
            ? const Center(child: LoadingAnimation())
            : RefreshIndicator(
          onRefresh: () {
            return orderController.load();
          },
          child: _buildOrderList(orderController),
        )),
      ),
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
      controller: _scrollController, // Attach ScrollController here
      padding: const EdgeInsets.all(16.0),
      itemCount: orderController.orders.length + (orderController.hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < orderController.orders.length) {
          final order = orderController.orders[index];
          return GestureDetector(
            onTap: () => Get.to(() => OrderDetailsScreen(order: order)),
            child: _buildOrderCard(order),
          );
        } else {
          // Show a loading indicator at the bottom of the list when loading more data
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
        }
      },
    );
  }

  Widget _buildOrderCard(OrderData order) {
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
              value: order.id.toString(),
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
            const SizedBox(height: 8),
            _buildOrderRow(
              label: 'Time:',
              value: timeAgo(DateTime.parse(order.created_at.toString())),
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
        Text(value.replaceAll("Auto Topup", "Delivery Running"),
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: statusColor)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'processing' || status == 'Payment Verified') {
      return Colors.orange;
    } else if (status == 'Completed' || status == 'Auto Completed') {
      return Colors.green;
    } else if (status == 'Auto Topup') {
      return Colors.lightBlue;
    } else {
      return Colors.red;
    }
  }
}
