import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false;
  bool isAccountActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('Account'),
            children: [
              ListTile(
                title: Text('Change Password'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Handle Change Password
                },
              ),
              ListTile(
                title: Text('Content Settings'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Handle Content Settings
                },
              ),
              ListTile(
                title: Text('Social'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Handle Social
                },
              ),
              ListTile(
                title: Text('Language'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Handle Language
                },
              ),
              ListTile(
                title: Text('Privacy and Security'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Handle Privacy and Security
                },
              ),
            ],
          ),
          SwitchListTile(
            title: Text('Notifications'),
            value: isDarkTheme, // Corrected from isEnable to isDarkTheme
            onChanged: (value) {
              setState(() {
                isDarkTheme = value;
              });
            },
          ),

          SwitchListTile(
            title: Text('Account Active'),
            value: isAccountActive,
            onChanged: (value) {
              setState(() {
                isAccountActive = value;
              });
            },
          ),
          ListTile(
            title: Text('Opportunity'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Handle Opportunity
            },
          ),
          ListTile(
            title: Text(
              'SIGN OUT',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Handle Sign Out
            },
          ),
        ],
      ),
    );
  }
}
