import 'dart:ui';
import 'package:wallpapers/model_view/data_provider.dart';
import 'package:wallpapers/view/onboarding/widgets/indicator.dart';
import 'package:wallpapers/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:glass/glass.dart';
import 'package:blur/blur.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  //page controller
  final PageController controller = PageController(
    initialPage: 0,
    viewportFraction: 0.65,
  );
  int currentPage = 0;
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 10),
      () {
        controller.nextPage(
            duration: const Duration(microseconds: 100), curve: Curves.easeIn);
        controller.previousPage(
            duration: const Duration(microseconds: 100), curve: Curves.easeIn);
        setState(() {
          
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataprovider, child) => Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                    hexToColor(dataprovider.data.mainColor.toString())
                        .withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.7,
                      width: MediaQuery.of(context).size.width,
                      child: PageView.builder(
                        controller: controller,
                        itemCount: dataprovider.data.intro!.length,
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value;
                          });
                        },
                        itemBuilder: (context, i) {
                          return AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              double value =
                                  controller.position.hasContentDimensions
                                      ? controller.page! - i
                                      : 0.0;

                              value = (1 - (value.abs() * 0.3))
                                  .clamp(0.0, 1.0); // Control zoom and scaling

                              double rotation =
                                  controller.position.hasContentDimensions
                                      ? (controller.page! - i).clamp(-2.0, 2.0)
                                      : 0.5;
                              return Center(
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..scale(value) // Zoom effect
                                    ..rotateZ(rotation *
                                        -0.08), // Slight rotation effect
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Middle item: Full display
                                        if (i == currentPage)
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            // margin: const EdgeInsets.all(10),
                                            clipBehavior: Clip.hardEdge,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Image.asset(
                                                dataprovider.data.intro![i].icon
                                                    .toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        // Left item: Blur and rotate
                                        if (i == currentPage - 1)
                                          Blur(
                                            blur: 3,
                                            blurColor:
                                                Colors.white.withOpacity(0.2),
                                            colorOpacity: 0.3,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    dataprovider
                                                        .data.intro![i].icon
                                                        .toString(),
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                        // Right item: Blur and rotate
                                        if (i == currentPage + 1)
                                          Blur(
                                            blur: 3,
                                            blurColor: Colors.white,
                                            colorOpacity: 0.3,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                image: DecorationImage(
                                                  image: AssetImage(dataprovider
                                                      .data.intro![i].icon
                                                      .toString()),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 2.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // indicatorItems(value, currentPage),
                            const SizedBox(height: 27),
                            Text(
                              dataprovider.data.intro![currentPage].title
                                  .toString(),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.24,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Opacity(
                              opacity: 0.60,
                              child: Text(
                                dataprovider
                                    .data.intro![currentPage].description
                                    .toString(),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          indicatorItems(dataprovider, currentPage),
                          const SizedBox(height: 20),
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              if (currentPage ==
                                  dataprovider.data.intro!.length - 1) {
                                Navigator.pushReplacementNamed(
                                    context, '/menu');
                              }
                              if (currentPage <
                                  dataprovider.data.intro!.length - 1) {
                                controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                );
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 51,
                              decoration: ShapeDecoration(
                                color: hexToColor(
                                        dataprovider.data.mainColor.toString())
                                    .withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: hexToColor(dataprovider
                                            .data.mainColor
                                            .toString())
                                        .withOpacity(0.4),
                                    blurRadius: 2,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  height: 51,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: ShapeDecoration(
                                    color: hexToColor(
                                        dataprovider.data.mainColor.toString()),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (currentPage + 1 ==
                                              dataprovider.data.intro!.length -
                                                  1)
                                          ? 'Next'
                                          : 'Get Started',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).asGlass(
          blurX: 10,
          blurY: 10,
        ),
      ),
    );
  }
}
