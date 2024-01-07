import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/dialog/membership_duration/specific_member_content.dart';
import '../../screens/management_page.dart';
import 'all_members_content.dart';

class InitialMembershipDialog extends StatefulWidget {
  @override
  State createState() => _InitialMembershipDialogState();
}

class _InitialMembershipDialogState extends State<InitialMembershipDialog> {
  bool showAllMembersContent = false;
  bool showSpecificMemberContent = false;
  int daysToAddOrSubtract = 0;
  List<String> selectedMembers = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: buildDialogContent(),
    );
  }

  Widget buildDialogContent() {
    if (showAllMembersContent) {
      return AllMembersContent(
        onBack: () {
          setState(() {
            showAllMembersContent = false;
          });
        },
        onDaysChanged: (int days) {
          setState(() {
            daysToAddOrSubtract = days;
          });
        },
        initialContext: context,
      );
    } else if (showSpecificMemberContent) {
      return MemberSelectionDialog(
        onBack: () {
          setState(() {
            showSpecificMemberContent = false;
          });
        },
        onMembersSelected: (List<String> members) {
          setState(() {
            selectedMembers = members;
          });
        },
        onDaysChanged: (int days) {
          setState(() {
            daysToAddOrSubtract = days;
          });
        },
        initialContext: context,
      );
    } else {
      return buildInitialContent();
    }
  }


  Widget buildInitialContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCardButton(
          title: 'Manage Membership Duration',
          onPressed: () {
            // Handle action for managing membership duration
          },
          iconColor: Colors.black,
          icon: Icons.filter_none,
        ),
        const SizedBox(height: 50.0),
        CustomCardButton(
          title: 'All Members',
          onPressed: () {
            setState(() {
              showAllMembersContent = true; // Switch to show content for all members
            });
          },
          iconColor: Colors.green,
          icon: Icons.group,
        ),
        const SizedBox(height: 16.0),
        CustomCardButton(
          title: 'Specific Member',
          onPressed: () {
            setState(() {
              showSpecificMemberContent = true; // Switch to show content for specific member
            });
          },
          iconColor: Colors.blue,
          icon: Icons.person,
        ),
      ],
    );
  }
}