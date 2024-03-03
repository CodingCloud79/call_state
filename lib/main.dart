// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// // import 'package:flutter_background/flutter_background.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:phone_state/phone_state.dart';
// import 'package:system_alert_window/system_alert_window.dart';
// // import 'package:workmanager/workmanager.dart';

// // void callBackDispatcher() {
// //   Workmanager().executeTask((taskName, inputData) {
// //     debugPrint("Call state ");
// //     return Future.value(true);
// //   });
// // }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // FlutterBackground.initialize;
//   await SystemAlertWindow.requestPermissions(
//       prefMode: SystemWindowPrefMode.OVERLAY);
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
//       ),
//       home: const CallStateApp(),
//     );
//   }
// }

// class CallStateApp extends StatefulWidget {
//   const CallStateApp({Key? key}) : super(key: key);

//   @override
//   State<CallStateApp> createState() => _CallStateAppState();
// }

// class _CallStateAppState extends State<CallStateApp> {
//   PhoneState status = PhoneState.nothing();

//   // Future<void> enableBackgroundServices() async {
//   //   var config = const FlutterBackgroundAndroidConfig(
//   //     notificationTitle: 'flutter_background example app',
//   //     notificationText:
//   //         'Background notification for keeping the example app running in the background',
//   //     notificationIcon: AndroidResource(name: 'background_icon'),
//   //     notificationImportance: AndroidNotificationImportance.Default,
//   //     enableWifiLock: true,
//   //     showBadge: true,
//   //   );

//   //   var hasPermissions = await FlutterBackground.hasPermissions;
//   //   debugPrint("Background Permission : $hasPermissions");
//   //   hasPermissions = await FlutterBackground.initialize(androidConfig: config);

//   //   SystemWindowHeader header = SystemWindowHeader(
//   //       title: SystemWindowText(
//   //           text: "Incoming Call", fontSize: 10, textColor: Colors.black45),
//   //       padding: SystemWindowPadding.setSymmetricPadding(12, 12),
//   //       subTitle: SystemWindowText(
//   //           text: "9898989899",
//   //           fontSize: 14,
//   //           fontWeight: FontWeight.BOLD,
//   //           textColor: Colors.black87),
//   //       decoration: SystemWindowDecoration(startColor: Colors.grey[100]),
//   //       button: SystemWindowButton(
//   //           text: SystemWindowText(
//   //               text: "Personal", fontSize: 10, textColor: Colors.black45),
//   //           tag: "personal_btn"),
//   //       buttonPosition: ButtonPosition.TRAILING);

//   //   if (hasPermissions) {
//   //     if (hasPermissions) {
//   //       final backgroundExecution =
//   //           await FlutterBackground.enableBackgroundExecution();

//   //       if (backgroundExecution) {
//   //         if (FlutterBackground.isBackgroundExecutionEnabled) {
//   //           debugPrint("in background ...");
//   //           // SystemAlertWindow.showSystemWindow(header: SystemWindowHeader());
//   //         }
//   //         // showDialog(
//   //         //   context: context,
//   //         //   builder: (context) => const AlertDialog(
//   //         //     title: Text("Running in bg "),
//   //         //   ),
//   //         // );
//   //       }
//   //     }
//   //   }
//   // }

//   @override
//   void initState() {
//     super.initState();
//     getSystemAlertPermission();
//     requestPermission();
//     // enableBackgroundServices();
//     SystemAlertWindow.registerOnClickListener((tag) {
//       if (tag == 'close') {
//         SystemAlertWindow.closeSystemWindow();
//       } else {
//         return null;
//       }
//     });
//     if (Platform.isIOS) {
//       setStream();
//     }
//   }

//   getSystemAlertPermission() async {
//     await SystemAlertWindow.checkPermissions;
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
//       // WidgetsBinding.instance.addPostFrameCallback((_) => showAlertDialog());
//       Workmanager().registerOneOffTask(
//         'callTask',
//         'callState',
//       );
//       WidgetsBinding.instance.addPostFrameCallback(
//         (_) => SystemAlertWindow.showSystemWindow(
//             height: 200,
//             header: SystemWindowHeader(
//               title: SystemWindowText(
//                 text: "${status.number}",
//               ),
//               subTitle: SystemWindowText(text: "Is this Call Important ?"),
//               decoration: SystemWindowDecoration(
//                 startColor: Colors.transparent,
//                 endColor: Colors.transparent,
//               ),
//             ),
//             body: SystemWindowBody(),
//             footer: SystemWindowFooter(
//               buttons: [
//                 SystemWindowButton(
//                     text: SystemWindowText(text: "CLose "), tag: 'close'),
//               ],
//             ),
//             prefMode: SystemWindowPrefMode.BUBBLE),
//       );
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

// Experiment
import 'dart:developer';
import 'package:device_apps/device_apps.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:phone_state_background/phone_state_background.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:url_launcher/url_launcher.dart';

/// Be sure to annotate @pragma('vm:entry-point') your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')

