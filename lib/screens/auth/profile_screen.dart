import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:top_up_bd/controller/auth/profile_Controller.dart';
import 'package:top_up_bd/screens/checkout_wallet_screen.dart';
import 'package:top_up_bd/screens/wallet_history_screen.dart';
import '../../controller/auth/order_contrroller.dart';
import '../../utils/AppColors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final OrderController orderController = Get.put(OrderController());
  final ProfileController _profileController = Get.put(ProfileController());
  TextEditingController _walletAmount = TextEditingController();

  @override
  void initState() {
    _profileController.showBalance();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var processingOrders = orderController.orders
        .where((order) => order.status == "Processing")
        .toList();
    int processingOrdersLength = processingOrders.length;

    var completedOrders = orderController.orders
        .where((order) =>
    order.status == "Complete" || order.status == "Auto Completed" || order.status == "Auto Completed")
        .toList();
    int completedOrdersLength = completedOrders.length;

    var canceledOrders = orderController.orders
        .where((order) => order.status == "পেমেন্ট না করায় ডিলেট করা হয়েছে")
        .toList();
    int canceledOrdersLength = canceledOrders.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Obx(
              () => orderController.userName.value.isEmpty || orderController.userID.value.isEmpty
              ? LoginScreen()
              : RefreshIndicator(
            onRefresh: () async {
              await orderController.showProfileOrder(); // Corrected the method name
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Obx(
                  //       () => _buildProfileInfo(
                  //     screenWidth,
                  //     orderController.userName.value,
                  //     orderController.userPhone.value,
                  //     orderController.imgUrl.value,
                  //   ),
                  // ),
                  // const SizedBox(height: 30),
                  _buildWalletSection(context,orderController.imgUrl.value,orderController.userName.value,), // Added wallet and buttons
                  //const SizedBox(height: 30),
                  //_buildDashboardCards(context),
                  const SizedBox(height: 30),
                  _buildOrderStatistics(
                    context,
                    totalOrders: orderController.orders.length,
                    pendingOrders: processingOrdersLength,
                    canceledOrders: canceledOrdersLength,
                    completedOrders: completedOrdersLength,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatistics(
      BuildContext context, {
        required int totalOrders,
        required int pendingOrders,
        required int canceledOrders,
        required int completedOrders,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Statistics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 20),
          _buildStatisticRow('Total Orders', totalOrders.toString()),
          _buildStatisticRow('Pending Orders', pendingOrders.toString()),
          _buildStatisticRow('Completed Orders', completedOrders.toString()),
          _buildStatisticRow('Canceled Orders', canceledOrders.toString()),
        ],
      ),
    );
  }

  Widget _buildStatisticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDashboardCards(BuildContext context) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: [
        // Removed wallet card since its in Wallet Section
        _buildDashboardCard(context, 'Total Referrals', '50', Icons.people),
        _buildDashboardCard(context, 'Total Posts', '200', Icons.article),
      ],
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, String title, String value, IconData icon) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: (screenWidth - 48) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: AppColors.primaryColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSection(BuildContext context, String imageUrl, String userName) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50), // Adjust the top margin to accommodate the profile image
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50,),
              const Text(
                'Wallet Balance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Obx(() =>  Text(
                '৳${_profileController.walletBalance.value}', // Assuming you have a walletBalance in your controller
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showDepositDialog(context,_walletAmount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text('Deposit'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(()=>const WalletHistoryScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text('Wallet History'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Profile image on top
        Positioned(
          top: -15,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: imageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(imageUrl)
                      : null,
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void _showDepositDialog(BuildContext context, TextEditingController controller) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "টাকা এড করুন ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          InkWell(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.cancel_rounded,
                color: Colors.red,
                size: 30,
              ))
        ],
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "কত টাকা এড করতে চান?",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
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
                      labelText: "Amount",
                      labelStyle: const TextStyle(
                        color: AppColors.grey,
                      ),
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

      actions: [
        ElevatedButton(
          onPressed: () {
            if(controller.text.length <4 && controller.text.isNotEmpty){
              Get.to(()=> WalletCheckOutScreen(prices: controller.text, productName: "Wallet top up ${controller.text} ৳"));
            }else{
              Get.snackbar(
              backgroundColor: Colors.red,colorText: Colors.white,"Error", "এই এমাউন্ট ডিপোসিট করা যাবেন না");
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