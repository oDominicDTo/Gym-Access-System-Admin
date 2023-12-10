import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/add_member.dart';
import 'package:gym_kiosk_admin/objectbox.dart';
import 'package:gym_kiosk_admin/objectbox.g.dart';
import 'package:gym_kiosk_admin/screens/home_admin.dart';
import 'package:gym_kiosk_admin/screens/login_nfc.dart';
import 'package:window_size/window_size.dart';

late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Gym Kiosk Admin');
    setWindowMaxSize(const Size(1920, 1080));
    setWindowMinSize(const Size(1920, 1080));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gym Kiosk Admin',
      debugShowCheckedModeBanner: false,
      home: LoginScreenNfc(),
    );
  }
}
