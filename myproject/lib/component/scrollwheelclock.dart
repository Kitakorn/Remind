import 'package:flutter/material.dart';
import 'package:myproject/model/data.dart';

class Scrollwheelclock {
  Future showdialog(BuildContext context,
      {int passedHour = 0, int passedMinute = 0}) {
    int hour = passedHour;
    int minute = passedMinute;

    return showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: const Color.fromARGB(255, 255, 197, 41),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Time',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    '${Time.formatTime(hour)}:${Time.formatTime(minute)}',
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          onSelectedItemChanged: (value) {
                            setState(
                              () {
                                hour = value;
                              },
                            );
                          },
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: 100,
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: List.generate(
                              24,
                              (index) => Center(
                                child: Text(
                                  index < 10 ? '0$index' : index.toString(),
                                  style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          onSelectedItemChanged: (value) {
                            setState(
                              () {
                                minute = value;
                              },
                            );
                          },
                          physics: const FixedExtentScrollPhysics(),
                          itemExtent: 100,
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: List.generate(
                              60,
                              (index) => Center(
                                child: Text(
                                  index < 10 ? '0$index' : index.toString(),
                                  style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 254, 114, 76),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 4.0,
                        //padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(Time(
                            id: Time.timeToID(hour, minute),
                            hour: hour,
                            minute: minute));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 254, 114, 76),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 4.0,
                        //padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        ' Save ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
