import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gym_kiosk_admin/models/model.dart';

class MemberDataSource extends DataTableSource {
  late List<Member> _members;
  final Function(Member) openProfileDialog;
  int? _selectedRowIndex;
  final void Function(int memberId) deleteMemberAndRefresh;

  MemberDataSource(this._members, {required this.openProfileDialog,  required this.deleteMemberAndRefresh,});

  @override
  DataRow getRow(int index) {
    final member = _members[index];
    return DataRow.byIndex(
        index: index,
        selected: _selectedRowIndex == index,
        onSelectChanged: (isSelected) {
          if (isSelected != null && isSelected) {
            openProfileDialog(member); // Call the method to open the profile dialog
          }
        },
        cells: [
          DataCell(
        FutureBuilder<String>(
          future: _getLocalImagePath(member.photoPath),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Icon(Icons.person); // Placeholder icon if image not found
            } else {
              final file = File(snapshot.data!);
              if (!file.existsSync()) {
                return const Icon(Icons.person); // Placeholder icon if image file doesn't exist
              }
              return Image.file(
                file,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              );
            }
          },
        ),

      ),
      DataCell(Text('${member.firstName} ${member.lastName}')),
      DataCell(Text(member.contactNumber)),
      DataCell(Text(member.membershipType.target?.typeName ?? '')),
      DataCell(Text(_getMembershipStatus(member))),
      DataCell(Text(_getRemainingMembershipDuration(member))),
      DataCell(Text(member.address)),
    ]);
  }

  @override
  int get rowCount => _members.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;


  Future<String> _getLocalImagePath(String imagePath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String localPath = '${appDocDir.path}/Kiosk/Photos/$imagePath';
    return localPath.replaceAll(r'\', '/'); // Ensure correct separators
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
  void updateDataSource(List<Member> updatedMembers) {
    _members.clear();
    _members.addAll(updatedMembers);
    notifyListeners();
  }

  List<Member> getFilteredMembers(String suggestion) {
    return _members.where((member) =>
        '${member.firstName} ${member.lastName}'.toLowerCase().contains(suggestion.toLowerCase())
    ).toList();
  }
}

