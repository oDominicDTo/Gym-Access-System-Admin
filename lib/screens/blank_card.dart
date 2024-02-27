import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:gym_kiosk_admin/main.dart';
import 'package:gym_kiosk_admin/models/model.dart';

import '../../services/nfc_service.dart';

class InsertBlankCard extends StatefulWidget {
  final Member newMember;
  final MembershipType? selectedMembershipType;
  final String adminName;
  final double totalPrice;
  const InsertBlankCard(
      {Key? key,
        required this.newMember,
        this.selectedMembershipType,
        required this.adminName,
        required this.totalPrice})
      : super(key: key);

  @override
  State<InsertBlankCard> createState() => _InsertBlankCardState();
}

class _InsertBlankCardState extends State<InsertBlankCard> {
  late NFCService _nfcService;
  late StreamSubscription<String> _nfcSubscription;

  @override
  void initState() {
    super.initState();
    _nfcService = NFCService();
    _startNFCListener();
  }

  void _startNFCListener() {
    _nfcSubscription = _nfcService.onNFCEvent.listen((String tagId) {
      if (tagId != 'Error') {
        _checkAndSaveTagId(tagId);
      }
    });
  }

  void _checkAndSaveTagId(String tagId) async {
    final bool exists = await objectbox.checkTagIDExists(tagId);

    if (!exists) {
      widget.newMember.nfcTagID = tagId;
      widget.newMember.membershipType.target = widget.selectedMembershipType;

      final newMemberLog = NewMemberLog(
        memberName: '${widget.newMember.firstName} ${widget.newMember.lastName}',
        adminName: widget.adminName,
        membershipType: widget.selectedMembershipType?.typeName ?? '',
        amount: widget.totalPrice,
        creationDate: DateTime.now(), // Add a timestamp for the log
      );

      objectbox.addMember(widget.newMember);
      objectbox.addNewMemberLog(newMemberLog); // Log the addition of the new member

      _showSuccessDialog();
    } else {
      _showExistingTagDialog();
    }
  }

  void _showExistingTagDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tag Exists'),
          content: const Text('This NFC tag is already in use.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('NFC Tag Assigned'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green[100],
                ),
                child: Icon(Icons.check, size: 48, color: Colors.black),
              ),
              SizedBox(height: 16),
              Text('NFC tag assigned successfully.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Pop twice to go back to the first screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nfcSubscription.cancel();
    _nfcService.disposeNFCListener(); // Adjusted the method name
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Card'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Place Blank Card on NFC Scanner',
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                  speed: const Duration(milliseconds: 50),
                ),
              ],
              totalRepeatCount: 1,
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/animation/insert_card.json',
              width: 500,
              height: 500,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
