import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/nfc_service.dart';
import 'package:gym_kiosk_admin/screens/home_admin.dart';

class LoginScreenNfc extends StatefulWidget {
  const LoginScreenNfc({Key? key}) : super(key: key);

  @override
  State createState() => _LoginScreenNfcState();
}

class _LoginScreenNfcState extends State<LoginScreenNfc> {
  final nfcService = NFCService();
  late StreamSubscription<String> _nfcSubscription;

  @override
  void initState() {
    super.initState();
    startNFCListener();
  }

  void startNFCListener() {
    _nfcSubscription = nfcService.onNFCEvent.listen((cardSerialNumber) {
      if (cardSerialNumber != 'Error') {
        // Define your card UIDs
        const validUIDs = ['D3BCF3EC', 'b385aafd', 'c3ff9310'];

        if (validUIDs.contains(cardSerialNumber)) {
          // Delay navigation for 500 milliseconds
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeAdminPage()),
            );
          });
        } else {
          // If the card's UID is not valid, display an error message or take appropriate action
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Invalid card detected.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _nfcSubscription.cancel();
    nfcService.disposeNFCListener();
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
