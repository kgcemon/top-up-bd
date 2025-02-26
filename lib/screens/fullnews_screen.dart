import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  final String adsUnitID = "ca-app-pub-9662671355476806/4525142363";

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adsUnitID,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('BannerAd failed to load: $error');
        },
      ),
      request: const AdRequest(),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isBannerAdLoaded
          ? SizedBox(
        height: _bannerAd?.size.height.toDouble(),
        width: _bannerAd?.size.width.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      )
          : const SizedBox.shrink(),
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
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
    );
  }
}
