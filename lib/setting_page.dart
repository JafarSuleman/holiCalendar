
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:holidays_calendar/provider/theme_changer_privider.dart';
import 'package:provider/provider.dart';

import 'next_screen.dart';

class SettingPage extends StatefulWidget {
  final String? selectedCountry;
  final String selectedCountryName;
  const SettingPage({Key? key, this.selectedCountry, required this.selectedCountryName,}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late ThemeChanger themeChanger;
  late Color sundayColor;

  late Color holidayColor;
  late Color importantDayColor;
  bool sundayColorEnabled = false;
  bool showImportantDayColor = true;
  bool alertOn = true;
  @override
  void initState() {
    holidayColor = Colors.blue;
    importantDayColor = Colors.green;
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeChanger = Provider.of<ThemeChanger>(context);
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
      backgroundColor: const Color(0xffEDFDFE),
      appBar: AppBar(
        backgroundColor: const Color(0xffEDFDFE),
        title: const Text('Setting',style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               ListTile(
                title: InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const NextScreen()));
                  },
                  child:  const Text(
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
                  ColorTools.nameThatColor(themeChanger.holidayColor),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () async {
                        await selectColor(context, themeChanger.holidayColor, (Color color) {
                            themeChanger.setHolidayColor(color);
                      });
                  },
                  child: ColorIndicator(
                    width: 30,
                    height: 30,
                    borderRadius: 30,
                    color: themeChanger.holidayColor,
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
                  ColorTools.nameThatColor(themeChanger.importantDayColor),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    await selectColor(context, themeChanger.importantDayColor, (Color color) {
                      setState(() {
                        themeChanger.setImportantDayColor(color);
                      });
                    });
                  },
                  child: ColorIndicator(
                    width: 30,
                    height: 30,
                    borderRadius: 30,
                    color: themeChanger.importantDayColor,
                    onSelectFocus: false,
                  ),
                ),
              ),

              const SizedBox(height: 10,),
              ColoredBox(
                color: Colors.black,
                child: Material(
                  color: const Color(0xffEDFDFE),
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () async {
                        if (sundayColorEnabled) {
                          await selectColor(context, themeChanger.sundayColors, (Color color) {
                            setState(() {
                              themeChanger.setSundayDayColor(color);
                            });
                          });
                        }
                      },
                      child: const Text(
                        'Sunday Color',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                    subtitle: GestureDetector(
                      onTap: () async {
                        if (sundayColorEnabled) {
                          await selectColor(context, themeChanger.sundayColors, (Color color) {
                            setState(() {
                              themeChanger.setSundayDayColor(color);
                            });
                          });
                        } else {
                          setState(() {
                            sundayColorEnabled = true;
                          });
                        }
                      },
                      child: Text(
                        sundayColorEnabled ?ColorTools.nameThatColor(themeChanger.sundayColor) : 'Normal',
                        style: TextStyle(
                          color: sundayColorEnabled ? Colors.grey : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    trailing: GestureDetector(
                      child: Switch(
                        value: sundayColorEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            sundayColorEnabled = value;
                            if (!value) {

                              themeChanger.setSundayDayColor(Colors.red);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              ListTile(
                title: const Text(
                  'Start Week',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                subtitle: Text(
                  themeChanger.startWeek == StartWeek.monday ? 'Monday' : 'Sunday',
                  style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.w600, fontSize: 20),
                ),
                trailing: Switch(
                  value: themeChanger.startWeek == StartWeek.sunday,
                  onChanged: (bool value) {
                    final newStartWeek = value ? StartWeek.sunday : StartWeek.monday;
                    themeChanger.setStartWeek(newStartWeek);
                  },
                ),
              ),

              const SizedBox(height: 10,),
              ColoredBox(
                color: Colors.black,
                child: Material(
                  color: const Color(0xffEDFDFE),
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
                  color: const Color(0xffEDFDFE),
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
      ),
    );
  }
}
