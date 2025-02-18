import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../widgets/profile_photo_editor.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

   File? _selectedImage;
  bool _isUploadingImage = false;

  // Add this method to handle image upload
  Future<void> _handleImageUpload(File imageFile) async {
    setState(() => _isUploadingImage = true);
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final result = await authService.uploadProfilePhoto(imageFile);
      
      if (result == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile photo: $result')),
        );
      }
    } finally {
      setState(() => _isUploadingImage = false);
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String? selectedGender;
  String? selectedBloodType;
  List<EmergencyContact> emergencyContacts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user != null) {
      setState(() {
        nameController.text = user.name;
        phoneController.text = user.phone;
        ageController.text = user.age?.toString() ?? '';
        weightController.text = user.weight?.toString() ?? '';
        selectedGender = user.gender;
        selectedBloodType = user.bloodType;
        emergencyContacts = List.from(user.emergencyContacts);
      });
    }
  }

  void _addEmergencyContact(BuildContext contextForSnackBar) {
    final scaffoldMessenger = ScaffoldMessenger.of(contextForSnackBar);
    TextEditingController numberController = TextEditingController();
    TextEditingController relationController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
              keyboardType: TextInputType.phone,
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (numberController.text.isNotEmpty && relationController.text.isNotEmpty) {
                Navigator.pop(dialogContext);
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Adding contact...'))
                );

                final authService = Provider.of<AuthService>(context, listen: false);
                final result = await authService.addEmergencyContact(
                  relationController.text,
                  numberController.text,
                );

                if (result == "success") {
                  await authService.refreshUserData();
                  setState(() {
                    emergencyContacts = List.from(authService.currentUser?.emergencyContacts ?? []);
                  });
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Contact added successfully'))
                  );
                } else {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error: $result'))
                  );
                }
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final currentUser = Provider.of<AuthService>(context, listen: false).currentUser;
        if (currentUser != null) {
          final updatedUser = User(
            id: currentUser.id,
            name: nameController.text,
            email: currentUser.email,
            phone: phoneController.text,
            token: currentUser.token,
            gender: selectedGender,
            age: int.tryParse(ageController.text),
            bloodType: selectedBloodType,
            weight: double.tryParse(weightController.text),
            emergencyContacts: emergencyContacts,
          );

          final result = await Provider.of<AuthService>(context, listen: false)
              .updateProfile(updatedUser);

          if (result == "success") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $result')),
            );
          }
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading || _isUploadingImage
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                       // Add the ProfilePhotoEditor at the top of your form
                      Center(
                        child: ProfilePhotoEditor(
                          currentPhotoUrl: Provider.of<AuthService>(context)
                              .currentUser
                              ?.profilePhoto,
                          onPhotoSelected: (File file) {
                            setState(() => _selectedImage = file);
                            _handleImageUpload(file);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Phone number is required' : null,
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: InputDecoration(
                          labelText: "Gender",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: ['male', 'female', 'other']
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender[0].toUpperCase() +
                                      gender.substring(1)),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedGender = value),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: ageController,
                        decoration: InputDecoration(
                          labelText: "Age",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: selectedBloodType,
                        decoration: InputDecoration(
                          labelText: "Blood Type",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedBloodType = value),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: weightController,
                        decoration: InputDecoration(
                          labelText: "Weight (kg)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Emergency Contacts",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _addEmergencyContact(context),
                            icon: const Icon(Icons.add),
                            label: const Text("Add"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (emergencyContacts.isNotEmpty) ...[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: emergencyContacts.length,
                          itemBuilder: (context, index) {
                            final contact = emergencyContacts[index];
                            return Card(
                              child: ListTile(
                                title: Text(contact.relation),
                                subtitle: Text(contact.number),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final authService = Provider.of<AuthService>(
                                        context,
                                        listen: false);
                                    final result = await authService
                                        .deleteEmergencyContact(contact.id);
                                    if (result == "success") {
                                      await authService.refreshUserData();
                                      setState(() {
                                        emergencyContacts = List.from(
                                            authService.currentUser?.emergencyContacts ?? []);
                                      });
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Save Changes",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    weightController.dispose();
    super.dispose();
  }
}