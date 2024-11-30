import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth/order_contrroller.dart';
import '../utils/AppColors.dart';


class MyAppDrawer extends StatefulWidget {
  const MyAppDrawer({super.key});

  @override
  State<MyAppDrawer> createState() => _MyAppDrawerState();
}

class _MyAppDrawerState extends State<MyAppDrawer> {

  final OrderController orderController = Get.put(OrderController());


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDrawerHeader(orderController),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () {
              // Handle navigation to Home
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.shopping_cart,
            title: 'My Orders',
            onTap: () {
              // Handle navigation to My Orders
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.account_circle,
            title: 'Profile',
            onTap: () {
              // Handle navigation to Profile
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              // Handle navigation to Settings
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // Handle logout
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(OrderController controller) {
    return Obx(() => UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
      ),
      accountName: Text(
        controller.userName.isEmpty ? "Login Fast" : controller.userName.value,
        style: const TextStyle(fontSize: 14),
      ),
      accountEmail: Text(
        controller.userPhone.isEmpty ? "" : controller.userPhone.value,
        style: AppTextStyles.bodyTextSmall.copyWith(color: AppColors.white),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Text(
          'JD',
          style: AppTextStyles.bodyTextLarge.copyWith(color: AppColors.black),
        ),
      ),
    ),);
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(
        title,
        style: AppTextStyles.bodyTextMedium.copyWith(color: AppColors.black),
      ),
      onTap: onTap,
    );
  }
}
