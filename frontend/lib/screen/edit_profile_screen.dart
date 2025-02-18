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
              _buildTextField(numberController, "Phone Number"),
              const SizedBox(height: 10),
              _buildTextField(relationController, "Relation"),
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
    setState(() { isLoading = true; });
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      if (nameController.text.isEmpty || phoneController.text.isEmpty) {
        throw Exception("Name and phone number are required");
      }

      final result = await authService.updateProfile(
        name: nameController.text,
        phone: phoneController.text,
        gender: genderController.text,
        age: int.tryParse(ageController.text),
        bloodType: bloodTypeController.text,
        weight: double.tryParse(weightController.text),
        emergencyContacts: emergencyContacts,
      );

      if (result == "success") {
        if (mounted) {
          await authService.refreshUserData();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        _showError(result);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() { isLoading = false; });
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $message'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[200],
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
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              const Text("Emergency Contacts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              ElevatedButton.icon(
                onPressed: _addEmergencyContact,
                icon: const Icon(Icons.add),
                label: const Text("Add Contact"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
