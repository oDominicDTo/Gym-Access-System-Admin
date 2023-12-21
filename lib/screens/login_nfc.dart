import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:lottie/lottie.dart';

import '../../services/nfc_service.dart';
import '../main.dart';

class LoginScreenNfc extends StatefulWidget {
  const LoginScreenNfc({Key? key}) : super(key: key);

  @override
  State createState() => _LoginScreenNfcState();
}

class _LoginScreenNfcState extends State<LoginScreenNfc> {
  final nfcService = NFCService();
  late StreamSubscription<String> _nfcSubscription;
  bool _isScanning = true; // Add this variable to track scanning state

  @override
  void initState() {
    super.initState();
    startNFCListener();
  }

  void startNFCListener() {
    _nfcSubscription = nfcService.onNFCEvent.listen((cardSerialNumber) {
      if (_isScanning && cardSerialNumber != 'Error') {
        _handleNFCEvent(cardSerialNumber);
      }
    });
  }

  Future<void> _handleNFCEvent(String cardSerialNumber) async {
    if (!mounted) return; // Check if the widget is disposed

    bool tagExists = await objectbox.checkTagIdExists(cardSerialNumber);

    if (!mounted) return; // Check if the widget is disposed after async operation

    if (tagExists) {
      Administrator? admin = await objectbox.getAdministratorByTagId(cardSerialNumber);

      if (!mounted) return; // Check if the widget is disposed after async operation

      if (admin != null) {
        String adminType = admin.type.toLowerCase();

        if (adminType == 'superadmin') {
          _handleNavigation('/homeSuperAdmin');
        } else if (adminType == 'admin') {
          _handleNavigation('/homeAdmin');
        } else if (adminType == 'staff') {
          _handleNavigation('/homeStaff');
        } else {
          _showErrorDialog('Unknown admin type.');
        }
      } else {
        _showErrorDialog('Admin data not found.');
      }
    } else {
      _showErrorDialog('Invalid card detected.');
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return; // Check if the widget is disposed

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handleNavigation(String route) {
    if (!mounted) return; // Check if the widget is disposed

    setState(() {
      _isScanning = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, route);
    });
  }

  @override
  void dispose() {
    _nfcSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.black, // Replace with your image or design
              child: Center(
                child: Container(
                  width: 800,
                  height: 500,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'WELCOME TO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Image.asset(
                        'assets/images/binan_logo.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const Center(
                        child: Text(
                          'Biñan Gym & Fitness Center',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 443,
                        height: 95,
                        child: Center(
                          child: Text(
                            ' Get ready to transform your \nbody, mind, and spirit.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Container(
                  width: 600,
                  height: 600,
                  color: Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'SCAN CARD',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          child: Lottie.asset(
                            'assets/animation/scan_nfc.json',
                            width: 500,
                            height: 500,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}