import 'package:flutter/material.dart';
import '../main.dart';
import '../models/model.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: contactNumberController,
              decoration: const InputDecoration(labelText: 'Contact Number'),
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 3,
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
                _saveMember();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveMember() {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String contactNumber = contactNumberController.text;
    String email = emailController.text;
    String address = addressController.text;

    if (selectedMembershipType != null) {
      Member newMember = Member(
        firstName: firstName,
        lastName: lastName,
        contactNumber: contactNumber,
        email: email,
        address: address,
        dateOfBirth: DateTime.now(),
        nfcTagID: 'sampleNfcTagID', // Sample NFC ID, replace with actual logic
        membershipStartDate: DateTime.now(),
        membershipEndDate: DateTime.now(),
      );

      // Set the membership type through the relation
      newMember.membershipType.target = selectedMembershipType;

      // Save the member using your ObjectBox logic
      objectbox.addMember(newMember);
    }
  }
}
