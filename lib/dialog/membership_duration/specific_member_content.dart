import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/dialog/membership_duration/selected_members_content.dart';
import 'package:gym_kiosk_admin/main.dart';

import '../../models/model.dart';

class MemberSelectionDialog extends StatefulWidget {
  final ValueChanged<List<String>> onMembersSelected;
  final VoidCallback onBack;
  final BuildContext initialContext; // Add the initialContext property
  final ValueChanged<int> onDaysChanged;

  const MemberSelectionDialog({
    Key? key,
    required this.onMembersSelected,
    required this.onBack,
    required this.initialContext,
    required this.onDaysChanged, // Include it in the constructor
  }) : super(key: key);

  @override
  State createState() => _MemberSelectionDialogState();
}

class _MemberSelectionDialogState extends State<MemberSelectionDialog> {
  List<Member> allMembers = []; // Fetch members from ObjectBox
  List<int> selectedMemberIds = []; // Hold selected members' IDs
  List<String> selectedMembers = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // Fetch members from ObjectBox when the widget initializes
    fetchMembers();
    _searchController = TextEditingController();
  }

  void fetchMembers() async {
    // Fetch all members from ObjectBox
    List<Member> members = objectbox.getAllMembers();

    // Sort members alphabetically by first name before updating the state
    members.sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

    setState(() {
      allMembers = members;
    });
  }

  List<Member> getFilteredMembers(String searchText) {
    return allMembers
        .where((member) =>
    member.firstName.toLowerCase().contains(searchText.toLowerCase()) ||
        member.lastName.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }
  void navigateToAdjustMembershipDuration() {
    List<int> selectedMemberIds = []; // Initialize an empty list to store member IDs

    // Iterate through allMembers and add selected member IDs to the list
    for (final member in allMembers) {
      if (selectedMembers.contains('${member.firstName} ${member.lastName}')) {
        selectedMemberIds.add(member.id);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: AdjustSelectedMembershipDuration(
            selectedMemberIds: selectedMemberIds, // If 'selectedMemberIds' are integers
            initialContext: widget.initialContext,
            onDaysChanged: widget.onDaysChanged,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = getFilteredMembers(_searchController.text);
    return AlertDialog(
      title: const Text('Select Members'),
      content: SizedBox(
        width: 700,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search Members',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredMembers.length,
                        itemBuilder: (context, index) {
                          final member = filteredMembers[index];
                          final isSelected = selectedMemberIds.contains(member.id);

                          return ListTile(
                            title: Text('${member.firstName} ${member.lastName}'),
                            trailing: isSelected
                                ? const Icon(Icons.check_box, color: Colors.blue)
                                : const Icon(Icons.check_box_outline_blank),
                            onTap: () {
                              setState(() {
                                final memberId = member.id;
                                if (selectedMemberIds.contains(memberId)) {
                                  selectedMemberIds.remove(memberId);
                                  selectedMembers.remove('${member.firstName} ${member.lastName}');
                                } else {
                                  selectedMemberIds.add(memberId);
                                  selectedMembers.add('${member.firstName} ${member.lastName}');
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Selected Members',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedMembers.length,
                        itemBuilder: (context, index) {
                          final selectedMember = selectedMembers[index];
                          return ListTile(
                            title: Text(selectedMember),
                            // Add any actions related to selected members here if needed
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (selectedMembers.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('No Members Selected'),
                    content: const Text('Please select members first.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              navigateToAdjustMembershipDuration();
            }
          },
          child: const Text('Adjust Membership Duration'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Just go back without selecting
          },
          child: const Text('Back'),
        ),
      ],
    );
  }
}