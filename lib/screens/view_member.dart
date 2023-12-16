import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/main.dart';
import '../models/model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MemberListScreen extends StatelessWidget {
  const MemberListScreen({Key? key}) : super(key: key);

  Future<String> _getLocalImagePath(String imagePath) async {

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String localPath = '${appDocDir.path}/Kiosk/Photos/$imagePath';
      return localPath.replaceAll(r'\', '/'); // Ensure correct separators
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member List'),
        automaticallyImplyLeading: false,
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
              child: Container(

                child: DataTable(
                 dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('First Name')),
                    DataColumn(label: Text('Last Name')),
                    DataColumn(label: Text('Contact Number')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Membership Type')),
                    DataColumn(label: Text('Membership Status')),
                    DataColumn(label: Text('Start Date')),
                    DataColumn(label: Text('Remaining Days')),
                    DataColumn(label: Text('Address')),
                  ],
                  rows: snapshot.data!.map((member) {
                    return DataRow(cells: [
                      DataCell(
                        FutureBuilder<String>(
                          future: _getLocalImagePath(member.photoPath),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError || snapshot.data == null) {
                              return const Icon(Icons.person); // Placeholder icon if image not found
                            } else {
                              return Image.file(
                                File(snapshot.data!),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),

                      DataCell(Text(member.firstName)),
                      DataCell(Text(member.lastName)),
                      DataCell(Text(member.contactNumber)),
                      DataCell(Text(member.email)),
                      DataCell(Text(member.membershipType.target!.typeName)),
                      DataCell(Text(_getMembershipStatus(member))),
                      DataCell(Text(member.membershipStartDateFormat)),
                      DataCell(Text(_getRemainingMembershipDays(member))),
                      DataCell(Text(member.address)),
                    ]);
                  }).toList(),
                ),
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
      default:
        return '';
    }
  }

  String _getRemainingMembershipDays(Member member) {
    final membershipDays = member.getRemainingMembershipDays();
    return membershipDays.toString();
  }
}
