import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';

import '../main.dart';
import 'add_membership_type_dialog.dart';
import 'edit_membership_type_dialog.dart';

class ListMembershipTypeDialog extends StatefulWidget {
  const ListMembershipTypeDialog({Key? key}) : super(key: key);

  @override
  State createState() => _ListMembershipTypeDialogState();
}

class _ListMembershipTypeDialogState extends State<ListMembershipTypeDialog> {
  late List<MembershipType> membershipTypes =
      []; // Declare membershipTypes here

  @override
  void initState() {
    super.initState();
    _fetchMembershipTypes();
  }

  Future<void> _fetchMembershipTypes() async {
    // Accessing the globally available objectbox instance
    membershipTypes = await objectbox.getAllMembershipTypes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Membership Types', style: TextStyle(color: Colors.black, fontFamily: 'Poppins'))),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      content: SizedBox(
        width: 500, // Expand horizontally
        height: 400.0, // Adjust the height as needed
        child: ListView.builder(
          itemCount: membershipTypes.length,
          itemBuilder: (context, index) {
            final type = membershipTypes[index];
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EditMembershipTypeDetailsDialog(
                      type: type,
                      onUpdate: (MembershipType updatedType) {
                        // Update the existing type in the list
                        setState(() {
                          int index = membershipTypes.indexWhere(
                              (element) => element.id == updatedType.id);
                          if (index != -1) {
                            membershipTypes[index] = updatedType;
                          }
                        });
                        // Perform the update in ObjectBox or any storage mechanism
                        objectbox.updateMembershipType(updatedType);
                      },
                      onRemove: (int typeId) {
                        setState(() {
                          membershipTypes
                              .removeWhere((element) => element.id == typeId);
                        });
                        // Perform the removal in ObjectBox or any storage mechanism
                        objectbox.deleteMembershipType(typeId);
                      },
                    );
                  },
                );
              },
              child: Card(
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          type.typeName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Fee:',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            type.fee.toString(),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'PHP',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                return AddMembershipTypeDialog(onAdd: (MembershipType newType) {
                  // Add the new type to the list and update
                  setState(() {
                    membershipTypes.add(newType);
                  });
                  objectbox.addMembershipType(newType); // Add to ObjectBox
                });
              },
            );
          },
          label: const Text('Add', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
          backgroundColor: Colors.black,
          shape: const StadiumBorder(),
          icon: const Icon(Icons.add, color: Colors.white),
          elevation: 5,
          highlightElevation: 5,
        ),
      ],
    );
  }
}
