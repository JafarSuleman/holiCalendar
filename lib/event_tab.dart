import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:holidays_calendar/provider/Provier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'Screen/Add_Alarm.dart';
import 'app_functions/custom_button.dart';

class EventsTAb extends StatefulWidget {
  const EventsTAb({super.key});

  @override
  State<EventsTAb> createState() => _EventsTAbState();
}

class _EventsTAbState extends State<EventsTAb> {
  bool value = false;

  @override
  void initState() {
    context.read<AlarmProvider>().initialize(context);
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });

    super.initState();
    context.read<AlarmProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Center(
      child: Column(
        children: [
          Container(
            decoration:  BoxDecoration(
                color: Colors.white,
                border: Border.all(),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            height: MediaQuery.of(context).size.height * 0.05,
            child: Center(
                child: Text(
              DateFormat.yMEd().add_jms().format(
                    DateTime.now(),
                  ),
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            )),
          ),
          Expanded(
            child: Consumer<AlarmProvider>(builder: (context, alarm, child) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                    itemCount: alarm.modelist.length,
                    itemBuilder: (BuildContext, index) {
                      return Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                             //   height: MediaQuery.of(context).size.height * 0.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),

                               child: Dismissible(
                                   confirmDismiss: (direction) async {
                                       final bool res = await showDialog(
                                           context: context,
                                           builder: ( context) {
                                             return AlertDialog(
                                               content: Text(
                                                   "Are you sure you want to delete?"),
                                               actions: <Widget>[
                                                 TextButton(
                                                   child: Text(
                                                     "Cancel",
                                                     style: TextStyle(color: Colors.black),
                                                   ),
                                                   onPressed: () {
                                                     Navigator.of(context).pop();
                                                   },
                                                 ),
                                                 TextButton(
                                                   child: Text(
                                                     "Delete",
                                                     style: TextStyle(color: Colors.red),
                                                   ),
                                                   onPressed: () {
                                                     setState(() {
                                                       alarm.deleteAlarm(alarm.modelist[index].id!.toInt());
                                                     });
                                                     Navigator.of(context).pop();
                                                   },
                                                 ),
                                               ],
                                             );
                                           });
                                       return res;
                                   },
                                 key: ValueKey(alarm.modelist[index].id),

                                 background: Container(
                                   color: Colors.red,
                                   child: Align(
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.end,
                                       children: <Widget>[
                                         Icon(
                                           Icons.delete,
                                           color: Colors.white,
                                         ),
                                         Text(
                                           " Delete",
                                           style: TextStyle(
                                             color: Colors.white,
                                             fontWeight: FontWeight.w700,
                                           ),
                                           textAlign: TextAlign.right,
                                         ),
                                         SizedBox(
                                           width: 20,
                                         ),
                                       ],
                                     ),
                                     alignment: Alignment.centerRight,
                                   ),
                                 ),

                                 child: ListTile(

                                    leading: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(  alarm.modelist[index].dateTime!.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black),),
                                        Text(alarm.modelist[index].when.toString()),
                                      ],
                                    ),
                                    title:    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 15.0,),
                                      child: Text(alarm.modelist[index].label == '' ? 'No label' : alarm.modelist[index].label.toString() ,style: TextStyle(color: Colors.green),),
                                    ),
                                    trailing:    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        alarm.modelist[index].milliseconds! < DateTime.now().microsecondsSinceEpoch
                                            ? const Text("Done",style: TextStyle(color: Colors.green),)
                                            : const Text("Upcoming",style: TextStyle(color: Color(0xffE25E2A)),),

                                      ],
                                    ),
                                   // subtitle: Text(alarm.modelist[index].when.toString()),
                                  ),
                               )
                              )),
                          Divider()
                        ],
                      );
                    }),
              );
            }),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomButton(
                iconData: Icons.add ,
                width: width/2.3,
                buttonText: 'Add Event',
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddAlarm()));
                }),
          ),
        ],
      ),
    );
  }
}

// class EventsTab extends StatefulWidget {
//   const EventsTab({super.key});
//
//   @override
//   State<EventsTab> createState() => _EventsTabState();
// }
//
// class _EventsTabState extends State<EventsTab> {
//   List<Map<String, dynamic>>? favourites;
//   final storage = GetStorage();
//
//
//   void _showAddDialogue(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return AddDialogue(
//           onEventAdded: () {
//             setState(() {});
//             Navigator.pop(context);
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     favourites = (storage.read('events') as List?)?.cast<Map<String, dynamic>>() ?? [];
//   }
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//
//     return Center(
//       child: Stack(
//           children: [
//             favourites!.isEmpty ?
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Image.asset('assets/eventpic.png',scale: 2,),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "No Events",
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ],
//               ),
//             ) : SizedBox(
//               height: 500,
//               child: ListView.builder(
//                   itemCount: favourites?.length,
//                   itemBuilder: (context,index){
//                     return ListTile(
//                       title: Column(
//                         children: [
//                           Container(
//                             height: 41,
//                             width: 392,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(width: 1.0),
//                               borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     DateFormat('dd-MMM-y').format(DateTime.parse(favourites![index]['date'].toString())),
//
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       subtitle: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(favourites![index]['reminder'].toString(),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child:
//                             Text(favourites![index]['event'].toString(),textAlign: TextAlign.center,
//                               style:  const TextStyle(color:  Color(0xffE25E2A,),fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () {
//                               List<dynamic> events = storage.read('events') ?? [];
//                               events.remove(favourites![index]);
//                               storage.write('events', events);
//                               setState(() {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text('Event deleted'),
//                                     duration: Duration(seconds: 2),
//                                   ),
//                                 );
//                               });
//                             },
//                           ),
//
//                         ],
//
//                       ),
//
//                     );
//                   }),
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: CustomButton(
//                   iconData: Icons.add ,
//                   width: width/2.3,
//                   buttonText: 'Add Event',
//                   onPressed: (){
//                     _showAddDialogue(context);
//                   }),
//             ),
//           ]
//       ),
//     );
//   }
// }
