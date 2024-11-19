import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wallpapers/ad_manager/interstitial_ad.dart';
import 'package:wallpapers/ad_manager/native_ad.dart';
import 'package:wallpapers/model_view/data_provider.dart';
import 'package:wallpapers/utils/colors_utils.dart';
import 'package:wallpapers/view/fullscreen/fullscreen.dart';
import 'package:wallpapers/view/home/home_carolist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> images = [];
  final PageController controller = PageController(
    initialPage: 1,
    viewportFraction: 0.34,
  );
  int currentPage = 1;

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 10),
      () {
        controller.nextPage(duration: const Duration(microseconds: 100), curve: Curves.easeIn);
        controller.previousPage(duration: const Duration(microseconds: 100), curve: Curves.easeIn);
        controller.nextPage(duration: const Duration(microseconds: 60), curve: Curves.easeInCirc);
        setState(() {});
      },
    );
    super.initState();
    for (var element in Provider.of<DataProvider>(context, listen: false).data.wallpapers!) {
      images.addAll(element.images!);
    }
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SafeArea(
                          bottom: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
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
                        const SizedBox(height: 20),
                        carolislist(context, dataprovider),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Wallpaper list',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.60,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(
                      child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: AppNativeAd(),
                  )),
                  SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            AppInterstitialAd.show();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreen(
                                  image: images[index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(images[index].toString()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: images.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox carolislist(BuildContext context, DataProvider dataprovider) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: controller,
        itemCount: dataprovider.data.pinned!.length,
        pageSnapping: false,
        dragStartBehavior: DragStartBehavior.start,
        restorationId: 'carolislist',
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        itemBuilder: (context, i) {
          return listItem(i, dataprovider, currentPage, controller, context);
        },
      ),
    );
  }
}
