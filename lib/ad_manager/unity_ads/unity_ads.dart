import 'package:flutter/material.dart';
import '../ad_ids.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

abstract class UnityInterstitialAd {
  static bool _isAdLoaded = false;

  static Future<void> load() async {
    if (await UnityAds.isInitialized()) {
      UnityAds.load(
        placementId: AdIds.interstitital,
        onComplete: (placementId) {
          _isAdLoaded = true;
        },
        onFailed: (placementId, error, message) {
          _isAdLoaded = false;
          load();
        },
      );
    }
  }

  static void show() {
    if (_isAdLoaded) {
      UnityAds.showVideoAd(
        placementId: AdIds.interstitital,
        onComplete: (placementId) {
          print("Video completed");
          load();
        },
        onFailed: (placementId, error, message) {
          print("Video failed");
          load();
        },
        onSkipped: (placementId) {
          print("Video skipped");
          load();
        },
      );
      _isAdLoaded = false;
    }
  }
}

class UnityBannerAdWidget extends StatelessWidget {
  const UnityBannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UnityBannerAd(
      placementId: AdIds.banner,
      onLoad: (placementId) {},
      onFailed: (placementId, error, message) {},
      onClick: (placementId) {},
      size: BannerSize.standard,
    );
  }
}
