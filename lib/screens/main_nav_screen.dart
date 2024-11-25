import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/screens/home_screen.dart';
import 'package:top_up_bd/screens/login_screen.dart';
import '../controller/home_controller.dart';
import '../utils/AppColors.dart';
import '../widget/drawer.dart';

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

  List<Widget> pages = [const HomeScreen(),const LoginScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: myappDrawer(context),
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavigationBar(homeController),
      body: Obx(() => pages[homeController.selectedIndex.value],),
    );
  }
}


AppBar _buildAppBar() {
  return AppBar(
    title: const Text(
      'Top Up BD',
      style: AppTextStyles.appBarTitle, // Reuse the text style
    ),
    backgroundColor: AppColors.primaryColor,
    // Reuse primary color
    elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.white),
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications_none),
        onPressed: () {
          // Handle notifications
        },
      ),
      IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () {
          // Handle profile
        },
      ),
    ],
  );
}
Obx _buildBottomNavigationBar(HomeController homeController) {
  return Obx(
        () => BottomNavigationBar(
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
