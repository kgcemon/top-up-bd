import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/screens/home_screen.dart';
import 'package:top_up_bd/screens/auth/profile_screen.dart';
import '../controller/home_controller.dart';
import '../utils/AppColors.dart';
import '../widget/drawer.dart';
import 'auth/my_order_screen.dart';
import 'help_center_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    homeController.fetchProducts();
    homeController.fetchSliderImage();
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const MyOrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: _buildAppBar(),
      drawer: const MyAppDrawer(),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: _buildBottomNavigationBar(homeController),
      body: pages[homeController.selectedIndex.value],
    ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Top Up BD',
        style: AppTextStyles.appBarTitle,
      ),
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.white),
      actions: [
        TextButton.icon(
          icon: const Icon(
            Icons.headphones,size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(()=> const HelpCenterScreen());
          }, label: const Text(
          "Help Center",
          style: TextStyle(color: Colors.white,fontSize: 10),
        ),
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(HomeController homeController) {
    return BottomNavigationBar(
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
      onTap: homeController.changeTabIndex,
    );
  }
}
