import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/ad_manager/interstitial_ad.dart';
import 'package:wallpapers/model_view/data_provider.dart';
import 'package:wallpapers/utils/colors_utils.dart';
import 'package:wallpapers/view/fullscreen/fullscreen.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        Provider.of<DataProvider>(context, listen: false).getfavorite();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataprovider, child) => Scaffold(
        extendBody: true,
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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(
                        bottom: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hi 👋, welcome again →',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    )),
                                Text(
                                  'Anime Wallpapers',
                                  style: GoogleFonts.nanumBrushScript(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 2.24,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: hexToColor(dataprovider.data.mainColor).withOpacity(0.2),
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(dataprovider.data.appIcon.toString()),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 70,
                              spreadRadius: -100,
                              offset: const Offset(-10, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            if (dataprovider.favoriteList.isEmpty)
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.heart_broken,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                      Text(
                                        'No favorite yet',
                                        style: GoogleFonts.quicksand(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Expanded(
                              child: GridView.builder(
                                padding: const EdgeInsets.only(top: 0),
                                itemCount: dataprovider.favoriteList.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                ),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      AppInterstitialAd.show();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreen(
                                            image: dataprovider.favoriteList[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                stops: const [0.4, 1.0],
                                                colors: [
                                                  Colors.black.withOpacity(0.85),
                                                  Colors.black.withOpacity(0),
                                                ],
                                              ),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  dataprovider.favoriteList[index],
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              margin: const EdgeInsets.all(5),
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: hexToColor(
                                                  dataprovider.data.mainColor.toString(),
                                                ),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.favorite,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
