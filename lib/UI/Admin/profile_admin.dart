import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfile extends StatefulWidget {
  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  bool isEditing = false;

  // Initial profile data
  String _name = "Jon-Jon";
  String _fname = "Jon-Jon";
  String _lname = "Roscain";
  String _email = "jonjon@example.com";
  String _address = "123 Main Street, Cityville";
  String _contactNumber = "123-456-7890";

  // Controllers for editable fields
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for editable fields
    _fnameController.text = _fname;
    _lnameController.text = _lname;
    _emailController.text = _email;
    _addressController.text = _address;
    _contactNumberController.text = _contactNumber;
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveChanges() {
    // Save the changes made to the profile
    setState(() {
      _fname = _fnameController.text;
      _lname = _lnameController.text;
      _email = _emailController.text;
      _address = _addressController.text;
      _contactNumber = _contactNumberController.text;
      isEditing = false;
    });
  }

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  SizedBox(height: 55.0),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
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

                  SizedBox(height: 15.0),
                  Text(
                    '$_name',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                  ),

                  SizedBox(height: 30.0),
                  // Inside the Visibility widget for non-editable fields
                  Visibility(
                    visible: !isEditing,
                    child: Column(
                      children: [
                        SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildCustomTextField(
                              controller: _fnameController,
                              labelText: 'First Name',
                              icon: Icons.person_rounded,
                            ),
                            SizedBox(width: 10),
                            buildCustomTextField(
                              controller: _lnameController,
                              labelText: 'Last Name',
                              icon: Icons.person_rounded,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildCustomTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              icon: Icons.email,
                            ),
                            SizedBox(width: 10),
                            buildCustomTextField(
                              controller: _contactNumberController,
                              labelText: 'Contact Number',
                              icon: Icons.phone,
                            ),
                          ],

                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildCustomTextField(
                              controller: _addressController,
                              labelText: 'Address',
                              icon: Icons.location_on,
                            ),
                          ],

                        ),
                      ],
                    ),
                  ),

                  // Editable fields
                  Visibility(
                    visible: isEditing,
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            buildCustomTextField(
                              controller: _fnameController,
                              labelText: 'First Name',
                              icon: Icons.person_rounded,
                            ),
                            SizedBox(height: 10),
                            buildCustomTextField(
                              controller: _lnameController,
                              labelText: 'Last Name',
                              icon: Icons.person_rounded,
                            ),
                            SizedBox(height: 10),
                            buildCustomTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              icon: Icons.email,
                            ),
                            SizedBox(height: 10),
                            buildCustomTextField(
                              controller: _contactNumberController,
                              labelText: 'Contact Number',
                              icon: Icons.phone,
                            ),
                            SizedBox(height: 10),
                            buildCustomTextField(
                              controller: _addressController,
                              labelText: 'Address',
                              icon: Icons.location_on,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isEditing)
                        ElevatedButton.icon(
                          onPressed: _toggleEdit,
                          icon: Icon(Icons.edit),
                          label: Text('Edit'),
                        ),
                      if (isEditing)
                        ElevatedButton.icon(
                          onPressed: _saveChanges,
                          icon: Icon(Icons.save),
                          label: Text('Save'),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildPlaceholderRow({required String title, required String content, required bool isEditing}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align both title and content to the upper-left corner
          children: [
            Container(
              margin: EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: Alignment.topLeft, // Align title to the top-left corner
                child: Text(
                  title, // Placeholder title
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 400,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // Set border color
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              margin: EdgeInsets.all(16.0),
              child: Text(
                content, // Placeholder content
                style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }









  Widget buildCustomTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return Container(
      width: 400,
      height: 50,
      child: TextFormField(
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          icon: Icon(icon),
          hintText: labelText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: TextStyle(fontFamily: 'Poppins'),
          hintStyle: TextStyle(fontFamily: 'Poppins'),
        ),
        onSaved: (value) {},
        validator: (value) {
          return null;
        },
      ),
    );
  }
}
