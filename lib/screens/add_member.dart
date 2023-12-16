import 'package:flutter/material.dart';
import '../main.dart';
import '../models/model.dart';
import 'camera_page.dart';

enum AddressSelection { binan, other }

class MemberInput extends StatefulWidget {
  const MemberInput({Key? key}) : super(key: key);

  @override
  State<MemberInput> createState() => _MemberInputState();
}

class _MemberInputState extends State<MemberInput> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController contactNumberController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late MembershipType? selectedMembershipType;
  List<MembershipType> membershipTypes = [];
  final _formKey = GlobalKey<FormState>();

  AddressSelection? selectedAddress;
  String selectedBinanBarangay = 'Select Barangay';
  String otherCity = '';
  String otherBarangay = '';

  List<String> binanBarangays = [
    'Select Barangay',
    'Biñan (Poblacion)',
    'Bungahan',
    'Santo Tomas (Calabuso)',
    'Canlalay',
    'Casile',
    'De La Paz',
    'Ganado',
    'San Francisco (Halang)',
    'Langkiwa',
    'Loma',
    'Malaban',
    'Malamig',
    'Mampalasan',
    'Platero',
    'Poblacion',
    'Santo Niño',
    'San Antonio',
    'San Jose',
    'San Vicente',
    'Soro-soro',
    'Santo Domingo',
    'Timbao',
    'Tubigan',
    'Zapote',
  ];

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    contactNumberController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    _fetchMembershipTypes(); // Fetch membership types when the widget initializes
    selectedMembershipType = null;
  }

  Future<void> _fetchMembershipTypes() async {
    membershipTypes = await objectbox.getAllMembershipTypes();
    if (membershipTypes.isNotEmpty) {
      setState(() {
        selectedMembershipType = membershipTypes.first;
      });
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Member')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: contactNumberController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid contact number';
                  }
                  // Validate the Philippine contact number pattern
                  // This pattern allows a 7 to 13 digit phone number starting with 09 or +63
                  if (!RegExp(r'^(\+63|0)9[0-9]{9}$').hasMatch(value)) {
                    return 'Please enter a valid Philippine contact number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid email';
                  }
                  // Validate email using a simple pattern
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              // Address selection
              DropdownButtonFormField<AddressSelection>(
                value: selectedAddress,
                items: const [
                  DropdownMenuItem(
                    value: AddressSelection.binan,
                    child: Text('Biñan'),
                  ),
                  DropdownMenuItem(
                    value: AddressSelection.other,
                    child: Text('Other/Specify'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedAddress = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
              if (selectedAddress == AddressSelection.binan)
                // Dropdown for Biñan barangays
                DropdownButtonFormField<String>(
                  value: selectedBinanBarangay,
                  items: binanBarangays.map((barangay) {
                    return DropdownMenuItem<String>(
                      value: barangay,
                      child: Text(barangay),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedBinanBarangay = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == 'Select Barangay') {
                      return 'Please select a barangay';
                    }
                    return null;
                  },
                ),
              if (selectedAddress == AddressSelection.other)
                Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'City'),
                      onChanged: (value) {
                        setState(() {
                          otherCity = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a city';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Barangay'),
                      onChanged: (value) {
                        setState(() {
                          otherBarangay = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a barangay';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              DropdownButton<MembershipType>(
                hint: const Text('Select Membership Type'),
                value: selectedMembershipType,
                onChanged: (MembershipType? newValue) {
                  setState(() {
                    selectedMembershipType = newValue!;
                  });
                },
                items: membershipTypes.map((MembershipType type) {
                  return DropdownMenuItem<MembershipType>(
                    value: type,
                    child: Text(type.typeName), // Customize the display here
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // _saveMember();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const Dialog(
                        child: CameraPage(),
                      );
                    },
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveMember() {
    if (_formKey.currentState!.validate()) {
      String firstName = firstNameController.text;
      String lastName = lastNameController.text;
      String contactNumber = contactNumberController.text;
      String email = emailController.text;

      if (selectedMembershipType != null) {
        Member newMember = Member(
          firstName: firstName,
          lastName: lastName,
          contactNumber: contactNumber,
          email: email,
          address: selectedAddress == AddressSelection.other
              ? '$otherCity, $otherBarangay'
              : 'Biñan, $selectedBinanBarangay',
          dateOfBirth: DateTime.now(),
          nfcTagID: 'sampleNfcTagID',
          // Sample NFC ID, replace with actual logic
          membershipStartDate: DateTime.now(),
          membershipEndDate: DateTime.now(),
          photoPath: '',
        );

        // Set the membership type through the relation
        newMember.membershipType.target = selectedMembershipType;

        // Save the member using your ObjectBox logic
        objectbox.addMember(newMember);
      }
    }
  }
}
