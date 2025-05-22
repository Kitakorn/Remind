import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/component/scrollwheelclock.dart';
import 'package:myproject/model/data.dart';

class TimeSlots extends StatefulWidget {
  const TimeSlots({super.key});

  @override
  State<TimeSlots> createState() => _TimeSlotsState();
}

class _TimeSlotsState extends State<TimeSlots> {
  Time? newTimeSlot;

  saveTime(Time? newTimeSlot, {int? index}) {
    if (newTimeSlot != null) {
      setState(() {
        if (index != null) {
          DBStorage.deleteTime(timeSlots[index].id);
          timeSlots[index] = newTimeSlot;
          DBStorage.insertTime(newTimeSlot);
        } else {
          timeSlots.add(newTimeSlot);
          DBStorage.insertTime(newTimeSlot);
        }
      });
    }
  }

  deleteTime(int index) => showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Warning',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Are you sure to delete this time slot',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.orange),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      DBStorage.deleteTime(timeSlots[index].id);
                      timeSlots.removeAt(index);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.orange),
                  ))
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 215, 215),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          color: Colors.transparent,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: const Color.fromARGB(255, 39, 45, 47)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: Center(
                    child: Text('Time Slots',
                        style: GoogleFonts.openSans(
                          color: const Color.fromARGB(255, 39, 45, 47),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ]),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onLongPress: () => deleteTime(index),
                    onPressed: () async {
                      newTimeSlot = await Scrollwheelclock().showdialog(context,
                          passedHour: timeSlots[index].hour,
                          passedMinute: timeSlots[index].minute);
                      saveTime(newTimeSlot, index: index);
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      backgroundColor: const Color.fromARGB(255, 255, 197, 41),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 4.0,
                      padding: const EdgeInsets.all(20),
                    ),
                    child: Text(
                      "${Time.formatTime(timeSlots[index].hour)}:${Time.formatTime(timeSlots[index].minute)}",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
        ),
        OverflowBar(
          children: [
            IconButton(
              onPressed: () async {
                newTimeSlot = await Scrollwheelclock().showdialog(context);
                saveTime(newTimeSlot);
              },
              icon: const Icon(Icons.add),
              iconSize: 40,
            ),
          ],
        ),
      ]),
    );
  }
}
