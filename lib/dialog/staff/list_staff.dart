import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import '../../main.dart';
import 'edit_staff.dart';
import 'add_staff.dart';

class ListStaffDialog extends StatefulWidget {
  const ListStaffDialog({Key? key}) : super(key: key);

  @override
  State createState() => _ListStaffDialogState();
}

class _ListStaffDialogState extends State<ListStaffDialog> {
  late List<Administrator> staffList = []; // Declare staffList here

  @override
  void initState() {
    super.initState();
    _fetchStaff();
  }

  Future<void> _fetchStaff() async {
    // Accessing the globally available objectbox instance
    staffList = objectbox.getStaffAdministrators();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Staff List')),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      content: SizedBox(
        width: 500, // Expand horizontally
        height: 400.0, // Adjust the height as needed
        child: ListView.builder(
          itemCount: staffList.length,
          itemBuilder: (context, index) {
            final staff = staffList[index];
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EditStaffDialog(
                      staff: staff,
                    );
                  },
                ).then((_) => _fetchStaff()); // Refresh staff list after editing
              },
              child: Card(
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    staff.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddStaffDialog();
              },
            ).then((_) => _fetchStaff()); // Refresh staff list after adding a new staff member
          },
          label: const Text('Add'),
          foregroundColor: Colors.black,
          shape: const StadiumBorder(),
          icon: const Icon(Icons.add, color: Colors.black),
          elevation: 5,
          highlightElevation: 5,
        ),
      ],
    );
  }
}
