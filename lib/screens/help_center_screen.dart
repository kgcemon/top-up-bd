import 'package:flutter/material.dart';
import 'package:top_up_bd/utils/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart'; // Import to handle phone and messaging actions
import '../../utils/AppColors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Help Center',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Get in touch with us:',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text("  কল দিনঃ 01828861788 (সকাল ১০ টা থেকে রাত ১১ টা)",style: TextStyle(fontSize: 10),),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: _buildHelpOptions(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build list of help options (call, WhatsApp, Messenger)
  List<Widget> _buildHelpOptions(BuildContext context) {
    return [
      _buildHelpTile(context, 'Call Us', Image.asset("assets/telephone.png"),
          () {
        _makePhoneCall('tel:+8801828861788'); // Replace with your phone number
      }),
      _buildDivider(),
      _buildHelpTile(
          context, 'Chat on WhatsApp', Image.asset("assets/whatsapp.png"), () {
        _openWhatsApp('+8801828861788'); // Replace with your WhatsApp number
      }),
      _buildDivider(),
      _buildHelpTile(
          context, 'Message on Messenger', Image.asset("assets/messenger.png"),
          () {
        _openMessenger(
            'https://m.me/codmshop'); // Replace with your Messenger page ID or URL
      }),
    ];
  }

  // Builds a single help option tile
  Widget _buildHelpTile(
    BuildContext context,
    String title,
    var icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: icon,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Divider widget
  Widget _buildDivider() {
    return const Divider(
      thickness: 1,
      height: 10,
      color: Colors.grey,
    );
  }

  // Method to make a phone call
  void _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Method to open WhatsApp
  void _openWhatsApp(String phoneNumber) async {
    final whatsappUrl = Uri.parse("https://wa.me/$phoneNumber");

    if (!await launchUrl(whatsappUrl)) {
      throw Exception('Could not launch $whatsappUrl');
    }
  }

  // Method to open Messenger
  void _openMessenger(String messengerUrl) async {
    if (!await launchUrl(Uri.parse(messengerUrl))) {
      throw Exception('Could not launch');
    }
  }
}
