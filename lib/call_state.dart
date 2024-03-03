// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:phone_state/phone_state.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CallStateApp extends StatefulWidget {
//   const CallStateApp({super.key});

//   @override
//   State<CallStateApp> createState() => _CallStateAppState();
// }

// class _CallStateAppState extends State<CallStateApp> {
//   PhoneState status = PhoneState.nothing();
//   bool granted = false;

//   Future<bool> requestPermission() async {
//     var status = await Permission.phone.request();

//     return switch (status) {
//       PermissionStatus.denied ||
//       PermissionStatus.restricted ||
//       PermissionStatus.limited ||
//       PermissionStatus.permanentlyDenied =>
//         false,
//       PermissionStatus.provisional || PermissionStatus.granted => true,
//     };
//   }

//   @override
//   void initState() {
//     super.initState();
//     requestPermission();
//     if (Platform.isIOS) setStream();
//   }

//   void setStream() {
//     PhoneState.stream.listen((event) {
//       setState(() {
//         if (event != null) {
//           status = event;
//         }
//       });
//     });
//   }

//   void showAlertDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text("Is this call Important?"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               debugPrint("Important Call");
//               Navigator.of(context).pop();
//             },
//             child: const Text("Yes"),
//           ),
//           TextButton(
//             onPressed: () {
//               debugPrint("Not Important Call");
//               Navigator.pop(context);
//             },
//             child: const Text("No"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Phone State"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (Platform.isAndroid)
//               MaterialButton(
//                 onPressed: !granted
//                     ? () async {
//                         bool temp = await requestPermission();
//                         setState(() {
//                           granted = temp;
//                           if (granted) {
//                             setStream();
//                           }
//                         });
//                       }
//                     : null,
//                 child: const Text("Request permission of Phone"),
//               ),
//             const Text(
//               "CALL STATUS",
//               style: TextStyle(fontSize: 24),
//             ),
//             if (status.status == PhoneStateStatus.CALL_INCOMING ||
//                 status.status == PhoneStateStatus.CALL_STARTED)
//               Text(
//                 "Number: ${status.number}",
//                 style: const TextStyle(fontSize: 24),
//               ),
//             if (status.status == PhoneStateStatus.CALL_ENDED)
//               buildAlertDialog(),
//             if (status.status == PhoneStateStatus.CALL_STARTED)
//               const Text(
//                 "CALL STARTED ",
//                 style: TextStyle(fontSize: 24),
//               ),
//             Icon(
//               getIcons(),
//               color: getColor(),
//               size: 80,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildAlertDialog() {
//     if (status.status == PhoneStateStatus.CALL_ENDED) {
//       WidgetsBinding.instance.addPostFrameCallback((_) => showAlertDialog());
//     }
//     return Container();
//   }

//   IconData getIcons() {
//     return switch (status.status) {
//       PhoneStateStatus.NOTHING => Icons.clear,
//       PhoneStateStatus.CALL_INCOMING => Icons.add_call,
//       PhoneStateStatus.CALL_STARTED => Icons.call,
//       PhoneStateStatus.CALL_ENDED => Icons.call_end,
//     };
//   }

//   Color getColor() {
//     return switch (status.status) {
//       PhoneStateStatus.NOTHING || PhoneStateStatus.CALL_ENDED => Colors.red,
//       PhoneStateStatus.CALL_INCOMING => Colors.green,
//       PhoneStateStatus.CALL_STARTED => Colors.orange,
//     };
//   }

//   // Widget buildAlertDialog() {
//   //   if (status.status == PhoneStateStatus.CALL_ENDED) {
//   //     showDialog(
//   //       context: context,
//   //       builder: (context) {
//   //         return AlertDialog(
//   //           title: const Text("Is this call Important?"),
//   //           actions: [
//   //             TextButton(
//   //               onPressed: () {
//   //                 debugPrint("Important Call");
//   //                 Navigator.of(context).pop();
//   //               },
//   //               child: const Text("Yes"),
//   //             ),
//   //             TextButton(
//   //               onPressed: () {
//   //                 Navigator.of(context).pop();

//   //                 debugPrint("Not Important Call");
//   //               },
//   //               child: const Text("No"),
//   //             ),
//   //           ],
//   //         );
//   //       },
//   //     );
//   //     return Container(); // Placeholder widget when no dialog is needed
//   //   } else {
//   //     return Container(); // Placeholder widget when no dialog is needed
//   //   }
//   // }
// }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:phone_state/phone_state.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CallStateApp extends StatefulWidget {
//   const CallStateApp({Key? key}) : super(key: key);

//   @override
//   State<CallStateApp> createState() => _CallStateAppState();
// }

// class _CallStateAppState extends State<CallStateApp> {
//   PhoneState status = PhoneState.nothing();

//   @override
//   void initState() {
//     super.initState();
//     requestPermission();
//     if (Platform.isIOS) {
//       setStream();
//     }
//   }

//   void requestPermission() async {
//     var status = await Permission.phone.request();

//     if (status == PermissionStatus.granted) {
//       setState(() {
//         setStream();
//       });
//     }
//   }

//   void setStream() {
//     PhoneState.stream.listen((event) {
//       setState(() {
//         if (event != null) {
//           status = event;
//         }
//       });
//     });
//   }

//   void showAlertDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Text("Is this call Important?"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               debugPrint("Important Call");
//               Navigator.of(context).pop();
//             },
//             child: const Text("Yes"),
//           ),
//           TextButton(
//             onPressed: () {
//               debugPrint("Not Important Call");
//               Navigator.pop(context);
//             },
//             child: const Text("No"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Phone State"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               "CALL STATUS",
//               style: TextStyle(fontSize: 24),
//             ),
//             if (status.status == PhoneStateStatus.CALL_INCOMING ||
//                 status.status == PhoneStateStatus.CALL_STARTED)
//               Text(
//                 "Number: ${status.number}",
//                 style: const TextStyle(fontSize: 24),
//               ),
//             if (status.status == PhoneStateStatus.CALL_ENDED)
//               buildAlertDialog(),
//             if (status.status == PhoneStateStatus.CALL_STARTED)
//               const Text(
//                 "CALL STARTED ",
//                 style: TextStyle(fontSize: 24),
//               ),
//             Icon(
//               getIcons(),
//               color: getColor(),
//               size: 80,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildAlertDialog() {
//     if (status.status == PhoneStateStatus.CALL_ENDED) {
//       WidgetsBinding.instance.addPostFrameCallback((_) => showAlertDialog());
//     }
//     return Container();
//   }

//   IconData getIcons() {
//     switch (status.status) {
//       case PhoneStateStatus.NOTHING:
//         return Icons.clear;
//       case PhoneStateStatus.CALL_INCOMING:
//         return Icons.add_call;
//       case PhoneStateStatus.CALL_STARTED:
//         return Icons.call;
//       case PhoneStateStatus.CALL_ENDED:
//         return Icons.call_end;
//     }
//   }

//   Color getColor() {
//     switch (status.status) {
//       case PhoneStateStatus.NOTHING:
//       case PhoneStateStatus.CALL_ENDED:
//         return Colors.red;
//       case PhoneStateStatus.CALL_INCOMING:
//         return Colors.green;
//       case PhoneStateStatus.CALL_STARTED:
//         return Colors.orange;
//     }
//   }
// }
