import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddMedicineScreen extends StatefulWidget {
  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController reminderTimeController = TextEditingController();
  int noOfTimes = 1;
  DateTime? startDate;
  DateTime? endDate;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to pick a date
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime initialDate = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  // Function to add medicine data to Firestore
  void _addMedicine() async {
    if (medicineNameController.text.isEmpty ||
        dosageController.text.isEmpty ||
        reminderTimeController.text.isEmpty ||
        startDate == null ||
        endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields!")),
      );
      return;
    }

    try {
      await _firestore.collection("medicines").add({
        "userId": "xyz123", // Replace with actual user ID
        "medicineName": medicineNameController.text,
        "dosage": dosageController.text,
        "nooftime": noOfTimes,
        "reminderTime": reminderTimeController.text,
        "daySlot": {
          "startDate": DateFormat('yyyy-MM-dd').format(startDate!),
          "endDate": DateFormat('yyyy-MM-dd').format(endDate!),
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Medicine added successfully!")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add medicine")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Medicine")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: medicineNameController,
              decoration: InputDecoration(labelText: "Medicine Name"),
            ),
            TextField(
              controller: dosageController,
              decoration: InputDecoration(labelText: "Dosage (e.g., 2 capsules)"),
            ),
            TextField(
              controller: reminderTimeController,
              decoration: InputDecoration(labelText: "Reminder Time (e.g., 08:00 AM)"),
            ),
            SizedBox(height: 10),

            // Number of times selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("No. of times per day: $noOfTimes"),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (noOfTimes > 1) {
                          setState(() {
                            noOfTimes--;
                          });
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          noOfTimes++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10),

            // Day Slot Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Start Date: ${startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : "Select"}"),
                ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text("Pick Start Date"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("End Date: ${endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : "Select"}"),
                ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text("Pick End Date"),
                ),
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _addMedicine,
              child: Text("Add Medicine"),
            ),
          ],
        ),
      ),
    );
  }
}
