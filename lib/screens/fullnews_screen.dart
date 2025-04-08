import 'package:flutter/material.dart';
import 'package:top_up_bd/utils/AppColors.dart';

class FullnewsScreen extends StatefulWidget {
  final String img;
  final String data;
  final String title;
  const FullnewsScreen({super.key, required this.img, required this.data, required this.title});

  @override
  State<FullnewsScreen> createState() => _FullnewsScreenState();
}

class _FullnewsScreenState extends State<FullnewsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Image.network(
                  widget.img,
                  height: 80,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: Text(widget.data),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
