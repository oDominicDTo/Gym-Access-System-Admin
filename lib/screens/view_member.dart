import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/main.dart';
import '../models/model.dart';



class MemberListScreen extends StatelessWidget {
  const MemberListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member List'),
      ),
      body: StreamBuilder<List<Member>>(
        stream: objectbox.getAllMembersAsync().asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No members available'));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Contact Number')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Membership Type')),
                  DataColumn(label: Text('Membership Status')),
                  DataColumn(label: Text('Start Date')),
                  DataColumn(label: Text('Remaining Days'))
                ],
                rows: snapshot.data!.map((member) {
                  return DataRow(cells: [
                    DataCell(Text(member.firstName)),
                    DataCell(Text(member.lastName)),
                    DataCell(Text(member.contactNumber)),
                    DataCell(Text(member.email)),
                    DataCell(Text(member.membershipType.target!.typeName)),
                    DataCell(Text(_getMembershipStatus(member))),
                    DataCell(Text(member.membershipStartDateFormat)),
                    DataCell(Text(_getRemainingMembershipDays(member)))
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
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
    }
  }
  String _getRemainingMembershipDays(Member member){
    final membershipDays = member.getRemainingMembershipDays();
    return membershipDays.toString();
  }
}
