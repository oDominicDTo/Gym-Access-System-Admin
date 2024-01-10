import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/screens/renew/membership_renew_duration.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/model.dart';
import '../../widgets/custom_card_button.dart';

class PreviewMemberPage extends StatelessWidget {
  final Member member;
  final String adminName;
  const PreviewMemberPage({Key? key, required this.member, required this.adminName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 16), // Left side spacing
              Expanded(
                flex: 1,
                child: _buildProfileHeader(context),
              ),
              const SizedBox(width: 16), // Spacing between the photo and the box
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNameRow(member),
                        _buildMembershipStatusWidget(member),
                        _buildInfoRow(
                          icon: Icons.event,
                          label: 'Start Date:',
                          value: member.membershipStartDateFormat,
                          color: Colors.blue,
                        ),
                        _buildInfoRow(
                          icon: Icons.event,
                          label: 'End Date:',
                          value: member.membershipEndDateFormat,
                          color: Colors.red,
                        ),
                        _buildInfoRow(
                          icon: Icons.timelapse,
                          label: 'Duration:',
                          value: _getRemainingMembershipDuration(member),
                          color: Colors.green,
                        ),
                        const SizedBox(height: 20.0),
                        Center(
                          child: SizedBox(
                            width: 150,
                            child: CustomCardButton(
                              icon: Icons.navigate_next,
                              title: 'Proceed',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MembershipDurationPage(selectedMember: member, adminName: adminName),
                                  ),
                                );
                              },
                              iconColor: Colors.orangeAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16), // Right side spacing
            ],
          ),
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
          return Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                width: double.infinity, // Make the width flexible
                height: 400,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildNameRow(Member member) {
    return _buildInfoRow(
      icon: Icons.person,
      label: 'Name:',
      value: '${member.firstName} ${member.lastName}',
      color: Colors.black,
      fontSize: 25,
      spacing: 3.0,
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    double fontSize = 25,
    double spacing = 3.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacing),
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            '$label $value',
            style: TextStyle(fontFamily: 'Poppins', fontSize: fontSize),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return SizedBox(
      width: 300,
      height: 400,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey[200],
        ),
        child: const Center(
          child: Icon(
            Icons.person,
            size: 300,
            color: Colors.lightBlueAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildMembershipStatusWidget(Member member) {
    String statusText = '';
    Color statusColor = Colors.black;
    IconData statusIcon = Icons.error; // Change to the appropriate icon

    switch (member.getMembershipStatus()) {
      case MembershipStatus.active:
        statusText = 'Active';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case MembershipStatus.inactive:
        statusText = 'Inactive';
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case MembershipStatus.expired:
        statusText = 'Expired';
        statusColor = Colors.black;
        statusIcon = Icons.warning;
        break;
    }

    return Row(
      children: [
        Icon(
          statusIcon,
          size: 25,
          color: statusColor,
        ),
        const SizedBox(width: 8),
        Text(
          'Membership Status: $statusText',
          style: TextStyle(fontFamily: 'Poppins', color: statusColor, fontSize: 25),
        ),
      ],
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
    return localPath.replaceAll(r'\', '/');
  }
}
