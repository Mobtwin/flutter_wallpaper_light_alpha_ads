import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
// import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_handler/wallpaper_handler.dart';
import 'package:wallpapers/ad_manager/interstitial_ad.dart';
import 'package:wallpapers/model_view/data_provider.dart';
import 'package:wallpapers/utils/colors_utils.dart';
import 'package:wallpapers/utils/icons_constants.dart';
import 'package:wallpapers/utils/utils.dart';
import 'package:wallpapers/utils/wallpaper_utils.dart';

class FullScreen extends StatefulWidget {
  final String image;
  const FullScreen({super.key, required this.image});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  GlobalKey globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataprovider, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(dataprovider.data.cover.toString()),
              fit: BoxFit.fill,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    hexToColor(dataprovider.data.mainColor.toString()).withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SafeArea(
                      bottom: false,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              AppInterstitialAd.show();

                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Color(0x3F0FC0EC),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: appIcon(IconsConstants.close, false, context, 18, 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(widget.image),
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        height: 51,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                AppInterstitialAd.show();

                                if (dataprovider.favoriteList.contains(widget.image)) {
                                  dataprovider.removeFavorite(widget.image);
                                  //
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Removed from favourite',
                                        style: GoogleFonts.abel(fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  );
                                } else {
                                  dataprovider.saveFavorite(widget.image);
                                }
                              },
                              child: Container(
                                width: 51,
                                height: 51,
                                decoration: ShapeDecoration(
                                  color: const Color(0x3F0FC0EC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Center(
                                  child: appIcon(
                                      dataprovider.favoriteList.contains(widget.image)
                                          ? IconsConstants.heartfill
                                          : IconsConstants.heart,
                                      false,
                                      context,
                                      26,
                                      26),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                AppInterstitialAd.show();

                                onShareXFileFromAssets(context, widget.image);
                              },
                              child: Container(
                                width: 51,
                                height: 51,
                                decoration: ShapeDecoration(
                                  color: const Color(0x3F0FC0EC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Center(
                                  child: appIcon(IconsConstants.share, false, context, 26, 26),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                //show dailog for loading
                                AppInterstitialAd.show();

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Color(
                                              hexToColor(dataprovider.data.mainColor.toString())
                                                  .value),
                                        ),
                                      );
                                    });
                                await saveImage(widget.image, context).whenComplete(() {
                                  Navigator.pop(context);
                                });
                              },
                              child: Container(
                                width: 51,
                                height: 51,
                                decoration: ShapeDecoration(
                                  color: const Color(0x3F0FC0EC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Center(
                                  child: appIcon(IconsConstants.download, false, context, 26, 26),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                //show dailog for ask user to set wallpaper in home or lock screen
                                AppInterstitialAd.show();

                                if (Platform.isAndroid) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Set Wallpaper'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: const Text('Home Screen'),
                                                onTap: () {
                                                  setWallpaper(context, widget.image,
                                                          WallpaperLocation.homeScreen)
                                                      .whenComplete(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                              ),
                                              ListTile(
                                                title: const Text('Lock Screen'),
                                                onTap: () {
                                                  setWallpaper(context, widget.image,
                                                          WallpaperLocation.lockScreen)
                                                      .whenComplete(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                              ),
                                              ListTile(
                                                title: const Text('Both'),
                                                onTap: () {
                                                  setWallpaper(context, widget.image,
                                                          WallpaperLocation.bothScreens)
                                                      .whenComplete(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  ByteData imageData = await rootBundle.load(widget.image);
                                  Uint8List imageBytes = imageData.buffer.asUint8List();

                                  // Call the method to set the wallpaper
                                  setWallpaperIos(imageBytes);
                                }
                              },
                              child: Container(
                                width: 51,
                                height: 51,
                                decoration: ShapeDecoration(
                                  color: const Color(0x3F0FC0EC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Center(
                                  child: appIcon(IconsConstants.setas, false, context, 26, 26),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const platform = MethodChannel('com.example.my_wallpaper/setWallpaper');
  Future<void> setWallpaperIos(Uint8List imageBytes) async {
    try {
      await platform.invokeMethod('setWallpaper', imageBytes);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Wallpaper set successfully'),
      ));
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to set wallpaper: ${e.message}'),
      ));
    }
  }
}
