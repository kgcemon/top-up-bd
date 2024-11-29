import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/get_core.dart';
import '../utils/AppColors.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Reuse background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50), // Adds top spacing
                const Text(
                  'Create Account',
                  style: AppTextStyles.bodyTextLarge,  // Reuse large text style
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign up to get started',
                  style: AppTextStyles.bodyTextSmall,  // Reuse small text style
                ),
                const SizedBox(height: 40),
                _buildTextField(
                  label: 'Name',
                  hintText: 'Enter your name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                _buildRegisterButton(context),
                const SizedBox(height: 20),
                _buildLoginOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyTextSmall,  // Reuse text style for labels
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primaryColor),
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Handle registration action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,  // Reuse primary color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          'Register',
          style: TextStyle(
            color: AppColors.white,  // Reuse white color for text
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(fontSize: 14, color: AppColors.grey),
        ),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
