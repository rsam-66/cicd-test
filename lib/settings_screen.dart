import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'main.dart';
// import 'main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Account Section
          const Text("Account", style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          ListTile(
            title: const Text("Edit Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Change Password"),
            onTap: () {
              // Navigate to change password screen
            },
          ),
          const SizedBox(height: 24),

          // Notifications Section
          const Text("Notifications",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          SwitchListTile(
            title: const Text("Notifications"),
            value: true,
            onChanged: (value) {
              // Handle notification toggle
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("App Notifications"),
            value: false,
            onChanged: (value) {
              // Handle app notifications toggle
            },
          ),
          const SizedBox(height: 24),

          // Others Section
          const Text("Others", style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          ListTile(
            title: const Text("Language"),
            onTap: () {
              // Navigate to language settings
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Help"),
            onTap: () {
              // Navigate to help screen
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Log Out", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