/// Defines a callback that will handle all background incoming events
Future<void> phoneStateBackgroundCallbackHandler(
  PhoneStateBackgroundEvent event,
  String number,
  int duration,
) async {
  switch (event) {
    case PhoneStateBackgroundEvent.incomingstart:
      debugPrint('Incoming call start, number: $number, duration: $duration s');
      break;
    case PhoneStateBackgroundEvent.incomingmissed:
      SystemAlertWindow.showSystemWindow(
        height: 200,
        header: SystemWindowHeader(
          title: SystemWindowText(
            text: "${number}",
          ),
          subTitle: SystemWindowText(text: "Is this Call Important ?"),
          decoration: SystemWindowDecoration(
            startColor: Colors.transparent,
            endColor: Colors.transparent,
          ),
        ),
        body: SystemWindowBody(),
        footer: SystemWindowFooter(
          buttons: [
            SystemWindowButton(
              text: SystemWindowText(text: "CLose "),
              tag: 'close',
            ),
            SystemWindowButton(
              text: SystemWindowText(text: "Yes "),
              tag: 'yes',
            ),
          ],
        ),
        prefMode: SystemWindowPrefMode.OVERLAY,
      );
      debugPrint(
          'Incoming call missed, number: $number, duration: $duration s');
      break;
    case PhoneStateBackgroundEvent.incomingreceived:
      debugPrint(
          'Incoming call received, number: $number, duration: $duration s');
      break;
    case PhoneStateBackgroundEvent.incomingend:
      SystemAlertWindow.showSystemWindow(
        height: 200,
        header: SystemWindowHeader(
          title: SystemWindowText(
            text: "${number}",
          ),
          subTitle: SystemWindowText(text: "Is this Call Important ?"),
          decoration: SystemWindowDecoration(
            startColor: Colors.transparent,
            endColor: Colors.transparent,
          ),
        ),
        body: SystemWindowBody(),
        footer: SystemWindowFooter(
          buttons: [
            SystemWindowButton(
              text: SystemWindowText(text: "CLose "),
              tag: 'close',
            ),
            SystemWindowButton(
              text: SystemWindowText(text: "Yes "),
              tag: 'yes',
            ),
          ],
        ),
        prefMode: SystemWindowPrefMode.OVERLAY,
      );
      debugPrint('Incoming call ended, number: $number, duration $duration s');
      break;
    case PhoneStateBackgroundEvent.outgoingstart:
      debugPrint('Outgoing call start, number: $number, duration: $duration s');
      break;
    case PhoneStateBackgroundEvent.outgoingend:
      SystemAlertWindow.showSystemWindow(
        height: 200,
        header: SystemWindowHeader(
          title: SystemWindowText(
            text: "${number}",
          ),
          subTitle: SystemWindowText(text: "Is this Call Important ?"),
          decoration: SystemWindowDecoration(
            startColor: Colors.transparent,
            endColor: Colors.transparent,
          ),
        ),
        body: SystemWindowBody(),
        footer: SystemWindowFooter(
          buttons: [
            SystemWindowButton(
              text: SystemWindowText(text: "CLose "),
              tag: 'close',
            ),
            SystemWindowButton(
              text: SystemWindowText(text: "Yes "),
              tag: 'yes',
            ),
          ],
        ),
        prefMode: SystemWindowPrefMode.OVERLAY,
      );
      debugPrint('Outgoing call ended, number: $number, duration: $duration s');
      break;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemAlertWindow.requestPermissions(prefMode: SystemWindowPrefMode.OVERLAY);
  await Permission.phone.request();
  await Permission.systemAlertWindow.request();
  SystemAlertWindow.registerOnClickListener(callBack);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone State Background',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Phone State Background'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool hasPermission = false;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await _hasPermission();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _requestPermission();
    _hasPermission();
    _init();
    super.initState();
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  Future<void> _hasPermission() async {
    final permission = await PhoneStateBackground.checkPermission();
    if (mounted) {
      setState(() => hasPermission = permission);
    }
  }

  Future<void> _requestPermission() async {
    // await PhoneStateBackground.requestPermissions();
    // Permission.phone.request();
    final status = await Permission.phone.status;
    if (status.isGranted) {
      debugPrint("Got the Permission .");
    } else {
      debugPrint("Permission Denied .");
    }
  }

  Future<void> _stop() async {
    debugPrint("Service Stopped !");
    await PhoneStateBackground.stopPhoneStateBackground();
  }

  Future<void> _init() async {
    if (hasPermission != true) return;
    await PhoneStateBackground.initialize(phoneStateBackgroundCallbackHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Has Permission: $hasPermission',
              style: TextStyle(
                fontSize: 16,
                color: hasPermission ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: () => _requestPermission(),
                child: const Text('Check Permission'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: () => _init(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                  ),
                  child: const Text('Start Listener'),
                ),
              ),
            ),
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: () => _stop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Background color
                ),
                child: const Text('Stop Listener'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void callBack(tag) async {
  print(tag);
  if (tag == 'close') {
    SystemAlertWindow.closeSystemWindow();
  }
  if (tag == 'yes') {
    try {
      SystemAlertWindow.closeSystemWindow();
      DeviceApps.openApp('com.example.call_state');
    } catch (e) {
      debugPrint("$e");
    }
  }
}
// Experiment

