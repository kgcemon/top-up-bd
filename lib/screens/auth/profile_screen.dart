import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth/order_contrroller.dart';
import '../../utils/AppColors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final OrderController orderController = Get.put(OrderController());

    // Group and count orders by status
    var processingOrders = orderController.orders
        .where((order) => order.status == "Processing")
        .toList();
    int processingOrdersLength = processingOrders.length;

    var completedOrders = orderController.orders
        .where((order) =>
            order.status == "Complete" || order.status == "Auto Completed")
        .toList();
    int completedOrdersLength = completedOrders.length;

    var canceledOrders = orderController.orders
        .where((order) => order.status == "পেমেন্ট না করায় ডিলেট করা হয়েছ")
        .toList();
    int canceledOrdersLength = canceledOrders.length;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(
        () => orderController.userID.value.isEmpty
            ? LoginScreen()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Obx(
                        () => _buildProfileInfo(
                          screenWidth,
                          orderController.userName.value,
                          orderController.userPhone.value,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildOrderStatistics(
                        context,
                        totalOrders: orderController.orders.length,
                        pendingOrders: processingOrdersLength,
                        canceledOrders: canceledOrdersLength,
                        completedOrders: completedOrdersLength,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // Builds profile information widget
  Widget _buildProfileInfo(double screenWidth, String name, String phone) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: screenWidth * 0.15,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: screenWidth * 0.15,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            phone,
            style: const TextStyle(color: AppColors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Builds the order statistics section
  Widget _buildOrderStatistics(
    BuildContext context, {
    required int totalOrders,
    required int pendingOrders,
    required int canceledOrders,
    required int completedOrders,
  }) {
    return Column(
      children: [
        _buildStatisticTile(
          icon: Icons.shopping_cart,
          label: 'Total Orders',
          value: '$totalOrders',
        ),
        _buildDivider(),
        _buildStatisticTile(
          icon: Icons.pending,
          label: 'Pending Orders',
          value: '$pendingOrders',
        ),
        _buildDivider(),
        _buildStatisticTile(
          icon: Icons.cancel,
          label: 'Canceled Orders',
          value: '$canceledOrders',
        ),
        _buildDivider(),
        _buildStatisticTile(
          icon: Icons.done,
          label: 'Completed Orders',
          value: '$completedOrders',
        ),
      ],
    );
  }

  // Builds a single statistic tile
  Widget _buildStatisticTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor, size: 28),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  // Divider widget for separating tiles
  Widget _buildDivider() {
    return const Divider(
      thickness: 1,
      height: 10,
      color: Colors.grey,
    );
  }
}
