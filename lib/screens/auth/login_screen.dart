import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/screens/auth/register_screen.dart';
import '../../controller/auth/login_controller.dart';
import '../../utils/AppColors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.grey[100], // Consistent background color
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey, // Assign the form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50), // Top spacing
                    const Text(
                      'Welcome Back',
                      style: AppTextStyles.bodyTextLarge,  // Use defined text style
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Login to your account',
                      style: AppTextStyles.bodyTextSmall,  // Use defined text style
                    ),
                    const SizedBox(height: 40),

                    // Phone Number TextFormField
                    _buildTextFormField(
                      isNumber: true,
                      controller: loginController.phoneController,
                      label: 'Phone Number',
                      hintText: 'Enter your phone number',
                      icon: Icons.phone_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        if (!RegExp(r'^[0-9]{10,}$').hasMatch(value)) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password TextFormField
                    _buildTextFormField(
                      controller: loginController.passController,
                      label: 'Password',
                      hintText: 'Enter your password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 3) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    // Login Button
                    Obx(() => _buildLoginButton(
                      context,
                      isLoading: loginController.loading.value,
                      onPressed: () {
                        // Validate the form
                        if (_formKey.currentState!.validate()) {
                          loginController.loginAccount(context);
                        }
                      },
                    )),
                    const SizedBox(height: 20),

                    // Sign Up Option
                    _buildSignUpOption(),
                    const SizedBox(height: 20),

                    // Google Sign-In Button
                    _buildGoogleSignInButton(loginController)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable TextFormField Widget with validation
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool isNumber = false,
    required String? Function(String?) validator, // Add validator as a parameter
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyTextSmall,  // Use defined text style
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 13),
            prefixIcon: Icon(icon, color: AppColors.primaryColor),
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
          ),
          validator: validator, // Assign validator
        ),
      ],
    );
  }

  // Login Button with loading indicator
  Widget _buildLoginButton(BuildContext context, {required bool isLoading, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,  // Disable button if loading
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          'Login',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Sign Up Option
  Widget _buildSignUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(fontSize: 14, color: AppColors.grey),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => const RegisterScreen());
          },
          child: const Text(
            'Sign Up',
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

  // Google Sign-In Button
  Widget _buildGoogleSignInButton(LoginController loginController) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: loginController.googleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: AppColors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Image.network(
          'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
          height: 24,
        ),
        label: const Text(
          'Sign in with Google',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
