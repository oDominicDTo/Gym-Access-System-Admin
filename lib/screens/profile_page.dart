import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        // Other app bar configurations as needed
      ),
      body: const Center(
        child: Text('This is the Profile Page!'), // Your profile content
      ),
    );
  }
}
