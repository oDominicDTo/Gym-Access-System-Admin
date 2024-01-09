import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/objectbox.dart';
import 'package:gym_kiosk_admin/screens/login_nfc.dart';
import 'package:gym_kiosk_admin/widgets/admin_name_provider.dart';
import 'package:window_size/window_size.dart';
import 'package:gym_kiosk_admin/screens/admin/home_admin.dart';
import 'package:gym_kiosk_admin/screens/staff/home_staff.dart';
import 'package:gym_kiosk_admin/screens/superadmin/home_super_admin.dart';


late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Gym Kiosk Admin');
    setWindowMaxSize(const Size(1366, 768));
    setWindowMinSize(const Size(1366, 768));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  AdminNameProvider(
      adminName: '',
      child: MaterialApp(
        title: 'Gym Kiosk Admin',
        debugShowCheckedModeBanner: false,
        initialRoute: '/', // Set the initial route
        routes: {
          '/': (context) => const LoginScreenNfc(), // Define the initial route
          '/homeSuperAdmin': (context) => const HomeSuperAdminPage(adminName: '',),
          '/homeAdmin': (context) => const HomeAdminPage(adminName: '',),
          '/homeStaff': (context) => const HomeStaffPage(adminName: '',),
          // Add more routes if needed
        },
      ),
    );
  }
}
