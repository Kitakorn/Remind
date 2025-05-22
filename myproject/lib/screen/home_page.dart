import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/component/todaymenu.dart';
import 'package:myproject/model/data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    DBStorage.retrieveMenu().then((listOfMenu) {
      setState(() {
        menuList = listOfMenu;
      });
    });
    DBStorage.retrieveTime().then((listOfTime) {
      setState(() {
        timeSlots = listOfTime;
      });
    });
    Timer.periodic(const Duration(), (timer) {
      if (now.day != DateTime.now().day) {
        setState(() {
          now = DateTime.now();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final thisWeek = List<DateTime>.generate(
        7, (int index) => now.add(Duration(days: index)),
        growable: true);
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color.fromARGB(255, 215, 215, 215),
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'Reminder',
          style: GoogleFonts.openSans(
              textStyle:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          todaymenu(context, now),
          Expanded(
            child: ListView.builder(
              itemCount: thisWeek.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/setmenupage', arguments: thisWeek[index])
                          .then((value) => setState(() {}));
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      backgroundColor: const Color.fromARGB(255, 254, 114, 76),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 4.0,
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          DateFormat.yMMMMd().format(thisWeek[index]),
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settimepage');
            },
            icon: const Icon(Icons.access_time),
            iconSize: 35,
          ),
        ],
      ),
    );
  }
}
