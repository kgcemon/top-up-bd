import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/utils/AppColors.dart';
import 'package:intl/intl.dart'; // Import for date formatting

import '../controller/wallet_history_controller.dart';

class WalletHistoryScreen extends StatefulWidget {
  const WalletHistoryScreen({super.key});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final WalletHistoryController controller = Get.find<WalletHistoryController>();
      if (controller.hasMoreData && !controller.isLoading) {
        controller.loadNextPage();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Wallet History',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: GetBuilder<WalletHistoryController>(
          init: WalletHistoryController(),
          builder: (controller) {
            if (controller.isLoading && controller.historyList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.historyList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 60, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      "No transaction history yet.",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => controller.loadFullHistory(),
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.historyList.length + (controller.hasMoreData ? 1 : 0),
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    if (index < controller.historyList.length) {
                      final historyItem = controller.historyList[index];
                      final formattedDate = DateFormat('MMM d, yyyy - hh:mm a').format(historyItem.createdAt); // Use intl package
                      return Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                historyItem.message,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: historyItem.message.contains("+") ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Order ID: ${historyItem.orderId}',
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedDate, // Use formatted date
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox();
                    }
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}