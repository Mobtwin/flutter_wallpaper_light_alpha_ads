import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:wallpapers/ad_manager/interstitial_ad.dart';
import 'package:wallpapers/model_view/data_provider.dart';
import 'package:wallpapers/view/fullscreen/fullscreen.dart';

AnimatedBuilder listItem(int i, DataProvider dataprovider, int currentPage,
    PageController controller, BuildContext context) {
  return AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      // Get the page value for scaling/position adjustment
      if (!controller.hasClients || !controller.position.hasContentDimensions) {
        return const SizedBox(); // Prevents trying to build when the PageView is not ready
      }
      if (controller.page == null) {
        return const SizedBox();
      }
      if (controller.position.maxScrollExtent == 0) {
        return const SizedBox();
      }

      double value = controller.page ?? controller.initialPage.toDouble();
      double difference = (value - i).abs();

      // Scale: Make the current item larger than others
      double scale = (1 - (difference * 0.2))
          .clamp(0.85, 1.2); // Adjust scale for larger center item

      // Adjust width for selected and non-selected items
      double itemWidth =
          MediaQuery.of(context).size.width * 0.75; // Increase width
      double translateX =
          i == currentPage ? -70.0 : -70.0; // Adjust horizontal translation
      return i == currentPage
          ? InkWell(
              onTap: () {
                            AppInterstitialAd.show();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreen(
                      image: dataprovider.data.pinned![i],
                    ),
                  ),
                );
              },
              child: Transform(
                transform: Matrix4.identity()
                  ..scale(scale)
                  ..translate(translateX),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 4.0), // Adjust spacing between items
                  width: itemWidth, // Adjust the width here
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      dataprovider.data.pinned![i].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
          : Transform(
              transform: Matrix4.identity()
                ..scale(scale)
                ..translate(translateX),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(
                    horizontal: 4.0), // Adjust spacing between items
                width: itemWidth, // Adjust the width here
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Blur(
                  blur: 1,
                  blurColor: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 220,
                    width: 143,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      dataprovider.data.pinned![i].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
    },
  );
}
