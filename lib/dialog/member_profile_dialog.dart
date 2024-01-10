import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/dialog/edit_member_dialog.dart';
import '../models/model.dart'; // Import your Member model here
import 'package:path_provider/path_provider.dart';

class MemberProfileDialog {
  void open(BuildContext context, Member member,
      Function(int memberId) deleteMemberAndRefresh) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildProfileDialog(context, member, deleteMemberAndRefresh);
      },
    );
  }

  Widget _buildProfileDialog(BuildContext context, Member member,
      Function(int memberId) deleteMemberAndRefresh) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.7,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.blue, // Use your desired color
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 20,
                      child: FutureBuilder<String>(
                        future: _getLocalImagePath(member.photoPath),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError ||
                              snapshot.data == null) {
                            return const Icon(Icons.person,
                                size: 120, color: Colors.white);
                          } else {
                            final file = File(snapshot.data!);
                            if (!file.existsSync()) {
                              return const Icon(Icons.person,
                                  size: 120, color: Colors.white);
                            }
                            return CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(file),
                            );
                          }
                        },
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 16,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditMemberDialog(member: member);
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'), // Empty text for no label
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showDeleteConfirmationDialog(
                              context, member, deleteMemberAndRefresh);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'), // Empty text for no label
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${member.firstName} ${member.lastName}',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    const SizedBox(height: 8),
                    Text(member.email,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold)),
                    Text(member.contactNumber,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold)),
                    Text(' ${member.dateOfBirthFormat}',
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold)),
                    Text(member.address,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    const Divider(
                      height: 3,
                      thickness: 2,
                      indent: 40,
                      endIndent: 40,
                      color: Colors.black26,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMembershipStatusWidget(member),
                        Text(
                          'Membership Start Date: ${member.membershipStartDateFormat}',
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        Text(
                          'Membership End Date: ${member.membershipEndDateFormat}',
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        Text(
                          'Membership Duration: ${_getRemainingMembershipDuration(member)}',
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Add other member details as needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembershipStatusWidget(Member member) {
    String statusText = '';
    Color statusColor = Colors.black; // Default color for expired

    switch (member.getMembershipStatus()) {
      case MembershipStatus.active:
        statusText = 'Active';
        statusColor = Colors.green;
        break;
      case MembershipStatus.inactive:
        statusText = 'Inactive';
        statusColor = Colors.red;
        break;
      case MembershipStatus.expired:
        statusText = 'Expired';
        statusColor = Colors.black;
        break;
    }

    return Text(
      'Membership Status: $statusText',
      style: TextStyle(fontFamily: 'Poppins', color: statusColor),
    );
  }

  String _getRemainingMembershipDuration(Member member) {
    final membershipDays = member.getRemainingMembershipDays();

    if (membershipDays >= 365) {
      final years = membershipDays ~/ 365;
      final remainingDays = membershipDays % 365;
      if (remainingDays > 30) {
        return '$years year${years > 1 ? 's' : ''}';
      } else {
        return '$years year${years > 1 ? 's' : ''} and $remainingDays day${remainingDays > 1 ? 's' : ''}';
      }
    } else if (membershipDays > 30) {
      final months = membershipDays ~/ 30;
      final remainingDays = membershipDays % 30;
      return '$months month${months > 1 ? 's' : ''} and $remainingDays day${remainingDays > 1 ? 's' : ''}';
    } else {
      return '$membershipDays day${membershipDays > 1 ? 's' : ''}';
    }
  }

  Future<String> _getLocalImagePath(String imagePath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String localPath = '${appDocDir.path}/Kiosk/Photos/$imagePath';
    return localPath.replaceAll(r'\', '/'); // Ensure correct separators
  }

  void _showDeleteConfirmationDialog(BuildContext context, Member member,
      Function(int memberId) deleteMemberAndRefresh) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete ${member.firstName} ${member.lastName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteMemberAndRefresh(
                    member.id); // Delete member and refresh data
                Navigator.of(context).pop(); // Close confirmation dialog
                Navigator.of(context).pop(); // Close profile dialog as well
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
