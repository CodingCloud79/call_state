import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phone_state/phone_state.dart';
import 'package:permission_handler/permission_handler.dart';

class CallStateApp extends StatefulWidget {
  const CallStateApp({super.key});

  @override
  State<CallStateApp> createState() => _CallStateAppState();
}

class _CallStateAppState extends State<CallStateApp> {
  PhoneState status = PhoneState.nothing();
  bool granted = false;

  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();

    return switch (status) {
      PermissionStatus.denied || PermissionStatus.restricted || PermissionStatus.limited || PermissionStatus.permanentlyDenied => false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) setStream();
  }

  void setStream() {
    PhoneState.stream.listen((event) {
      setState(() {
        if (event != null) {
          status = event;
        }
      });
    });
  }
  
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone State"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (Platform.isAndroid)
              MaterialButton(
                onPressed: !granted
                    ? () async {
                        bool temp = await requestPermission();
                        setState(() {
                          granted = temp;
                          if (granted) {
                            setStream();
                          }
                        });
                      }
                    : null,
                child: const Text("Request permission of Phone"),
              ),
            const Text(
              "Status of call",
              style: TextStyle(fontSize: 24),
            ),
            if (status.status == PhoneStateStatus.CALL_INCOMING || status.status == PhoneStateStatus.CALL_STARTED)
              Text(
                "Number: ${status.number}",
                style: const TextStyle(fontSize: 24),
              ),
            Icon(
              getIcons(),
              color: getColor(),
              size: 80,
            )
          ],
        ),
      ),
    );
  }

  IconData getIcons() {
    return switch (status.status) {
      PhoneStateStatus.NOTHING => Icons.clear,
      PhoneStateStatus.CALL_INCOMING => Icons.add_call,
      PhoneStateStatus.CALL_STARTED => Icons.call,
      PhoneStateStatus.CALL_ENDED => Icons.call_end,
    };
  }

  Color getColor() {
    return switch (status.status) {
      PhoneStateStatus.NOTHING || PhoneStateStatus.CALL_ENDED => Colors.red,
      PhoneStateStatus.CALL_INCOMING => Colors.green,
      PhoneStateStatus.CALL_STARTED => Colors.orange,
    };
  }
}