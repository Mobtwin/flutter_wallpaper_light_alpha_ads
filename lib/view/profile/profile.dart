import 'dart:io';
import 'dart:ui';
import 'package:wallpapers/main.dart';
import 'package:wallpapers/model_view/data_provider.dart';
import 'package:wallpapers/utils/colors_utils.dart';
import 'package:wallpapers/view/profile/webview.dart';
import 'package:wallpapers/view/profile/widgets/builder_item.dart';
import 'package:wallpapers/view/profile/widgets/profile_item.dart';
import 'package:wallpapers/utils/icons_constants.dart';
import 'package:wallpapers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final InAppReview inAppReview = InAppReview.instance;
  @override
  void initState() {
    super.initState();
  }

  Future<void> openStoreListing() => inAppReview.openStoreListing(
      appStoreId: packageInfo!.packageName,
      microsoftStoreId: packageInfo!.packageName);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(value.data.cover.toString()),
              fit: BoxFit.fill,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    hexToColor(value.data.mainColor.toString())
                        .withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  color: hexToColor(value.data.mainColor)
                                      .withOpacity(0.2),
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
                                      image: AssetImage(
                                          value.data.appIcon.toString()),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Opacity(
                            opacity: 0.70,
                            child: Text(
                              'Support us',
                              style: GoogleFonts.museoModerno(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      profileItem(context, 'Rate Us', IconsConstants.rateus,
                          () {
                        openStoreListing();
                        // _requestReview();
                      }),
                      profileItem(context, 'Contact Us', IconsConstants.contact,
                          () {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: value.data.contact,
                          query: encodeQueryParameters(<String, String>{
                            'subject': 'Feedback',
                          }),
                        );
                        launchUrl(emailLaunchUri);
                      }),
                      profileItem(
                          context, 'Share with friends', IconsConstants.share,
                          () {
                        if (Platform.isIOS) {
                          Share.share(
                              'https://apps.apple.com/us/app/${packageInfo!.packageName}/id${packageInfo!.buildSignature}');
                        } else {
                          Share.share(
                              'https://play.google.com/store/apps/details?id=${packageInfo!.packageName}');
                        }
                      }),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Opacity(
                            opacity: 0.70,
                            child: Text(
                              'About the app',
                              style: GoogleFonts.museoModerno(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      profileItem(context, 'About us', IconsConstants.aboutus,
                          () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return WebviewScreen(
                              url: value.data.about!, title: 'About us');
                        }));
                      }),
                      profileItem(
                          context, 'Terms and Conditions', IconsConstants.trems,
                          () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return WebviewScreen(
                              url: value.data.terms!,
                              title: 'Terms and Conditions');
                        }));
                      }),
                      profileItem(
                          context, 'Privacy Policy', IconsConstants.privacy,
                          () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return WebviewScreen(
                              url: value.data.privacy!,
                              title: 'Privacy Policy');
                        }));
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      builderWidget(),
                      const SizedBox(
                        height: 50,
                      ),
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
