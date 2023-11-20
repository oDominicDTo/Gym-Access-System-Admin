import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/add_member.dart';
import 'package:gym_kiosk_admin/screens/home.dart';
import 'package:gym_kiosk_admin/screens/login_nfc.dart';
import 'package:window_size/window_size.dart';
import 'objectbox.dart';
import 'screens/login.dart';

/// Provides access to the ObjectBox Store throughout the app.
late ObjectBox objectbox;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('My App');
    setWindowMaxSize(const Size(1920, 1080));
    setWindowMinSize(const Size(1920, 1080));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gym Kiosk Admin',
      debugShowCheckedModeBanner: false,
      home: AddMember(), // Your login screen as the initial route
    );
  }
}
