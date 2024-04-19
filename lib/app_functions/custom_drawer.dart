import 'package:flutter/material.dart';
import 'package:holidays_calendar/search_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:holidays_calendar/setting_page.dart';
import 'package:share/share.dart';
import '../provider/theme_changer_privider.dart';

import 'custom_button.dart';

class CustomDrawer extends StatefulWidget {
  final String selectedCountryId;
  final String selectedCountryName;
  const CustomDrawer({Key? key, required this.selectedCountryId, required this.selectedCountryName,}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-dd').format(now);
    String monthFormatted = DateFormat('MMMM').format(now);
    String dayFormatted = DateFormat('EEEE').format(now);

    return Drawer(
      backgroundColor: themeChanger.themeMode == ThemeMode.dark ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
                Text(monthFormatted.toString(), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),),
                const SizedBox(width: 5,),
                Text(formattedDate.toString(), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),),

              ],
            ),
            Text(dayFormatted.toString(), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),),
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
              onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>  SearchBarr(selectedCountryId: widget.selectedCountryId,)));
              },
                child: const DrawerItem(icon: Icons.search, text: "Search")),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Toggle theme mode between light and dark
                themeChanger.setTheme(
                    themeChanger.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
              },
              child: const DrawerItem(icon: Icons.brightness_4_sharp, text: "Theme"),
            ),
            const SizedBox(height: 20),
            const DrawerItem(icon: Icons.backup_rounded, text: "Backup & Restore"),
            const SizedBox(height: 20),
            InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(selectedCountry: widget.selectedCountryId, selectedCountryName: widget.selectedCountryName,),
                    ),
                  );
                },
                child: const DrawerItem(icon: Icons.settings, text: "Settings")),
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

            const DrawerItem(icon: Icons.password, text: "Review"),
            const SizedBox(height: 20),

            InkWell(
              onTap: (){
              Share.share("Hello, This is notifications");
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
            const DrawerItem(icon: Icons.privacy_tip, text: "Privacy Policy"),
            const SizedBox(height: 20),
            const DrawerItem(icon: Icons.info, text: "About"),
            const SizedBox(height: 20),
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
