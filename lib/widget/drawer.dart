import 'package:flutter/material.dart';

myappDrawer(BuildContext context)=> Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Text(
          'Menu',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        leading: Icon(Icons.home, color: Colors.grey[800]),
        title: const Text('Home'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.history, color: Colors.grey[800]),
        title: const Text('Transaction History'),
        onTap: () {
          // Navigate to transaction history
        },
      ),
      ListTile(
        leading: Icon(Icons.settings, color: Colors.grey[800]),
        title: const Text('Settings'),
        onTap: () {
          // Navigate to settings
        },
      ),
      ListTile(
        leading: Icon(Icons.help, color: Colors.grey[800]),
        title: const Text('Help & Support'),
        onTap: () {
          // Navigate to help and support
        },
      ),
      ListTile(
        leading: Icon(Icons.logout, color: Colors.grey[800]),
        title: const Text('Logout'),
        onTap: () {
          // Handle logout
        },
      ),
    ],
  ),
);