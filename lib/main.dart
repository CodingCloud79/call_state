import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state_background/phone_state_background.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:device_apps/device_apps.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemAlertWindow.registerOnClickListener(callBack);
  await _initializeServices();

  runApp(const MyApp());
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
      log("$e");
    }
  }
}

Future<void> _initializeServices() async {
  await _requestPermissions();
  await _startPhoneStateBackgroundService();
}

Future<void> _requestPermissions() async {
  await Permission.phone.request();
  await Permission.systemAlertWindow.request();
}

Future<void> _startPhoneStateBackgroundService() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PhoneStateBackground.initialize(phoneStateBackgroundCallbackHandler);
}

Future<void> phoneStateBackgroundCallbackHandler(
    PhoneStateBackgroundEvent event, String number, int duration) async {
  switch (event) {
    case PhoneStateBackgroundEvent.incomingstart:
      debugPrint('Incoming call start, $number, duration: $duration s');
      log('Incoming call start, $number, duration: $duration s');
      break;
    case PhoneStateBackgroundEvent.incomingmissed:
      _showSystemAlertWindow(number);
      debugPrint('Incoming call missed, $number, duration: $duration s');
      log('Incoming call missed, $number, duration: $duration s');
      break;
    case PhoneStateBackgroundEvent.incomingreceived:
      debugPrint('Incoming call received, $number, duration: $duration s');
      log('Incoming call received, $number, duration: $duration s');
      break;
    case PhoneStateBackgroundEvent.incomingend:
      _showSystemAlertWindow(number);
      debugPrint('Incoming call ended, $number, duration $duration s');
      log('Incoming call ended, $number, duration $duration s');
      break;
    case PhoneStateBackgroundEvent.outgoingstart:
      debugPrint('Outgoing call start, $number, duration: $duration s');
      log('Outgoing call start, $number, duration: $duration s');
      break;
    case PhoneStateBackgroundEvent.outgoingend:
      _showSystemAlertWindow(number);
      debugPrint('Outgoing call ended, $number, duration: $duration s');
      log('Outgoing call ended, $number, duration: $duration s');
      break;
  }
}

void _showSystemAlertWindow(String number) {
  SystemAlertWindow.showSystemWindow(
    height: 200,
    header: SystemWindowHeader(
      title: SystemWindowText(
        text: "$number",
      ),
      subTitle: SystemWindowText(text: "Is this Call Important ?"),
      decoration: SystemWindowDecoration(
        startColor: Colors.transparent,
        endColor: Colors.transparent,
      ),
    ),
    body: SystemWindowBody(rows: []),
    footer: SystemWindowFooter(
      buttons: [
        SystemWindowButton(
          text: SystemWindowText(text: "Close"),
          tag: 'close',
        ),
        SystemWindowButton(
          text: SystemWindowText(text: "Yes"),
          tag: 'yes',
        ),
      ],
    ),
    prefMode: SystemWindowPrefMode.OVERLAY,
  );
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

class _MyHomePageState extends State<MyHomePage> {
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    _hasPermission();
  }

  Future<void> _hasPermission() async {
    final permission = await PhoneStateBackground.checkPermission();
    setState(() => hasPermission = permission);
  }

  Future<void> _stop() async {
    debugPrint("Service Stopped !");
    log("Service Stopped !");
    await PhoneStateBackground.stopPhoneStateBackground();
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
            // SizedBox(
            //   width: 180,
            //   child: ElevatedButton(
            //     onPressed: () => _requestPermission(),
            //     child: const Text('Check Permission'),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 20),
            //   child: SizedBox(
            //     width: 180,
            //     child: ElevatedButton(
            //       onPressed: () => _startService(),
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.green, // Background color
            //       ),
            //       child: const Text('Start Listener'),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: 180,
            //   child: ElevatedButton(
            //     onPressed: () => _stop(),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.red, // Background color
            //     ),
            //     child: const Text('Stop Listener'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _startService() async {
    if (hasPermission) {
      await PhoneStateBackground.initialize(
          phoneStateBackgroundCallbackHandler);
    } else {
      debugPrint("Permission denied.");
      log("Permission denied.");
    }
  }

  Future<void> _requestPermission() async {
    await Permission.phone.request();
    final status = await Permission.phone.status;
    if (status.isGranted) {
      debugPrint("Got the Permission .");
      log("Got the Permission .");
      setState(() => hasPermission = true);
    } else {
      debugPrint("Permission Denied .");
      log("Permission Denied .");
    }
  }
}

// GPT Organized
