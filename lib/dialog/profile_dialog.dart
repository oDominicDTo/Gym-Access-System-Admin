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
              FutureBuilder<String>(
                future: _getLocalImagePath(member.photoPath),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return const Icon(Icons.person, size: 120); // Placeholder icon if image not found
                  } else {
                    final file = File(snapshot.data!);
                    if (!file.existsSync()) {
                      return const Icon(Icons.person, size: 120); // Placeholder icon if image file doesn't exist
                    }
                    return Image.file(
                      file,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Text('Name: ${member.firstName} ${member.lastName}'),
              Text('Email: ${member.email}'),
              Text('Contact Number: ${member.contactNumber}'),
              Text('Date of Birth: ${member.dateOfBirthFormat}'),
              Text('Membership Start Date: ${member.membershipStartDateFormat}'),
              Text('Membership End Date: ${member.membershipEndDateFormat}'),
              Text('Address: ${member.address}'),
              Text('Remaining Membership Duration: ${_getRemainingMembershipDuration(member)}'),
              Text('Membership Status: ${_getMembershipStatus(member)}'),
              // Add other member details as needed
            ],
          ),
        ),
      ),
    );
  }
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