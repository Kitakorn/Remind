import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myproject/Services/notification_service.dart';

class NotificationTest extends StatefulWidget {
  const NotificationTest({super.key});

  @override
  State<NotificationTest> createState() => _NotificationTestState();
}

class _NotificationTestState extends State<NotificationTest> {
  DateTime now = DateTime.now();
  DateTime notiTime = DateTime(2024, 8, 5, 16, 35);

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$now'),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                //NotificationService().showNotification(notiTime);
                //NotificationService().showSimpleNotification();
                NotificationService().showRepeatNotification();
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green)),
              child: const Text(
                'simple noti',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                NotificationService().cancelAllNotification();
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.green)),
              child: const Text(
                'cancel noti',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
