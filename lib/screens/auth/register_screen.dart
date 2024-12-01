import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth/register_screen_controller.dart';
import '../../utils/AppColors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterScreenController controller =
        Get.put(RegisterScreenController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Create Account',
                    style: AppTextStyles.bodyTextLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign up to get started',
                    style: AppTextStyles.bodyTextSmall,
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(
                    controller: controller.nameController,
                    label: 'Name',
                    hintText: 'Enter your name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: controller.phoneController,
                    label: 'Phone Number',
                    hintText: 'Enter your phone number',
                    icon: Icons.phone,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length < 10 ||
                          value.length > 14) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: controller.passController,
                    label: 'Password',
                    hintText: 'Enter your password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: controller.confirmPassController,
                    label: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != controller.passController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  Obx(() {
                    return controller.loading.value
                        ? const Center(child: CircularProgressIndicator())
                        : _buildRegisterButton(context, controller);
                  }),
                  const SizedBox(height: 20),
                  _buildLoginOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyTextSmall,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
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
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildRegisterButton(
      BuildContext context, RegisterScreenController controller) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (controller.formKey.currentState?.validate() ?? false) {
            controller.createAccount(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
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
