import 'package:flutter/material.dart';

class PasswordSecurityScreen extends StatelessWidget {
  const PasswordSecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Password & Security")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSecurityOption("Change Email"),
            _buildSecurityOption("Change Password"),
            _buildSecurityOption("Change Phone Number"),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityOption(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
        child: Text(text),
      ),
    );
  }
}