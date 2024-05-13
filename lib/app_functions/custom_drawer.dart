import 'package:flutter/material.dart';
import 'package:holidays_calendar/Screen/setting_page.dart';
import 'package:holidays_calendar/search_bar.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_button.dart';

class CustomDrawer extends StatefulWidget {
  final String selectedCountryId;
  final String selectedCountryName;

  const CustomDrawer({
    Key? key,
    required this.selectedCountryId,
    required this.selectedCountryName,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-dd').format(now);
    String monthFormatted = DateFormat('MMMM').format(now);
    String dayFormatted = DateFormat('EEEE').format(now);

    return Drawer(
      backgroundColor: const Color(0xffEDFDFE),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Hi! Dear",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Text(
                    monthFormatted.toString(),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    formattedDate.toString(),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Text(
                dayFormatted.toString(),
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10),
              const Divider(
                height: 0,
                color: Colors.black,
              ),
              const Divider(
                color: Colors.black,
                height: 5,
              ),
              const SizedBox(height: 10),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchBarr(
                                  selectedCountryId: widget.selectedCountryId,
                                )));
                  },
                  child: const DrawerItem(icon: Icons.search, text: "Search")),
              const SizedBox(height: 20),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingPage(
                          selectedCountry: widget.selectedCountryId,
                          selectedCountryName: widget.selectedCountryName,
                        ),
                      ),
                    );
                  },
                  child:
                      const DrawerItem(icon: Icons.settings, text: "Settings")),
              const SizedBox(height: 20),
              const Divider(
                height: 0,
                color: Colors.black,
              ),
              const Divider(
                color: Colors.black,
                height: 5,
              ),
              const SizedBox(height: 20),

              InkWell(
                  onTap: () async {
                    final InAppReview inAppReview = InAppReview.instance;
                    if (await inAppReview.isAvailable()) {
                      Future.delayed(const Duration(seconds: 2), () {
                        inAppReview.requestReview();
                      });
                    }
                  },
                  child:
                      const DrawerItem(icon: Icons.password, text: "Review")),
              const SizedBox(height: 20),

              InkWell(
                  onTap: () {
                    Share.share(
                        'https://play.google.com/store/apps/details?id=holidayscalender.widgets',
                        subject:
                        'Holidays Calender Made Easy: Download This App Now');
                  },
                  child: const DrawerItem(icon: Icons.share, text: "Share")),

              const SizedBox(height: 20),
              const Divider(
                height: 0,
                color: Colors.black,
              ),
              const Divider(
                color: Colors.black,
                height: 5,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  final Uri url = Uri.parse(
                      'https://privacypolicy09876.blogspot.com/2024/04/privacy-policy.html');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: const DrawerItem(
                    icon: Icons.privacy_tip, text: "Privacy Policy"),
              ),
              const SizedBox(height: 20),
              // const DrawerItem(icon: Icons.info, text: "About"),
              // const SizedBox(height: 20),
              const Divider(
                height: 0,
                color: Colors.black,
              ),
              const Divider(
                color: Colors.black,
                height: 5,
              ),
              const SizedBox(height: 10),
              CustomButton(
                buttonText: "Premium",
                onPressed: () {},
                width: 273,
                height: 43,
                iconData: Icons.workspace_premium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const DrawerItem({
    required this.icon,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
