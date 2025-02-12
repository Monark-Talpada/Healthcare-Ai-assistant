import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../services/medicine_service.dart';

class MedicineTrackingScreen extends StatefulWidget {
  const MedicineTrackingScreen({Key? key}) : super(key: key);

  @override
  _MedicineTrackingScreenState createState() => _MedicineTrackingScreenState();
}

class _MedicineTrackingScreenState extends State<MedicineTrackingScreen> {
  final MedicineService _medicineService = MedicineService();
  List<Medicine> _medicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    try {
      final medicines = await _medicineService.getMedicines();
      setState(() {
        _medicines = medicines;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading medicines: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  void _addMedicine() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        int dosesPerDay = 1;
        int quantity = 0;
        List<Timing> timings = [Timing(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute)];

        return AlertDialog(
          title: const Text('Add New Medicine'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Medicine Name'),
                  onChanged: (value) => name = value,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(labelText: 'Doses Per Day'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => dosesPerDay = int.tryParse(value) ?? 1,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => quantity = int.tryParse(value) ?? 0,
                ),
                const SizedBox(height: 16),
                ...timings.asMap().entries.map((entry) {
                  final index = entry.key;
                  final timing = entry.value;
                  return ListTile(
                    title: Text('Dose ${index + 1} Time'),
                    trailing: Text(timing.format()),
                    onTap: () async {
                      final TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: timing.hour, minute: timing.minute),
                      );
                      if (newTime != null) {
                        setState(() {
                          timings[index] = Timing(hour: newTime.hour, minute: newTime.minute);
                        });
                      }
                    },
                  );
                }).toList(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      timings.add(Timing(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute));
                    });
                  },
                  child: const Text('Add Another Time'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (name.isNotEmpty && quantity > 0) {
                  try {
                    final medicine = Medicine(
                      name: name,
                      timings: timings,
                      dosesPerDay: dosesPerDay,
                      quantity: quantity,
                      remainingDoses: quantity,
                    );
                    await _medicineService.addMedicine(medicine);
                    _loadMedicines();
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding medicine: $e')),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Tracking'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _medicines.isEmpty
          ? const Center(child: Text('No medicines added yet'))
          : ListView.builder(
              itemCount: _medicines.length,
              itemBuilder: (context, index) {
                final medicine = _medicines[index];
                final daysRemaining = (medicine.remainingDoses / medicine.dosesPerDay).floor();

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(medicine.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Doses per day: ${medicine.dosesPerDay}'),
                        Text('Remaining: ${medicine.remainingDoses} doses ($daysRemaining days)'),
                        if (daysRemaining <= 2)
                          const Text(
                            'Low stock! Please refill soon',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () async {
                            try {
                              if (medicine.id != null) {
                                await _medicineService.takeDose(medicine.id!);
                                _loadMedicines();
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error taking dose: $e')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              if (medicine.id != null) {
                                await _medicineService.deleteMedicine(medicine.id!);
                                _loadMedicines();
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error deleting medicine: $e')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMedicine,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
