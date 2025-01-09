import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/auth/order_contrroller.dart';
import '../screens/help_center_screen.dart';
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
            title: 'হোম',
            onTap: () {
              // Handle navigation to Home
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.newspaper,
            title: 'নোটিশ',
            onTap: () async {
              if (!await launchUrl(Uri.parse(
                  "https://codmshopbd.com/myapp/termsandconditions.html"))) {
                throw Exception('Could not launch');
              }
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.question_answer,
            title: 'Help Center',
            onTap: () {
              Get.to(() => const HelpCenterScreen());
            },
          ),
          _buildDrawerItem(
            icon: Icons.policy,
            title: 'Privacy Policy',
            onTap: () async {
              if (!await launchUrl(
                  Uri.parse("https://codmshopbd.com/privacy-policy.php"))) {
                throw Exception('Could not launch');
              }
              Get.back();
            },
          ),
          _buildDrawerItem(
            icon: Icons.question_answer,
            title: 'কিভাবে অর্ডার করবেন',
            onTap: () async {
              if (!await launchUrl(Uri.parse(
                  "https://youtu.be/bjEzsIzLBjA?si=8avK0o5giBuS_gyC"))) {
                throw Exception('Could not launch');
              }
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.branding_watermark_sharp,
            title: 'Terms & Conditions',
            onTap: () async {
              if (!await launchUrl(Uri.parse(
                  "https://codmshopbd.com/myapp/termsandconditions.html"))) {
                throw Exception('Could not launch');
              }
              Navigator.pop(context);
            },
          ),

        ],
      ),
    );
  }

  Widget _buildDrawerHeader(OrderController controller) {
    return Obx(
      () => UserAccountsDrawerHeader(
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
        ),
        accountName: Text(
          controller.userName.value.isEmpty
              ? "Login Fast"
              : controller.userName.value,
          style: const TextStyle(fontSize: 14),
        ),
        accountEmail: Text(
          controller.userPhone.isEmpty ? "" : controller.userPhone.value,
          style: AppTextStyles.bodyTextSmall.copyWith(color: AppColors.white),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Text(
            controller.userName.value.isNotEmpty
                ? controller.userName.value.toString()[0].toUpperCase()
                : "T",
            style: AppTextStyles.bodyTextLarge.copyWith(color: AppColors.black),
          ),
        ),
      ),
    );
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
        style: AppTextStyles.bodyTextSmall.copyWith(color: AppColors.black),
      ),
      onTap: onTap,
    );
  }
}
