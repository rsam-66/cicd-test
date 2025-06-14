// settings_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class SettingsPage extends StatelessWidget{
  bool notif = false;
  bool appNotif = false;

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          _buildSectionTitle('Account'),
          _buildItem('Edit Profile'),
          _buildItem('Change Password'),

          _buildSectionTitle('Notifications'),
          _buildSwitchItem('Notifications', notif),
          _buildSwitchItem('App Notifications', appNotif),

          _buildSectionTitle('Others'),
          _buildItem('Language'),
          _buildItem('Help'),

          ListTile(
            title: Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () {
              logout(context);
            }, 
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildItem(String title) {
    return ListTile(title: Text(title), onTap: () {});
  }

  Widget _buildSwitchItem(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (bool val) {},
    );
  }
}
