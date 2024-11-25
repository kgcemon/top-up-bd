import 'package:flutter/material.dart';
import '../utils/AppColors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.grey[100], // Reuse background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildProfileInfo(),
            const SizedBox(height: 40),
            _buildProfileOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
        ),
        const SizedBox(height: 20),
        Text(
          'John Doe', // Use dynamic user data if available
          style: AppTextStyles.bodyTextLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'johndoe@example.com', // Use dynamic email data if available
          style: AppTextStyles.bodyTextSmall.copyWith(color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          _buildOption(
            icon: Icons.account_circle_outlined,
            label: 'Edit Profile',
            onTap: () {
              // Handle edit profile action
            },
          ),
          _buildOption(
            icon: Icons.lock_outline,
            label: 'Change Password',
            onTap: () {
              // Handle change password action
            },
          ),
          _buildOption(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () {
              // Handle notifications settings
            },
          ),
          _buildOption(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () {
              // Handle settings navigation
            },
          ),
          _buildOption(
            icon: Icons.logout,
            label: 'Log Out',
            onTap: () {
              // Handle logout action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(
        label,
        style: AppTextStyles.bodyTextSmall.copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: AppColors.grey),
      onTap: onTap,
    );
  }
}
