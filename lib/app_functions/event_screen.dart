// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
//
// import 'add_Dialogue_box.dart';
// import 'custom_button.dart';
//
// class EventPage extends StatefulWidget {
//   const EventPage({super.key});
//
//   @override
//   State<EventPage> createState() => _EventPageState();
// }
//
// class _EventPageState extends State<EventPage> {
//
//   final storage = GetStorage();
//   List<Map<String, dynamic>>? favourites;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     favourites = (storage.read('events') as List?)?.cast<Map<String, dynamic>>() ?? [];
//
//   }
//   Widget build(BuildContext context) {
//     return  Center(
//         child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: CustomButton(iconData: Icons.add ,width: 150,buttonText: 'Add Event', onPressed: (){
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       builder: (BuildContext context) {
//                         return const AddDialogue();
//                       },
//                     );
//                   }),
//                 ),
//               ),
//               favourites!.isEmpty ?
//               Column(
//                 children: [
//                   Image.asset('assets/eventpic.png',scale: 2,),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "No Events",
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ],
//               ) : ListView.builder(
//                   itemCount: favourites?.length,
//                   itemBuilder: (context,index){
//                     return ListTile(
//                       trailing: Text(favourites![index]['date'].toString()),
//                       subtitle: Text(favourites![index]['reminder'].toString()),
//                       title: Text(favourites![index]['event'].toString()),
//                     );
//                   }),
//             ]));
//   }
// }
