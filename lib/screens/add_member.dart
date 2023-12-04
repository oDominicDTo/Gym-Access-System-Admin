import 'package:flutter/material.dart';
import '../objectbox.dart'; // Ensure correct import path
import '../models/model.dart';
import 'package:intl/intl.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
   createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nfcTagIDController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  DateTime? _selectedDate;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _dateOfBirthController.text = DateFormat('dd.MM.yy').format(_selectedDate!);
      });
    });
  }

  void _saveMember() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final contactNumber = _contactNumberController.text;
      final email = _emailController.text;
      final nfcTagID = _nfcTagIDController.text;
      final dateOfBirth = _selectedDate ?? DateTime.now(); // If no date selected, use current date

      final store = await ObjectBox.create();
      await store.addMember(
        firstName as Member,
        lastName,
        contactNumber as int,
        email,
        nfcTagID,
        dateOfBirth,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Member added successfully!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactNumberController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nfcTagIDController,
                decoration: const InputDecoration(labelText: 'NFC Tag ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter NFC Tag ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _dateOfBirthController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                onTap: _presentDatePicker,
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMember,
                child: const Text('Save Member'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}