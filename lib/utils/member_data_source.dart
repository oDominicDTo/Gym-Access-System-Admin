import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gym_kiosk_admin/models/model.dart';

class MemberDataSource extends DataTableSource {
  final List<Member> _members;
  final bool _sortAscending = true; // Initially sorting in ascending order
  late int _sortColumnIndex = 1; // Initial sort column index (considering Name column)

  MemberDataSource(this._members);

  @override
  DataRow getRow(int index) {
    final member = _members[index];
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
      DataCell(
        GestureDetector(
          onTap: () {
            _sortByName(); // Call method to perform sorting by name
          },
          child: Text('${member.firstName} ${member.lastName}'),
        ),
      ),
      DataCell(Text(member.contactNumber)),
      DataCell(Text(member.membershipType.target!.typeName)),
      DataCell(
        GestureDetector(
          onTap: () {
            _sortByStatus; // Call method to perform sorting by status
          },
          child: Text(_getMembershipStatus(member)),
        ),
      ),
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

  // Add a method to sort by name
  void _sortByName() {
    _sortColumnIndex = 1; // Set the sort column index for Name
    _members.sort((a, b) {
      final nameA = '${a.firstName} ${a.lastName}';
      final nameB = '${b.firstName} ${b.lastName}';
      return _sortAscending ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
    });

    notifyListeners(); // Notify listeners after sorting
  }

  void _sortByStatus(bool ascending) {
    _members.sort((a, b) {
      final statusA = _getMembershipStatus(a);
      final statusB = _getMembershipStatus(b);
      return ascending ? statusA.compareTo(statusB) : statusB.compareTo(statusA);
    });
    notifyListeners();
  }


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

}
