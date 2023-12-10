import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dialog.dart';

class AddMember extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final String labelText;
  final Function(String?) onSaved;
  final String? Function(String?)? validator;

  const AddMember({
    required this.icon,
    required this.hintText,
    required this.labelText,
    required this.onSaved,
    this.validator,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 50,
      child: TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          icon: Icon(icon),
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: TextStyle(fontFamily: 'Poppins'),
          hintStyle: TextStyle(fontFamily: 'Poppins'),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}

class AddNewMemberForm extends StatefulWidget {
  @override
  _AddNewMemberFormState createState() => _AddNewMemberFormState();
}

class _AddNewMemberFormState extends State<AddNewMemberForm> {
  final List<String> membershipOptions = ['Athlete', 'Standard', 'Employee'];
  String selectedMembership = 'Athlete';

  XFile? selectedImage;
  // Function to handle image selection
  Future<void> _selectImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        File file = File(result.files.single.path!);
        setState(() {
          selectedImage = XFile(file.path);
        });
      }
    } catch (e) {
      // Handle any exceptions if needed
      print('Error selecting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Title
        SizedBox(height: 80.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Add New Member',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        // Form in a Row
        // Edit Profile Title
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _selectImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: selectedImage != null ? FileImage(selectedImage! as File) : null,
                child: selectedImage == null
                    ? Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Colors.grey[600],
                )
                    : null,
              ),
            ),
          ],
        ),

        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AddMember(
              icon: Icons.person,
              hintText: 'Enter First Name',
              labelText: 'First Name',
              onSaved: (String? value) {
                // Implement your logic here.
              },
              validator: (String? value) {
                return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
              },
            ),
            SizedBox(width: 10),
            AddMember(
              icon: Icons.person,
              hintText: 'Enter Last Name',
              labelText: 'Last Name',
              onSaved: (String? value) {
                // Implement your logic here.
              },
              validator: (String? value) {
                return (value != null && !value.contains('@')) ? 'Enter a valid email.' : null;
              },
            ),
          ],
        ),
        // Additional Row
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AddMember(
              icon: Icons.email,
              hintText: 'Enter Email Address',
              labelText: 'Email',
              onSaved: (String? value) {
                // Implement your logic here.
              },
              validator: (String? value) {
                return (value != null && !value.contains('@')) ? 'Enter a valid phone number.' : null;
              },
            ),
            SizedBox(width: 10),
            AddMember(
              icon: Icons.phone,
              hintText: 'Enter Contact Number',
              labelText: 'Contact Number',
              onSaved: (String? value) {
                // Implement your logic here.
              },
              validator: (String? value) {
                return (value != null && !value.contains('@')) ? 'Enter a valid address.' : null;
              },
            ),
          ],
        ),

        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 50,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: selectedMembership,
                  onChanged: (String? value) {
                    setState(() {
                      selectedMembership = value!;
                    });
                  },
                  items: membershipOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),

        // Save and Close Buttons
        SizedBox(height: 60.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                ConfirmationDialog confirmationDialog = ConfirmationDialog(context);
                confirmationDialog.showConfirmationDialog();

                // Save logic here
              },
              child: Text(
                'Save',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                // Close logic here
              },
              child: Text(
                'Close',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.black),

              ),
            ),
          ],
        ),
      ],
    );
  }
}

