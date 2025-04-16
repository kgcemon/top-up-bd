import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:top_up_bd/controller/auth/order_contrroller.dart';
import 'package:top_up_bd/controller/auth/profile_Controller.dart';
import 'package:top_up_bd/screens/checkout_screen.dart';
import 'package:top_up_bd/screens/fullnews_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/home_controller.dart';
import '../local_notification_service.dart';
import '../utils/AppColors.dart';
import '../widget/loading_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final ProfileController profileController = Get.put(ProfileController());
  final OrderController orderController = Get.put(OrderController());
  TextEditingController uidController = TextEditingController();
  RxString errorMessage = ''.obs; // RxString to track error message

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocalNotificationService.initialize(context);
    });
    checkForUpdate();
    super.initState();
    homeController.fetchNews();
    profileController.showBalance();
  }



  @override
  void dispose() {
    uidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => homeController.isLoading.value
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [LoadingAnimation(), Text("Loading..")],
                ),
              )
            : _buildBody(homeController)),
      ),
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
                  height: 135,
                  width: double.infinity,
                  child: Obx(
                    () => homeController.homeImage.value.isEmpty
                        ? const LoadingAnimation()
                        : InkWell(
                            onTap: () async {
                              if (!await launchUrl(Uri.parse(
                                  "https://youtu.be/bjEzsIzLBjA?si=8avK0o5giBuS_gyC"))) {
                                throw Exception('Could not launch');
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                homeController.homeImage.value,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                const SizedBox(height: 13),
                Center(
                  child: Text(
                    'আপডেট',
                    style: constraints.maxWidth > 600
                        ? AppTextStyles.bodyTextLarge
                        : AppTextStyles.bodyTextSmall,
                  ),
                ),
                Obx(
                  () => homeController.news.isEmpty
                      ? const LoadingAnimation()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeController.news.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ListTile(
                              onTap: () {
                                Get.to(() => FullnewsScreen(
                                      img:
                                          "https://${homeController.news[index].images.split("/home/kgcemon/htdocs/")[1]}",
                                      data: homeController.news[index].fullnews,
                                      title: homeController.news[index].title,
                                    ));
                              },
                              leading: Image.network(
                                "https://${homeController.news[index].images.split("/home/kgcemon/htdocs/")[1]}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons
                                      .image_not_supported); // Show fallback in case of error
                                },
                              ),
                              tileColor: Colors.white,
                              title: Text(
                                homeController.news[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize:
                                        13), // Ensure long titles don't overflow
                              ),
                              subtitle: Text(
                                homeController.news[index].title,
                                maxLines: 2,
                                // Limit subtitle to 2 lines for better presentation
                                overflow: TextOverflow
                                    .ellipsis, // Ensure subtitle doesn't overflow
                              ),
                            ),
                          ),
                        ),
                )
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
                homeController.checkUserIsLoginAndWalletUseAble(
                    orderAmount: product['price'],
                    myWallet:
                        double.parse(profileController.walletBalance.value));
                homeController.selectProduct(index);
                _showPlayerIDDialog(context,
                    price: "${product['price']}৳",
                    products: "${product['name']}",
                    productsID: "${product['id']}");
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
                  const SizedBox(width: 3),
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

  void _showPlayerIDDialog(BuildContext context,
      {required String price, required products, required String productsID}) {
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
                  Icons.cancel,
                  color: Colors.red,
                  size: 30,
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
                              labelText: "UID",
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
          Obx(
            () => ElevatedButton(
              onPressed: () {
                homeController.playerIsLoading.value = false;
                String input = uidController.text;
                bool isInt = int.tryParse(
                        input.removeAllWhitespace.trim().replaceAll("-", "")) ==
                    null;
                if (uidController.text.isEmpty ||
                    uidController.text.length < 6 ||
                    isInt) {
                  errorMessage.value = "Please Give Valid Player ID";
                } else {
                  errorMessage.value = '';
                  homeController
                      .playerIdCheck(
                          uid: uidController.text.removeAllWhitespace
                              .replaceAll("-", "")
                              .trim())
                      .then(
                    (value) {
                      if (value == true) {
                        if (homeController.userIsWallet.value) {
                          homeController.orderWithWallet(
                              playerID: uidController.text,
                              productID: productsID);
                        } else {
                          Get.to(() => CheckOutScreen(
                                prices: price,
                                productName:
                                    "${homeController.catName.value} $products",
                                playerIDname: homeController.playerID.value,
                                playerID: uidController.text,
                                productID: productsID,
                              ));
                        }
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
              child: Text(
                homeController.userIsWallet.value == true
                    ? 'Pay With Wallet'
                    : 'Submit',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
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

  Future<void> checkForUpdate() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          print('update available');
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }
}
