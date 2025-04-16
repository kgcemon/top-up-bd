import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/screens/home_screen.dart';
import 'package:top_up_bd/screens/auth/profile_screen.dart';
import '../controller/auth/profile_Controller.dart';
import '../controller/home_controller.dart';
import '../utils/AppColors.dart';
import '../widget/drawer.dart';
import 'order/my_order_screen.dart';
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
    //homeController.isLoginUsers();
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const MyOrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          floatingActionButton: homeController.selectedIndex.value == 0
              ? SizedBox(
                  width: 125,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Get.to(() => const HelpCenterScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/help.png",
                            width: 30,
                          ),
                          const Text(
                            " Help center",
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : null,
          appBar: _buildAppBar(),
          drawer: const MyAppDrawer(),
          backgroundColor: Colors.grey[100],
          bottomNavigationBar: _buildBottomNavigationBar(homeController),
          body: SafeArea(child: pages[homeController.selectedIndex.value]),
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        homeController.selectedIndex.value == 0
            ? 'Home'
            : homeController.selectedIndex.value == 1
                ? 'Order History'
                : homeController.selectedIndex.value == 2
                    ? 'Profile'
                    : '',
        style: AppTextStyles.appBarTitle,
      ),
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.white),
      actions: [
        Obx(() => homeController.isLoginUser.value == false
            ? TextButton(
          child: const Icon(
            Icons.notifications,
            size: 22,
            color: Colors.white,
          ),
          onPressed: () {
            Get.put(HomeController()).selectedIndex.value = 2;
          },
        )
            : TextButton(
          child: Row(
            children: [
              Text(
               '৳ ${ Get.put(ProfileController()).walletBalance.value} ',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Icon(
                Icons.wallet,
                size: 21,
                color: Colors.white,
              ),
            ],
          ),
          onPressed: () {
            Get.put(HomeController()).selectedIndex.value = 2;
          },
        ),)

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
