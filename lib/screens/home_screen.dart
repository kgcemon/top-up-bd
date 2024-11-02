import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_up_bd/controller/category_controller.dart';
import 'package:top_up_bd/controller/slider_controller.dart';
import 'package:top_up_bd/widget/category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameController gameController = Get.put(GameController());
    final SliderController sliderController = Get.put(SliderController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Top Up BD',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.grey[800]),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.grey[800]),
              title: const Text('Transaction History'),
              onTap: () {
                // Navigate to transaction history
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey[800]),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.grey[800]),
              title: const Text('Help & Support'),
              onTap: () {
                // Navigate to help and support
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey[800]),
              title: const Text('Logout'),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          // Slider
          Obx(() {
            if (sliderController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return CarouselSlider(
                options: CarouselOptions(
                  height: 140.0,
                  autoPlay: true,
                  enlargeCenterPage: false,
                ),
                items: sliderController.sliderImages.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://codmshopbd.com/myapp/$imagePath',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 50);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            }
          }),
          // Promotional Banner
    const SizedBox(height: 20,),
          // Grid of Games
          Expanded(
            child: Obx(() {
              if (gameController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: gameController.games.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    MediaQuery.of(context).size.width > 600 ? 4 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return CategoryCard(game: gameController.games[index]);
                  },
                );
              }
            }),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
