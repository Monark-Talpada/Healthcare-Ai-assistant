import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

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
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  
  List<Map<String, String>> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user != null) {
      nameController.text = user.name;
      phoneController.text = user.phone;
      ageController.text = user.age?.toString() ?? '';
      genderController.text = user.gender ?? '';
      bloodTypeController.text = user.bloodType ?? '';
      weightController.text = user.weight?.toString() ?? '';
      // Convert emergency contacts to List<Map<String, String>>
      emergencyContacts = user.emergencyContacts.map((contact) => {
        "number": contact.number,
        "relation": contact.relation,
      }).toList();
    }
  }

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
                    emergencyContacts.add({
                      "number": numberController.text,
                      "relation": relationController.text
                    });
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

  Future<void> _saveChanges() async {
  setState(() {
    isLoading = true;
  });

  final authService = Provider.of<AuthService>(context, listen: false);
  
  try {
    // Validate input data
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      throw Exception("Name and phone number are required");
    }

    // Validate age format if provided
    if (ageController.text.isNotEmpty) {
      final age = int.tryParse(ageController.text);
      if (age == null || age < 0 || age > 150) {
        throw Exception("Invalid age value");
      }
    }

    // Validate weight format if provided
    if (weightController.text.isNotEmpty) {
      final weight = double.tryParse(weightController.text);
      if (weight == null || weight < 0 || weight > 500) {
        throw Exception("Invalid weight value");
      }
    }

    final result = await authService.updateProfile(
      name: nameController.text,
      phone: phoneController.text,
      gender: genderController.text.isNotEmpty ? genderController.text : null,
      age: ageController.text.isNotEmpty ? int.tryParse(ageController.text) : null,
      bloodType: bloodTypeController.text.isNotEmpty ? bloodTypeController.text : null,
      weight: weightController.text.isNotEmpty ? double.tryParse(weightController.text) : null,
      emergencyContacts: emergencyContacts.isNotEmpty ? emergencyContacts : null,
    );

    if (result == "success") {
      if (mounted) {
        // Refresh user data after successful update
        await authService.refreshUserData();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $result'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  } catch (e) {
    if (mounted) {
      print('Error in _saveChanges: $e'); // Add debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  // Rest of the code remains the same...

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
              _buildTextField(phoneController, "Phone"),
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
                onPressed: isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save Changes", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}