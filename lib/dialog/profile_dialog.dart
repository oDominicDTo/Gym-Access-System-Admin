import 'dart:io';

import 'package:flutter/material.dart';
import '../models/model.dart'; // Import your Member model here
import 'package:path_provider/path_provider.dart';

class ProfileDialog {
  void open(BuildContext context, Member member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildProfileDialog(context, member);
      },
    );
  }

  Widget _buildProfileDialog(BuildContext context, Member member) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: FractionallySizedBox(
        widthFactor: 0.8,
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue, // Use your desired color
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 20,
                      child: FutureBuilder<String>(
                        future: _getLocalImagePath(member.photoPath),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError || snapshot.data == null) {
                            return Icon(Icons.person, size: 120, color: Colors.white);
                          } else {
                            final file = File(snapshot.data!);
                            if (!file.existsSync()) {
                              return Icon(Icons.person, size: 120, color: Colors.white);
                            }
                            return CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(file),
                            );
                          }
                        },
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
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const SizedBox(height: 8),
                    Text('${member.email}', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                    Text('${member.contactNumber}', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                    Text(' ${member.dateOfBirthFormat}', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                    Text('${member.address}', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
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
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        Text(
                          'Membership End Date: ${member.membershipEndDateFormat}',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        Text(
                          'Membership Duration: ${_getRemainingMembershipDuration(member)}',
                          style: TextStyle(fontFamily: 'Poppins'),
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
        return '$years year${years > 1
            ? 's'
            : ''} and $remainingDays day${remainingDays > 1 ? 's' : ''}';
      }
    } else if (membershipDays > 30) {
      final months = membershipDays ~/ 30;
      final remainingDays = membershipDays % 30;
      return '$months month${months > 1
          ? 's'
          : ''} and $remainingDays day${remainingDays > 1 ? 's' : ''}';
    } else {
      return '$membershipDays day${membershipDays > 1 ? 's' : ''}';
    }
  }

  String _getMembershipStatus(Member member) {
    final membershipStatus = member.getMembershipStatus();

    switch (membershipStatus) {
      case MembershipStatus.active:
        return 'Active';
      case MembershipStatus.inactive:
        return 'Inactive';
      case MembershipStatus.expired:
        return 'Expired';
      default:
        return '';
    }
  }

  Future<String> _getLocalImagePath(String imagePath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String localPath = '${appDocDir.path}/Kiosk/Photos/$imagePath';
    return localPath.replaceAll(r'\', '/'); // Ensure correct separators
  }
}