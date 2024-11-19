
import '../main.dart';

abstract class AdIds {
  static String get interstitital => data.adConfig?.first.interstitial ?? "";
  static String get banner => data.adConfig?.first.banner ?? "";
  static String get native => data.adConfig?.first.native ?? "";
}
