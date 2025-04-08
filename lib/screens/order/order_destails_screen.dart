import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/helper/TimeDifferenceMaker.dart';
import 'package:top_up_bd/screens/checkout_screen.dart';
import 'package:top_up_bd/utils/AppColors.dart';
import '../../data/models/order_history_model.dart';
import '../help_center_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderData order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text('Order Details ${order.id}',style: const TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(),
              const SizedBox(height: 24),
              _buildProgressStepper(),
              const SizedBox(height: 24),
              _buildOrderItems(),
              const SizedBox(height: 24),
              _buildPaymentSummary(),
              const SizedBox(height: 24),
              _buildSupportSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: order.itemtitle.contains('Wallet') ? null : _buildActionButtons(),
    );
  }

  Widget _buildOrderHeader() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status == 'পেমেন্ট না করায় ডিলেট করা হয়েছে'
                        ? 'Cancelled'
                        : order.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              order.updated_at != null
                  ? '${order.status} ${timeAgo(DateTime.parse(order.updated_at ?? ''))}'
                  : 'Place Order on ${timeAgo(DateTime.parse(order.created_at?? DateTime.now().toString()))}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStepper() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStepperRow('Place Order', true),
            _buildStepperRow(
                'Payment',
                order.status == 'Complete' ||
                    order.status == 'Auto Completed' ||
                    order.status == 'Done' ||
                    order.status == 'Payment Verified'),
            _buildStepperRow(
                'Shipped',
                order.status == 'Complete' ||
                    order.status == 'Auto Completed' ||
                    order.status == 'Done' ||
                    order.status == 'Payment Verified'
                    || order.status == 'Auto Topup'),
            _buildStepperRow(
                'Delivered',
                order.status == 'Complete' ||
                    order.status == 'Auto Completed' ||
                    order.status == 'Done'),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperRow(String title, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_off,
            color: isCompleted ? Colors.green : Colors.grey[400],
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isCompleted ? Colors.black : Colors.grey[600],
              fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/logo.png'),
              ),
              title: Text(order.itemtitle),
              subtitle: Text('Uid: ${order.userdata}'),
              trailing: Text(
                '${order.total}৳',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Payment Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              children: [
                _buildTableRow('Subtotal:', order.total.toString()),
                _buildTableRow('Number:', order.bkashNumber),
                _buildTableRow('TrxID:', order.trxid),
                _buildTableRow('Total:', order.total),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String amount) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            amount,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need Help?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => Get.to(() => const HelpCenterScreen()),
              child: const ListTile(
                leading: Icon(Icons.support_agent),
                title: Text('Contact Support'),
                subtitle: Text('Our team is available 24/7 to assist you'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Get.to(() => const HelpCenterScreen());
              },
              child: const Text('Contact Support'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
              onPressed: () {
                Get.to(()=>CheckOutScreen(
                    prices: order.total,
                    productName: order.itemtitle,
                    playerIDname: order.userdata,
                    playerID: order.userdata,
                    productID: order.id.toString()
                ));
              },
              child: const Text('Reorder',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'auto completed':
        return Colors.green;
      case 'complete':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
