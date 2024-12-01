import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/screens/home_screen.dart';
import 'package:top_up_bd/screens/auth/profile_screen.dart';
import '../controller/home_controller.dart';
import '../utils/AppColors.dart';
import 'auth/my_order_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {

  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    homeController.fetchProducts();
    homeController.fetchSliderImage();
    super.initState();
  }

  List<Widget> pages = [const HomeScreen(), const MyOrdersScreen(),const ProfileScreen(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: _buildBottomNavigationBar(homeController),
      body: Obx(() => pages[homeController.selectedIndex.value],),
    );
  }
}


Obx _buildBottomNavigationBar(HomeController homeController) {
  return Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'হোম',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz),
          label: 'অর্ডার হিস্টোরি',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'প্রোফাইল',
        ),
      ],
      currentIndex: homeController.selectedIndex.value,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.unselectedItemColor,
      // Reuse unselected item color
      onTap: homeController.changeTabIndex,
    ),
  );
}
