import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/screens/checkout_screen.dart';
import 'package:top_up_bd/widget/ReviewDisplay.dart';
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
  TextEditingController uidController = TextEditingController();
  RxString errorMessage = ''.obs; // RxString to track error message

  @override
  void dispose() {
    uidController.dispose();
    super.dispose();
  }

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
              ),
            )
          : _buildBody(homeController)),
      backgroundColor: Colors.grey[100],
    );
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
                    () => homeController.homeImage.value.isEmpty
                        ? const LoadingAnimation()
                        : Image.network(
                            homeController.homeImage.value,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 13),
                Center(
                  child: Text(
                    'কত ডায়মন্ড নিবেন সিলেক্ট করুন',
                    style: constraints.maxWidth > 600
                        ? AppTextStyles.bodyTextLarge
                        : AppTextStyles.bodyTextSmall,
                  ),
                ),
                const SizedBox(height: 5),
                _buildProductGrid(homeController, constraints),
                const ReviewDisplay(reviews: [
                  {
                    'name': 'Sakib al hasan',
                    'time': '1 hour ago',
                    'text': 'Great product! I really love the quality and the customer service was fantastic.',
                    'rating': 5.0,
                  },
                  {
                    'name': 'Noman',
                    'time': '2 hour ago',
                    'text': 'The product is okay, but the delivery took too long.',
                    'rating': 3.0,
                  },
                  {
                    'name': 'Zoz batler',
                    'time': '3 hour ago',
                    'text': 'Not satisfied with the product. It broke after a week of use.',
                    'rating': 1.0,
                  },
                  {
                    'name': 'Urmi Akter',
                    'time': '5 hour ago',
                    'text': 'Good value for money. I would recommend this to my friends.',
                    'rating': 4.0,
                  },
                ]),
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
            elevation: 1,
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
                _showPlayerIDDialog(context, price: "${product['price']}৳", products: "${product['name']}", productsID: "${product['id']}");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    product['name'],
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.selectedBorderColor
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '${product['price']}৳',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.primaryColor,
                      ),
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

  void _showPlayerIDDialog(BuildContext context, {required String price, required products, required String productsID}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
              "$products ",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            InkWell(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.backspace_outlined,
                  color: Colors.red,
                ))
          ],
        ),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: homeController.playerIsLoading.value
                    ? const LoadingAnimation()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "আপনার গেমের প্লেয়ার আইডি দিন*",
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: uidController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: AppColors.white,
                              labelText: "Player ID",
                              labelStyle: const TextStyle(
                                color: AppColors.grey,
                              ),
                              errorText: errorMessage.value.isNotEmpty
                                  ? errorMessage.value
                                  : null, // Show error message if present
                            ),
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              homeController.playerIsLoading.value = false;
              String input =
                  uidController.text;
              bool _isInt = int.tryParse(
                      input.removeAllWhitespace.trim().replaceAll("-", "")) ==
                  null; // will be true if it's a valid integer, false otherwise
              if (uidController.text.isEmpty ||
                  uidController.text.length < 6 ||
                  _isInt) {
                errorMessage.value = "Please Give Valid Player ID";
              } else {
                errorMessage.value = '';
                homeController
                    .playerIdCheck(
                        uid: uidController.text.removeAllWhitespace
                            .replaceAll("-", "").trim())
                    .then(
                  (value) {
                    if (value == true) {
                      Get.to(() => CheckOutScreen(
                          prices: price,
                          productName: products,
                        playerIDname: homeController.playerID.value,
                        playerID: uidController.text,
                        productID: '',
                      ));
                    } else {
                      errorMessage.value = homeController.playerID.value;
                    }
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
