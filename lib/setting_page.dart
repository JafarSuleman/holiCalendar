
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

import 'next_screen.dart';

class SettingPage extends StatefulWidget {
  final String? selectedCountry;
  final String selectedCountryName;
  const SettingPage({Key? key, this.selectedCountry, required this.selectedCountryName,}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Color holidayColor;
  late Color importantDayColor;
  bool sundayColorEnabled = true;
  bool showImportantDayColor = true;
  bool alertOn = true;
  @override
  void initState() {
    holidayColor = Colors.blue;
    importantDayColor = Colors.green;
    super.initState();
  }

  Future<void> selectColor(BuildContext context, Color initialColor, void Function(Color) onColorChanged) async {
    final Color? newColor = (await ColorPicker(
      color: initialColor,
      onColorChanged: onColorChanged,
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
    ).showPickerDialog(
      context,
      constraints: const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    )) as Color?;

    if (newColor == null) {
      // Handle cancellation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             ListTile(
              title: InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const NextScreen()));
                },
                child: const Text(
                  'Select Holiday Country',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
              subtitle: Text(
                widget.selectedCountryName.toString(),
                style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20,),
            ListTile(
              title: const Text(
                'Holiday Color',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              subtitle: Text(
                ColorTools.nameThatColor(holidayColor),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: GestureDetector(
                onTap: () async {
                  await selectColor(context, holidayColor, (Color color) {
                    setState(() {
                      holidayColor = color;
                    });
                  });
                },
                child: ColorIndicator(
                  width: 30,
                  height: 30,
                  borderRadius: 30,
                  color: holidayColor,
                  onSelectFocus: false,
                ),
              ),
            ),

            const SizedBox(height: 10,),
            ListTile(
              title: const Text(
                'Important Day Color',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              subtitle: Text(
                ColorTools.nameThatColor(importantDayColor),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: GestureDetector(
                onTap: () async {
                  await selectColor(context, importantDayColor, (Color color) {
                    setState(() {
                      importantDayColor = color;
                    });
                  });
                },
                child: ColorIndicator(
                  width: 30,
                  height: 30,
                  borderRadius: 30,
                  color: importantDayColor,
                  onSelectFocus: false,
                ),
              ),
            ),
            const SizedBox(height: 10,),
            ColoredBox(
              color: Colors.black,
              child: Material(
                child: SwitchListTile(
                  title: const Text('Sunday Color',style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20) ,),
                    subtitle: const Text(
                  'Normal',
                  style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600, fontSize: 20),
                ),
                  value: sundayColorEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      sundayColorEnabled = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10,),
            const ListTile(
              title: Text(
                'Start Week',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              subtitle: Text(
                'Default',
                style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            const SizedBox(height: 10,),
            ColoredBox(
              color: Colors.black,
              child: Material(
                child: SwitchListTile(
                  title: const Text('Show Important Day',style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20) ,),
                  value: showImportantDayColor,
                    activeColor: const Color(0xffE25E2A),
                  onChanged: (bool value) {
                    setState(() {
                      showImportantDayColor = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10,),
            const Text("Holiday Notification",style: TextStyle(
              color: Color(0xffE25E2A),
              fontSize: 20,fontWeight: FontWeight.w600,
            ),),
            const SizedBox(height: 10,),
            ColoredBox(
              color: Colors.black,
              child: Material(
                child: SwitchListTile(
                  title: const Text('Alert On',style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20) ,),
                  subtitle: const Text(
                    '9:15 AM',
                    style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  value: alertOn,
                  activeColor: const Color(0xffE25E2A),
                  onChanged: (bool value) {
                    setState(() {
                      alertOn = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
