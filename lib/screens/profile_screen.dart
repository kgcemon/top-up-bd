import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_contrroller.dart';
import '../utils/AppColors.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final OrderController orderController = Get.put(OrderController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTextStyles.bodyTextLarge.copyWith(color: AppColors.white),
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
                      Obx(() => _buildProfileInfo(
                          screenWidth,
                          orderController.userName.value,
                          orderController.userPhone.value),),
                      const SizedBox(height: 30),
                      _buildProfileOptions(context),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

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
            style: AppTextStyles.bodyTextLarge,
          ),
          const SizedBox(height: 8),
          Text(
            phone,
            style: AppTextStyles.bodyTextSmall.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Column(
      children: [
        _buildOption(
          icon: Icons.account_circle_outlined,
          label: 'Edit Profile',
          onTap: () {
            // Handle edit profile action
          },
        ),
        _buildDivider(),
        _buildOption(
          icon: Icons.lock_outline,
          label: 'Change Password',
          onTap: () {
            // Handle change password action
          },
        ),
        _buildDivider(),
        _buildOption(
          icon: Icons.notifications_outlined,
          label: 'Notifications',
          onTap: () {
            // Handle notifications settings
          },
        ),
        _buildDivider(),
        _buildOption(
          icon: Icons.settings_outlined,
          label: 'Settings',
          onTap: () {
            // Handle settings navigation
          },
        ),
      ],
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor, size: 28),
      title: Text(
        label,
        style:
            AppTextStyles.bodyTextMedium.copyWith(fontWeight: FontWeight.bold),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: AppColors.grey, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      thickness: 1,
      height: 10,
      color: Colors.grey,
    );
  }
}
