import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/ad_manager/interstitial_ad.dart';
import 'package:wallpapers/model_view/data_provider.dart';
import 'package:wallpapers/utils/colors_utils.dart';
import 'package:wallpapers/view/categoryies/category_item.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 70,
                              spreadRadius: -100,
                              offset: const Offset(-10, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: dataprovider.data.wallpapers!.length,
                                padding: const EdgeInsets.only(bottom: 300),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      AppInterstitialAd.show();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CategoryItem(
                                                  title: dataprovider
                                                      .data.wallpapers![index].category
                                                      .toString(),
                                                  wallpapers: dataprovider
                                                      .data.wallpapers![index].images!)));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      height: 176,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            dataprovider.data.wallpapers![index].icon.toString(),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            stops: const [0.4, 1.0],
                                            colors: [
                                              Colors.black.withOpacity(0.85),
                                              Colors.black.withOpacity(0),
                                            ],
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 36,
                                            ),
                                            Text(
                                              dataprovider.data.wallpapers![index].category
                                                  .toString(),
                                              style: GoogleFonts.nanumBrushScript(
                                                color: Colors.white,
                                                fontSize: 32,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 2.24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
