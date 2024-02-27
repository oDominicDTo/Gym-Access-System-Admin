import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';

class AddMembershipTypeDialog extends StatefulWidget {
  final Function(MembershipType) onAdd;

  const AddMembershipTypeDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  State createState() => _AddMembershipTypeDialogState();
}

class _AddMembershipTypeDialogState extends State<AddMembershipTypeDialog> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the form
  late String typeName = '';
  late double fee = 0.0;
  late double discount = 0.0;
  late bool isLifetime = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Membership Type', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      typeName = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Type Name is required';
                    }
                    if (value == '0') {
                      return 'Type Name cannot be 0';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 16.0), // Adjust font size
                  decoration: const InputDecoration(
                    labelText: 'Type Name',
                    labelStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 14.0, fontWeight: FontWeight.bold), // Bold label
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      fee = double.tryParse(value) ?? 0.0;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fee is required';
                    }
                    if (value == '0') {
                      return 'Fee cannot be 0';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 16.0), // Adjust font size
                  decoration: const InputDecoration(
                    labelText: 'Fee',
                    labelStyle: TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 14.0, fontWeight: FontWeight.bold), // Bold label
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newType = MembershipType(
                typeName: typeName,
                fee: fee,
                discount: discount,
                isLifetime: isLifetime,
              );
              widget.onAdd(newType); // Send the new type back
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Set background color to black
          ),
          child: const Text('Add', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        ),
      ],
    );
  }
}
