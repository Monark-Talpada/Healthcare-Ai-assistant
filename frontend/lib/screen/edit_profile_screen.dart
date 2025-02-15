import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  
  List<Map<String, String>> emergencyContacts = [];

  void _addEmergencyContact() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController numberController = TextEditingController();
        TextEditingController relationController = TextEditingController();

        return AlertDialog(
          title: const Text("Add Emergency Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: relationController,
                decoration: const InputDecoration(
                  labelText: "Relation",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (numberController.text.isNotEmpty && relationController.text.isNotEmpty) {
                  setState(() {
                    emergencyContacts.add({"relation": relationController.text, "number": numberController.text});
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(nameController, "Name"),
              _buildTextField(ageController, "Age"),
              _buildTextField(genderController, "Gender"),
              _buildTextField(bloodTypeController, "Blood Type"),
              _buildTextField(weightController, "Weight"),
              
              const SizedBox(height: 20),

              const Text(
                "Emergency Contacts",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                children: emergencyContacts.map((contact) {
                  return Chip(
                    label: Text('${contact["number"]} - ${contact["relation"]}'),
                    backgroundColor: Colors.lightBlue[50],
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: _addEmergencyContact,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Contact"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Save Changes", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }
}