import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/home.dart';
import 'package:gym_kiosk_admin/screens/login_nfc.dart';
import 'package:window_size/window_size.dart';
import 'screens/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('My App');
    setWindowMaxSize(const Size(1920, 1080));
    setWindowMinSize(const Size(1920, 1080));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Kiosk Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      //home: const LoginScreenNfc(), // Your login screen as the initial route
        home: HomeAdmin()
    );
  }
}
