import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:lottie/lottie.dart';
import '../../../main.dart';
import '../../../services/nfc_service.dart';

class AddStaffDialog extends StatefulWidget {
  const AddStaffDialog({Key? key}) : super(key: key);

  @override
  State createState() => _AddStaffDialogState();
}

class _AddStaffDialogState extends State<AddStaffDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late NFCService _nfcService;
  Administrator newStaff = Administrator(name: '', username: '', password: '', nfcTagID: '', type: 'staff');

  @override
  void initState() {
    super.initState();
    _nfcService = NFCService();
  }

  @override
  void dispose() {
    _nfcService.disposeNFCListener();
    super.dispose();
  }

  void _startNFCListener() {
    _nfcService.onNFCEvent.listen((String tagId) {
      if (tagId != 'Error') {
        setState(() {
          newStaff.nfcTagID = tagId;
        });
        _submitForm();
      }
    });
  }

  void _showNFCDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Place Blank Card on NFC Scanner'),
          content: SizedBox(
            width: 200, // Adjust width as needed
            height: 150, // Adjust height as needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animation/insert_card.json',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitForm() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      final exists = await objectbox.checkTagIDExists(newStaff.nfcTagID);
      if (!exists) {
        objectbox.addAdministrator(newStaff);
        _showNFCSuccessDialog();
      } else {
        _showExistingTagDialog();
      }
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

  void _showNFCSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Success'),
          content: Text('Staff member created successfully.'),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Add Staff')),
      content: SizedBox(
        width: 200, // Adjust width as needed
        height: 250.0, // Adjust height as needed
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    newStaff.name = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    newStaff.username = value;
                  });
                },
              ),
              TextFormField(
                obscureText: false,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    newStaff.password = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _showNFCDialog();
                    _startNFCListener();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
