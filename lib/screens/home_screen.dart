import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../utils/AppColors.dart';
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
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    product['name'],
                    style: TextStyle(color: isSelected
                        ? AppColors.selectedBorderColor
                        : Colors.black,), // Reuse product title style
                  ),
                  Text(
                    '${product['price']} BDT',
                    style:
                        AppTextStyles.productPrice, // Reuse product price style
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
