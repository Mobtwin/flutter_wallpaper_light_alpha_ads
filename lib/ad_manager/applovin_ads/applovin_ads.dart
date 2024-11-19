import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';

import '../ad_ids.dart';

abstract class AppLovinInterstitialAd {
  static void load() {
    try {
      AppLovinMAX.loadInterstitial(AdIds.interstitital);
    } catch (_) {
      print('Error loading AppLovin interstitial ad');
    }
  }

  static Future<void> show() async {
    if ((await AppLovinMAX.isInterstitialReady(AdIds.interstitital)) == true) {
      try {
        AppLovinMAX.showInterstitial(AdIds.interstitital);
        Future.delayed(const Duration(seconds: 10), () {
          load();
        });
      } catch (_) {
        print('Error showing AppLovin interstitial ad');
      }
    } else {
      load();
    }
  }
}

class AppLovinNativeAdWidget extends StatelessWidget {
  const AppLovinNativeAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaxAdView(
      adUnitId: AdIds.native,
      adFormat: AdFormat.mrec,
      listener: AdViewAdListener(
        onAdLoadedCallback: (ad) {
          print('AppLovin Native Ad loaded');
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          print('AppLovin Native Ad failed to load');
        },
        onAdClickedCallback: (ad) {
          print('AppLovin Native Ad clicked');
        },
        onAdExpandedCallback: (ad) {
          print('AppLovin Native Ad expanded');
        },
        onAdCollapsedCallback: (ad) {
          print('AppLovin Native Ad collapsed');
        },
      ),
    );
  }
}

class AppLovinBannerAdWidget extends StatelessWidget {
  const AppLovinBannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaxAdView(
      adUnitId: AdIds.banner,
      adFormat: AdFormat.banner,
      listener: AdViewAdListener(
        onAdLoadedCallback: (ad) {},
        onAdLoadFailedCallback: (adUnitId, error) {},
        onAdClickedCallback: (ad) {},
        onAdExpandedCallback: (ad) {},
        onAdCollapsedCallback: (ad) {},
      ),
    );
  }
}
