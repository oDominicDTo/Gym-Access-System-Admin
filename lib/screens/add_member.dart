import 'package:flutter/material.dart';

import '../objectbox.dart';


class AddMember extends StatefulWidget {
  const AddMember({Key? key}) : super(key: key);

  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  late final TextEditingController _nameController;
  late final TextEditingController _membershipController;
  late ObjectBox _objectBox;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _membershipController = TextEditingController();
    _objectBox = ObjectBox();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _membershipController.dispose();
    super.dispose();
  }

  Future<void> _addMember() async {
    final name = _nameController.text;
    final membership = _membershipController.text;

    if (name.isNotEmpty && membership.isNotEmpty) {
      _objectBox.addMember(name, membership);
      Navigator.pop(context); // Navigate back to the previous screen
    } else {
      debugPrint('Please fill in all fields');
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _membershipController,
              decoration: InputDecoration(
                labelText: 'Membership Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _addMember,
              child: const Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }
}
