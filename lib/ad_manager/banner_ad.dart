import 'package:flutter/material.dart';

import '../main.dart';
import 'admob_ads/admob_ads.dart';
import 'applovin_ads/applovin_ads.dart';
import 'facebook_ads/facebook_ads.dart';
import 'unity_ads/unity_ads.dart';


class AppBannerAd extends StatelessWidget {
  const AppBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    switch (selectedAdNetwork) {
      case AdNetwork.admob:
        return const AdMobBannerAdWidget();
      case AdNetwork.facebook:
        return const FBBannerAdWidget();
      case AdNetwork.applovin:
        return const AppLovinBannerAdWidget();
      case AdNetwork.unity:
        return const UnityBannerAdWidget();
      default:
        return const SizedBox.shrink();
    }
  }
}
