import 'package:flutter/material.dart';
import 'package:myproject/model/data.dart';

class Popup {
  Future showdialog(BuildContext context, DateTime startDate,
      {String? passedName,
      Time? passedTime,
      IconSlots passedIcon = IconSlots.breakfast}) {
    final formKey = GlobalKey<FormState>();
    String? name = passedName;
    Time? selectedTime = passedTime;
    IconSlots icon = passedIcon;
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Menu'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: name,
                  decoration:
                      const InputDecoration(hintText: 'Enter your menu'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your menu";
                    }
                    return null;
                  },
                  onSaved: (value) => name = value!,
                ),
                DropdownButtonFormField(
                  value: selectedTime,
                  decoration:
                      const InputDecoration(hintText: 'Select the time'),
                  items: List.generate(
                    timeSlots.length,
                    (index) => DropdownMenuItem(
                      value: timeSlots[index],
                      child: Text(
                        '${Time.formatTime(timeSlots[index].hour)}:${Time.formatTime(timeSlots[index].minute)}',
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Please select time";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    selectedTime = value!;
                  },
                ),
                DropdownButtonFormField(
                  value: icon,
                  decoration:
                      const InputDecoration(hintText: 'Select the icon'),
                  items: IconSlots.values.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.name),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return "Please select the icon";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    icon = value!;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              formKey.currentState!.reset();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10)),
            child: const Text(
              'Delete',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                Navigator.of(context).pop(Menu(
                    name: name!,
                    icon: icon,
                    startDate: startDate,
                    time: selectedTime!));
                formKey.currentState!.reset();
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(10)),
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
