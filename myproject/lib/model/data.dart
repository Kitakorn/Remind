import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum IconSlots {
  breakfast(icon: Icons.breakfast_dining, name: 'Breakfast'),
  lunch(icon: Icons.lunch_dining, name: 'Lunch'),
  dinner(icon: Icons.dinner_dining, name: 'Dinner'),
  supper(icon: Icons.nightlife, name: 'Supper'),
  snack(icon: Icons.coffee, name: 'Snack');

  const IconSlots({required this.icon, required this.name});
  final IconData icon;
  final String name;

  static getIconElement(String name) =>
      IconSlots.values.firstWhere((e) => e.name == name);
}

class DBStorage {
  static Database? database;

  static Future<Database> getDBConnector() async {
    if (database != null) {
      return database!;
    }
    return await initialize();
  }

  static Future<Database> initialize() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE menus(
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        iconName TEXT, 
        year INTEGER, 
        month INTEGER, 
        day INTEGER, 
        hour INTEGER, 
        minute INTEGER)
        ''');

        await db.execute('''
        CREATE TABLE times(
        id INTEGER PRIMARY KEY,  
        hour INTEGER, 
        minute INTEGER)
        ''');
      },
      version: 1,
    );
    return database!;
  }

  static Future<void> insertMenu(Menu menu) async {
    final Database db = await getDBConnector();
    await db.insert(
      'menus',
      menu.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Menu>> retrieveMenu() async {
    final Database db = await getDBConnector();
    final List<Map<String, Object?>> menuMaps = await db.query('menus');
    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'iconName': iconName as String,
            'year': year as int,
            'month': month as int,
            'day': day as int,
            'hour': hour as int,
            'minute': minute as int,
          } in menuMaps)
        Menu(
            name: name,
            icon: IconSlots.getIconElement(iconName),
            startDate: DateTime(year, month, day),
            time: Time(
                id: Time.timeToID(hour, minute), hour: hour, minute: minute),
            id: id),
    ];
  }

  static Future<void> deleteMenu(int id) async {
    final Database db = await getDBConnector();
    await db.delete(
      'menus',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> insertTime(Time time) async {
    final Database db = await getDBConnector();
    await db.insert(
      'times',
      time.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Time>> retrieveTime() async {
    final Database db = await getDBConnector();
    final List<Map<String, Object?>> timeMaps = await db.query('times');
    return [
      for (final {
            'id': id as int,
            'hour': hour as int,
            'minute': minute as int,
          } in timeMaps)
        Time(id: id, hour: hour, minute: minute),
    ];
    /*
    (timeSlots.isEmpty)
        ? timeSlots.add(Time(id: Time.timeToID(7, 30), hour: 7, minute: 30))
        : null;
    */
  }

  static Future<void> deleteTime(int id) async {
    final Database db = await getDBConnector();
    await db.delete(
      'times',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Menu {
  Menu({
    this.id,
    required this.name,
    required this.icon,
    required this.startDate,
    required this.time,
  });

  int? id;
  String name;
  IconSlots icon;
  DateTime startDate;
  Time time;

  static menuToID(String name, DateTime startDate) {
    var namehashed = name.hashCode;
    return int.parse(startDate.weekday.toString() + namehashed.toString());
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'iconName': icon.name,
      'year': startDate.year,
      'month': startDate.month,
      'day': startDate.day,
      'hour': time.hour,
      'minute': time.minute,
    };
  }
}

class Time {
  Time({required this.id, required this.hour, required this.minute});
  int id;
  int hour;
  int minute;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
    };
  }

  static timeToID(int hour, int minute) {
    return 10000 + hour * 100 + minute;
  }

  static formatTime(int num) {
    return num < 10 ? '0$num' : num.toString();
  }

  static timeToDateTime(DateTime startDate, Time time) {
    return startDate.copyWith(hour: time.hour, minute: time.minute, second: 0);
  }
}

List<Time> timeSlots = [Time(id: 730, hour: 7, minute: 30)];

List<Menu> menuList = [];
