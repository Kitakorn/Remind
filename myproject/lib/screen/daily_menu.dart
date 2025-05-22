import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myproject/Services/notification_service.dart';
import 'package:myproject/component/popup.dart';
import 'package:myproject/model/data.dart';

class DailyMenu extends StatefulWidget {
  const DailyMenu({super.key});

  @override
  State<DailyMenu> createState() => _DailyMenuState();
}

class _DailyMenuState extends State<DailyMenu> {
  Menu? newMenu;

  warningTime() => showDialog(
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
              'You should have at least 1 reminding time',
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
                ),
              ),
            ],
          ));

  saveMenu(Menu? newMenu, {int? index}) {
    if (newMenu != null) {
      newMenu.id = newMenu.hashCode;
      setState(() {
        if (index != null) {
          var formerID = menuList[index].id!;
          NotificationService().cancelIDNotification(formerID);
          DBStorage.deleteMenu(formerID);
          menuList[index] = newMenu;
          DBStorage.insertMenu(newMenu);
          NotificationService().showNotification(
              menuList[index].id!,
              menuList[index].name,
              Time.timeToDateTime(
                  menuList[index].startDate, menuList[index].time));
        } else {
          menuList.add(newMenu);
          DBStorage.insertMenu(newMenu);
          NotificationService().showNotification(newMenu.id!, newMenu.name,
              Time.timeToDateTime(newMenu.startDate, newMenu.time));
        }
      });
    }
  }

  deleteMenu(int index) => showDialog(
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
              'Are you sure to delete this menuList',
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
                      NotificationService()
                          .cancelIDNotification(menuList[index].id!);
                      DBStorage.deleteMenu(menuList[index].id!);
                      menuList.removeAt(index);
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
    final thisDay = ModalRoute.of(context)!.settings.arguments as DateTime;
    final toDayMenu =
        menuList.where((e) => e.startDate.weekday == thisDay.weekday).toList();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          color: const Color.fromARGB(255, 254, 114, 76),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  //color: Theme.of(context).colorScheme.onPrimary,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: Text('Date: ${DateFormat.yMMMMd().format(thisDay)}',
                      style: GoogleFonts.openSans(
                        //color: Theme.of(context).colorScheme.onPrimary,
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ]),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: toDayMenu.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onLongPress: () => deleteMenu(index),
                      onPressed: () async {
                        newMenu = await Popup().showdialog(
                            context, toDayMenu[index].startDate,
                            passedName: toDayMenu[index].name,
                            passedTime: toDayMenu[index].time,
                            passedIcon: toDayMenu[index].icon);
                        saveMenu(newMenu, index: index);
                      },
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        backgroundColor:
                            const Color.fromARGB(255, 255, 197, 41),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 4.0,
                        padding: const EdgeInsets.all(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            toDayMenu[index].icon.icon,
                            size: 50,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${Time.formatTime(toDayMenu[index].time.hour)}:${Time.formatTime(toDayMenu[index].time.minute)}',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              Text(
                                toDayMenu[index].name,
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
          OverflowBar(
            children: [
              IconButton(
                onPressed: () async {
                  (timeSlots.isEmpty) ? warningTime() : null;
                  newMenu = await Popup().showdialog(context, thisDay,
                      passedTime: timeSlots[0],
                      passedIcon: IconSlots.breakfast);
                  saveMenu(newMenu);
                },
                icon: const Icon(Icons.add),
                iconSize: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
