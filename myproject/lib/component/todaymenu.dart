import 'package:flutter/material.dart';
import 'package:myproject/model/data.dart';

Widget todaymenu(BuildContext context, DateTime now) {
  final showToDayMenu =
      menuList.where((e) => e.startDate.weekday == now.weekday).toList();
  //final showToDayMenu = menu;
  Color pritheme = const Color.fromARGB(255, 254, 114, 76);
  return Container(
    height: MediaQuery.of(context).size.height / 2,
    margin: const EdgeInsets.all(15),
    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: pritheme,
        width: 5,
        style: BorderStyle.solid,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' Today',
          style: TextStyle(
              fontSize: 32, color: pritheme, fontWeight: FontWeight.bold),
        ),
        Divider(thickness: 3, color: pritheme, indent: 5, endIndent: 5),
        Expanded(
          child: ListView.builder(
              itemCount: showToDayMenu.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        showToDayMenu[index].icon.icon,
                        size: 50,
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${Time.formatTime(showToDayMenu[index].time.hour)}:${Time.formatTime(showToDayMenu[index].time.minute)}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.grey),
                          ),
                          Text(
                            showToDayMenu[index].name,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    ),
  );
}
