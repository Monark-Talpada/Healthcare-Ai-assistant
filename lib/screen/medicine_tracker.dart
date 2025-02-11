import 'package:flutter/material.dart';

class MedicineTrackerScreen extends StatefulWidget {
  const MedicineTrackerScreen({Key? key}) : super(key: key);

  @override
  _MedicineTrackerScreenState createState() => _MedicineTrackerScreenState();
}

class _MedicineTrackerScreenState extends State<MedicineTrackerScreen> {
  final List<Map<String, dynamic>> medicines = [
    {
      'name': 'Paracetamol',
      'time': '08:00 AM',
      'dosage': '1 Tablet',
    },
    {
      'name': 'Vitamin C',
      'time': '12:30 PM',
      'dosage': '1 Tablet',
    },
    {
      'name': 'Antibiotic',
      'time': '07:00 PM',
      'dosage': '2 Capsules',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Tracker"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Medicine Schedule',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: medicines.isEmpty
                  ? const Center(child: Text("No medicines added yet."))
                  : ListView.builder(
                      itemCount: medicines.length,
                      itemBuilder: (context, index) {
                        final medicine = medicines[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: const Icon(Icons.medication, color: Colors.blue),
                            title: Text(
                              medicine['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "🕒 Time: ${medicine['time']}\n💊 Dosage: ${medicine['dosage']}",
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Future functionality for adding medicines
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Add Medicine feature coming soon!")),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Medicine"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
