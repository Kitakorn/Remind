// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/Services/notification_service.dart';
import 'package:myproject/screen/daily_menu.dart';
import 'package:myproject/screen/home_page.dart';
import 'package:myproject/screen/notification_test.dart';
import 'package:myproject/screen/time_slots.dart';
import 'package:myproject/model/data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DBStorage.retrieveTime();
  DBStorage.retrieveMenu();
  NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: const NotificationTest(),
      initialRoute: '/homepage',
      routes: {
        '/homepage': (context) => const Home(),
        '/settimepage': (context) => const TimeSlots(),
        '/setmenupage': (context) => const DailyMenu(),
      },
    );
  }
}
