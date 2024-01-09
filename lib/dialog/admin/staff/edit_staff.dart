import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:lottie/lottie.dart';

import '../../../main.dart';
import '../../../services/nfc_service.dart';

class EditStaffDialog extends StatefulWidget {
  final Administrator staff;
  const EditStaffDialog({Key? key, required this.staff}) : super(key: key);

  @override
  State createState() => _EditStaffDialogState();
}

class _EditStaffDialogState extends State<EditStaffDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late NFCService _nfcService;
  late Administrator editedStaff;
  bool nfcChanged = false;

  @override
  void initState() {
    super.initState();
    _nfcService = NFCService();
    editedStaff = widget.staff;
  }

  @override
  void dispose() {
    _nfcService.disposeNFCListener();
    super.dispose();
  }

  void _startNFCListener() {
    _nfcService.onNFCEvent.listen((String tagId) async {
      if (tagId != 'Error') {
        await _checkExistingTag(tagId);
      }
    });
  }
  Future<void> _checkExistingTag(String tagId) async {
    final exists = await objectbox.checkTagIDExists(tagId);
    if (exists) {
      _showExistingTagDialog();
    } else {
      setState(() {
        editedStaff.nfcTagID = tagId;
        nfcChanged = true;
      });
      _showNFCScanSuccessDialog();
    }
  }

  void _updateStaffData(String name, String username, String password) {
    editedStaff.name = name;
    editedStaff.username = username;
    editedStaff.password = password;
    nfcChanged = true; // Set the flag indicating changes in the staff data
  }

  void _showNFCDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Place Blank Card on NFC Scanner'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animation/insert_card.json',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      objectbox.updateAdministrator(editedStaff);
      _showNFCSuccessDialog();
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
          content: Text('Staff member updated successfully.'),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close the success dialog
      Navigator.of(context).pop(); // Close the Edit Staff dialog
    });
  }

  void _showNFCScanSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Success'),
          content: Text('Card scanned successfully.'),
        );
      },
    ).then((value) {
      setState(() {
        // Update the NFC change status to true after successful scan
        nfcChanged = true;
      });
    });

    // Update the UI button label after successful NFC scan
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close the success dialog
      Navigator.of(context).pop(); // Close the Edit Staff dialog
    });
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this staff member?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Perform deletion logic here
               objectbox.deleteAdministrator(editedStaff.id);
                Navigator.of(context).pop(); // Close the confirmation dialog
                Navigator.of(context).pop(); // Close the Edit Staff dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Edit Staff')),
      content: SizedBox(
        width: 500, // Adjust width as needed
        height: 400.0, // Adjust height as needed
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: editedStaff.name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _updateStaffData(value, editedStaff.username, editedStaff.password);
                },
              ),
              TextFormField(
                initialValue: editedStaff.username,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
                onChanged: (value) {
                  _updateStaffData(editedStaff.name, value, editedStaff.password);
                },
              ),
              TextFormField(
                initialValue: editedStaff.password,
                obscureText: false,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onChanged: (value) {
                  _updateStaffData(editedStaff.name, editedStaff.username, value);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: nfcChanged ? null : () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _showNFCDialog();
                    _startNFCListener();
                  }
                },
                child: nfcChanged ? const Text('NFC Card Changed!') : const Text('Change NFC Card'),
              ),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showDeleteConfirmationDialog();
                },
                child: const Text('Delete Staff'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}