import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/renew/membership_renew_duration.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/model.dart';
import '../../widgets/custom_card_button.dart';

class PreviewMemberPage extends StatelessWidget {
  final Member member;

  const PreviewMemberPage({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 100),
            Expanded(
              flex: 1,
              child: _buildProfileHeader(context),
            ),
            const SizedBox(width: 100),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50.0),
                    _buildMembershipStatusWidget(member),
                    const SizedBox(height: 16.0),
                    Text(
                      'Name: ${member.firstName} ${member.lastName}',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 24),
                    ),

                    Text(
                      'Start Date: ${member.membershipStartDateFormat}',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 24),
                    ),
                    Text(
                      'End Date: ${member.membershipEndDateFormat}',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 24),
                    ),
                    Text(
                      'Duration: ${_getRemainingMembershipDuration(member)}',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 24),
                    ),
                    const SizedBox(height: 50.0),
                    SizedBox(
                      width: 200,
                      child: CustomCardButton(
                        title: 'Proceed',
                        icon: Icons.navigate_next,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MembershipDurationPage(selectedMember: member),
                            ),
                          );
                        },
                        iconColor: Colors.orangeAccent, // Set icon color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return FutureBuilder<String>(
      future: _getLocalImagePath(member.photoPath),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return _buildAvatarPlaceholder();
        } else {
          final file = File(snapshot.data!);
          if (!file.existsSync()) {
            return _buildAvatarPlaceholder();
          }
          return SizedBox(
            width: 300,
            height: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                file,
                fit: BoxFit.cover,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAvatarPlaceholder() {
    return SizedBox(
      width: 300,
      height: 400,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey[200], // Placeholder background color
        ),
        child: const Center(
          child: Icon(
            Icons.person,
            size: 300,
            color: Colors.lightBlueAccent, // Change color to black to ensure visibility
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
      style: TextStyle(fontFamily: 'Poppins', color: statusColor, fontSize: 30),
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
}
