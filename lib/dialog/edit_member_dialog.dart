import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:lottie/lottie.dart';
import '../../main.dart';
import '../../services/nfc_service.dart';

class EditMemberDialog extends StatefulWidget {
  final Member member;
  const EditMemberDialog({Key? key, required this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends State<EditMemberDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late NFCService _nfcService;
  late Member editedMember;
  bool nfcChanged = false;

  @override
  void initState() {
    super.initState();
    _nfcService = NFCService();
    editedMember = widget.member;
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
        editedMember.nfcTagID = tagId;
        nfcChanged = true;
      });
      _showNFCScanSuccessDialog();
    }
  }

  void _updateMemberData(String firstName, String lastName, String email,
      String contactNumber, String address) {
    editedMember.firstName = firstName;
    editedMember.lastName = lastName;
    editedMember.email = email;
    editedMember.contactNumber = contactNumber;
    editedMember.address = address;
    nfcChanged = true; // Set the flag indicating changes in the member data
  }

  void _submitForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      // Perform action after form validation
      objectbox.updateMember(editedMember);
      _showNFCScanSuccessDialog();
    }
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

  void _showNFCScanSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Success'),
          content: Text('Member details updated successfully.'),
        );
      },
    ).then((value) {
      // Update UI or perform actions after dialog is closed
      // For example, navigate back to previous screen
      Navigator.of(context).pop(); // Close the Edit Member dialog
    });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Edit Member')),
      content: SizedBox(
        width: 500, // Adjust width as needed
        height: 600.0, // Adjust height as needed
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: editedMember.firstName,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a first name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _updateMemberData(value, editedMember.lastName, editedMember.email, editedMember.contactNumber, editedMember.address);
                  },
                ),
                TextFormField(
                  initialValue: editedMember.lastName,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a last name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _updateMemberData(editedMember.firstName, value, editedMember.email, editedMember.contactNumber, editedMember.address);
                  },
                ),
                TextFormField(
                  initialValue: editedMember.email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _updateMemberData(editedMember.firstName, editedMember.lastName, value, editedMember.contactNumber, editedMember.address);
                  },
                ),
                TextFormField(
                  initialValue: editedMember.contactNumber,
                  decoration: const InputDecoration(labelText: 'Contact Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a contact number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _updateMemberData(editedMember.firstName, editedMember.lastName, editedMember.email, value, editedMember.address);
                  },
                ),
                TextFormField(
                  initialValue: editedMember.address,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _updateMemberData(editedMember.firstName, editedMember.lastName, editedMember.email, editedMember.contactNumber, value);
                  },
                ),

                Column(
                  children: [
                    TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: editedMember.dateOfBirthFormat,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: editedMember.dateOfBirth,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            editedMember.dateOfBirth = pickedDate;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date of birth';
                        }
                        // Additional validation logic can be added here
                        return null; // Return null if the date is valid
                      },
                    ),

                  ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog without saving
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}