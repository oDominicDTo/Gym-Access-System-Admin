import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/main.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:gym_kiosk_admin/utils/member_data_source.dart';

import '../widgets/member_search_bar.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({Key? key}) : super(key: key);

  @override
  createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  bool _sortAscending = true;
  int _sortColumnIndex =
      1; // Initial sort column index (considering Name column)
  late String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    int rowsPerPage;

    // Set rowsPerPage based on screen width and height
    if (screenSize.width <= 1366 || screenSize.height <= 768) {
      rowsPerPage = 8;
    } else if (screenSize.width >= 1920 || screenSize.height >= 1080) {
      rowsPerPage = 12;
    } else {
      rowsPerPage = 10; // Default value for other resolutions
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member List'),
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MemberSearchBar(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
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
            final filteredMembers = _searchQuery.isEmpty
                ? snapshot.data! // Show all members if no search query
                : snapshot.data!
                .where((member) =>
                '${member.firstName} ${member.lastName}'
                    .toLowerCase()
                    .contains(_searchQuery))
                .toList();

            final sortedMembers = _sortMembers(filteredMembers);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: 1000,
                width: 2000,
                child: Theme(
                  data: ThemeData.light()
                      .copyWith(cardColor: Theme.of(context).canvasColor),
                  child: SingleChildScrollView(
                    child: PaginatedDataTable(
                      sortAscending: _sortAscending,
                      sortColumnIndex: _sortColumnIndex,
                      arrowHeadColor: Colors.black,
                      dataRowMaxHeight: 60,
                      headingRowHeight: 40,
                      columns: [
                        const DataColumn(label: Text('')),
                        DataColumn(
                          label: const Text('Name'),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                            _sortByName(sortedMembers, ascending);
                          },
                        ),
                        const DataColumn(label: Text('Contact Number')),
                        const DataColumn(label: Text('Type')),
                        DataColumn(
                          label: const Text('Status'),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              _sortColumnIndex = columnIndex;
                              _sortAscending = ascending;
                            });
                            _sortByStatus(sortedMembers, ascending);
                          },
                        ),
                        const DataColumn(label: Text('Membership Duration')),
                        const DataColumn(label: Text('Address')),
                      ],
                      rowsPerPage: rowsPerPage,
                      source: MemberDataSource(sortedMembers),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _sortByStatus(List<Member> members, bool ascending) {
    members.sort((a, b) {
      final statusA = _getMembershipStatus(a);
      final statusB = _getMembershipStatus(b);
      return ascending ? statusA.compareTo(statusB) : statusB.compareTo(statusA);
    });
    setState(() {});
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
  // Sorting function by Name
  void _sortByName(List<Member> members, bool ascending) {
    members.sort((a, b) {
      final nameA = '${a.firstName} ${a.lastName}';
      final nameB = '${b.firstName} ${b.lastName}';
      return ascending ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
    });
  }

  // Function to sort members based on the selected column
  List<Member> _sortMembers(List<Member> members) {
    // Implement sorting logic based on different columns here if needed
    switch (_sortColumnIndex) {
      case 1: // Name column
        _sortByName(members, _sortAscending);
        break;
      // Add cases for other columns if required
    }
    return members;
  }
}
