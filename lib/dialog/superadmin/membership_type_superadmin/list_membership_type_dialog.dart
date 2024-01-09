import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import '../../../main.dart';
import 'add_membership_type_dialog.dart';
import 'edit_membership_type_dialog.dart';

class ListMembershipTypeDialog extends StatefulWidget {
  const ListMembershipTypeDialog({Key? key}) : super(key: key);

  @override
  State createState() => _ListMembershipTypeDialogState();
}

class _ListMembershipTypeDialogState extends State<ListMembershipTypeDialog> {
  late List<MembershipType> membershipTypes = [];
  int hoveredIndex = -1; // Track the index of the hovered card

  @override
  void initState() {
    super.initState();
    _fetchMembershipTypes();
  }

  Future<void> _fetchMembershipTypes() async {
    membershipTypes = await objectbox.getAllMembershipTypes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Membership Types',
          style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      content: SizedBox(
        width: 300, // Expand horizontally
        height: 300.0, // Adjust the height as needed
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
                        setState(() {
                          int index = membershipTypes
                              .indexWhere((element) => element.id == updatedType.id);
                          if (index != -1) {
                            membershipTypes[index] = updatedType;
                          }
                        });
                        objectbox.updateMembershipType(updatedType);
                      },
                      onRemove: (int typeId) {
                        setState(() {
                          membershipTypes.removeWhere((element) => element.id == typeId);
                        });
                        objectbox.deleteMembershipType(typeId);
                      },
                    );
                  },
                );
              },
              onHover: (isHovered) {
                // Update the hovered index when the card is hovered or not hovered
                setState(() {
                  hoveredIndex = isHovered ? index : -1;
                });
              },
              child: Card(
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: hoveredIndex == index ? Colors.blue.withOpacity(0.5) : Colors.white,
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
                              color: Colors.orange,
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
                  setState(() {
                    membershipTypes.add(newType);
                  });
                  objectbox.addMembershipType(newType);
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
