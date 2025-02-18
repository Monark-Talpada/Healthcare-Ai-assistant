import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'edit_profile_screen.dart';
import 'password_security_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.refreshUserData();
    setState(() {
      _isLoading = false;
    });
  }

  void _handleLogout(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              authService.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.blueAccent,
            elevation: 2,
            title: const Text("Profile", style: TextStyle(color: Colors.white)),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue.shade200,
                        child: Text(
                          user?.name.substring(0, 1).toUpperCase() ?? 'U',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user?.name ?? 'User',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        children: [
                          if (user?.age != null)
                            Chip(label: Text('${user?.age} years old')),
                          if (user?.gender != null)
                            Chip(label: Text(user?.gender ?? '')),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (user?.bloodType != null)
                        _buildInfoRow("Blood Type", user?.bloodType ?? ''),
                      if (user?.weight != null)
                        _buildInfoRow("Weight", "${user?.weight} kg"),
                      const SizedBox(height: 20),
                      _buildButton("Edit Profile", Icons.edit, Colors.blueAccent, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        );
                      }),
                      _buildButton("Password & Security", Icons.lock, Colors.orange, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PasswordSecurityScreen()),
                        );
                      }),
                      const SizedBox(height: 20),
                      if (user?.emergencyContacts.isNotEmpty ?? false) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Emergency Contacts",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: user!.emergencyContacts.map((contact) {
                            return Chip(label: Text('${contact.number} (${contact.relation})'));
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 30),
                      _buildButton("Logout", Icons.exit_to_app, Colors.red, () => _handleLogout(context)),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 16, color: Color.fromRGBO(97, 97, 97, 1))),
        ],
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}