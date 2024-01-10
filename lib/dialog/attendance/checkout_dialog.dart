import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';
import '../../objectbox.g.dart';

class CheckOutDialog extends StatefulWidget {
  final ValueChanged<List<String>> onMembersSelected;
  final VoidCallback? onCheckInConfirmed;
  const CheckOutDialog({super.key, required this.onMembersSelected, required this.onCheckInConfirmed});

  @override
  State createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<CheckOutDialog> {
  List<Member> allMembers = []; // Fetch members from ObjectBox
  Member? selectedMember;
  late TextEditingController _searchController;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    fetchMembers();
    _searchController = TextEditingController();
  }

  void fetchMembers() async {
    List<Member> members = objectbox.getAllMembers();
    members.sort((a, b) =>
        a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

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

  Future<String> updateLocalImagePath(Member member) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String localPath = '${appDocDir.path}/Kiosk/Photos/${member.photoPath}';
    return localPath.replaceAll(r'\', '/');
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = getFilteredMembers(_searchController.text);
    MembershipStatus? status = selectedMember?.getMembershipStatus();
    String statusText;
    Color statusColor;
    double statusSize = 20;

    switch (status) {
      case MembershipStatus.active:
        statusText = 'Active';
        statusColor = Colors.green;
        break;
      case MembershipStatus.expired:
        statusText = 'Expired';
        statusColor = Colors.red;
        break;
      case MembershipStatus.inactive:
        statusText = 'Inactive';
        statusColor = Colors.red;
        break;
      default:
        statusText = 'Unknown';
        statusColor = Colors.grey;
    }
    return AlertDialog(
      title: const Text(
        'Select Members',
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 900,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search Members',
                        labelStyle: TextStyle(
                            color: Colors.black, fontFamily: 'Poppins'),
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
                          final isSelected = selectedMember?.id == member.id;

                          return ListTile(
                            title: Text(
                              '${member.firstName} ${member.lastName}',
                              style: const TextStyle(
                                  color: Colors.black, fontFamily: 'Poppins'),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_box,
                                color: Colors.blue)
                                : const Icon(Icons.check_box_outline_blank),
                            onTap: () {
                              setState(() {
                                selectedMember = isSelected ? null : member;
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
            if (selectedMember != null)

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Displaying the selected member's image or fallback avatar
                      FutureBuilder<String>(
                        future: updateLocalImagePath(selectedMember!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting ||
                              snapshot.data == null) {
                            return const CircularProgressIndicator();
                          } else {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(snapshot.data!),
                                width: 400,
                                height: 400,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return const SizedBox(
                                    child: Icon(Icons.person,size: 300,),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Name: ${selectedMember!.firstName} ${selectedMember!.lastName}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Membership Type: ${selectedMember!.membershipType.target?.typeName ?? 'Unknown'}',
                        style: const TextStyle(
                            color: Colors.black, fontFamily: 'Poppins'),
                      ),
                      Text(
                        'Membership Status: $statusText',
                        style: TextStyle(fontSize: statusSize, color: statusColor),
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
          onPressed: () async {
            if (_isButtonDisabled) {
              return;
            }
            _isButtonDisabled = true;
            if (selectedMember != null && !selectedMember!.checkedIn){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Member Already Checked Out',
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    content: const Text(
                      'Please check out the member before checking in again.',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _isButtonDisabled = false;
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
              return;
            }
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Check-Out'),
                  content: Text('Check out ${selectedMember!.firstName} ${selectedMember!.lastName}?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        final checkOutTime = DateTime.now();

                        try {
                          objectbox.store.runInTransaction(TxMode.write, ()  {
                            objectbox.logCheckOut(selectedMember!.id, checkOutTime: checkOutTime);
                          });
                          Navigator.of(context).pop(); // Close confirmation dialog
                          Navigator.of(context).pop(); // Close dialog below the confirmation dialog
                          _isButtonDisabled = false; // Reset the flag
                          widget.onCheckInConfirmed?.call(); // Notify about check-in confirmation
                        } catch (e) {
                          print("Error occurred: $e");
                          // Handle the error or inform the user about the failure
                        }
                      },
                      child: const Text('Confirm'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close confirmation dialog
                        _isButtonDisabled = false; // Reset the flag
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: const SizedBox(
            width: 50,
            height: 20,
            child: Center(
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}