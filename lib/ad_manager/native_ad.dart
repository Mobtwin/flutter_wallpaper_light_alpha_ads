import 'package:flutter/material.dart';

import '../main.dart';
import 'admob_ads/admob_ads.dart';
import 'applovin_ads/applovin_ads.dart';
import 'facebook_ads/facebook_ads.dart';

class AppNativeAd extends StatelessWidget {
  const AppNativeAd({super.key});

  @override
  Widget build(BuildContext context) {
    switch (selectedAdNetwork) {
      case AdNetwork.admob:
        return const AdMobNativeAdWidget();
      case AdNetwork.facebook:
        return const FBNativeAdWidget();
      case AdNetwork.applovin:
        return const AppLovinNativeAdWidget();
      default:
        return const SizedBox.shrink();
    }
  }
}
