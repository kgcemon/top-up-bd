import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/screens/checkout_screen.dart';
import '../controller/home_controller.dart';
import '../utils/AppColors.dart';
import '../widget/drawer.dart';
import '../widget/loading_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: const MyAppDrawer(),
      appBar: _buildAppBar(),
      body: Obx(() => homeController.isLoading.value
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [LoadingAnimation(), Text("Loading..")],
            ))
          : _buildBody(homeController)),
      backgroundColor: Colors.grey[100],

    );
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


  Widget _buildBody(HomeController homeController) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Obx(
                      () => homeController.homeImage.value.isEmpty ? const LoadingAnimation() : Image.network(
                        homeController.homeImage.value,
                        fit: BoxFit.cover,
                      ),
                    )),
                const SizedBox(
                  height: 13,
                ),
                Center(
                  child: Text(
                    'কত ডায়মন্ড নিবেন সিলেক্ট করুন',
                    style: constraints.maxWidth > 600
                        ? AppTextStyles.bodyTextLarge
                        : AppTextStyles.bodyTextSmall, // Reuse text styles
                  ),
                ),
                const SizedBox(height: 5),
                _buildProductGrid(homeController, constraints),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(
      HomeController homeController, BoxConstraints constraints) {
    return GetBuilder<HomeController>(
      builder: (controller) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 5 / 1.9,
        ),
        itemCount: homeController.products.length,
        itemBuilder: (context, index) {
          final product = homeController.products[index];
          final isSelected = homeController.selectedProductIndex == index;

          return Card(
            elevation: 2,
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isSelected
                    ? AppColors.selectedBorderColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: InkWell(
              onTap: () {
                homeController.selectProduct(index);
                Get.to(()=>const CheckOutScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    product['name'],
                    style: TextStyle(color: isSelected
                        ? AppColors.selectedBorderColor
                        : Colors.black,), // Reuse product title style
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '${product['price']}৳',
                      style:
                           const TextStyle(fontSize: 10,color: AppColors.primaryColor), // Reuse product price style
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
