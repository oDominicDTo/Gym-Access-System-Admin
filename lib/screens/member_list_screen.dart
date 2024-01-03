import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/main.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:gym_kiosk_admin/utils/member_data_source.dart';
import 'package:gym_kiosk_admin/utils/pdf_export.dart';
import '../widgets/member_search_bar.dart';
import 'package:gym_kiosk_admin/widgets/filter_dialog.dart';

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
  List<Member> _membersData = [];
  List<Member> _displayedMembers = [];
  late List<String> _appliedFilters = [];
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadMembersData();
    _selectedStatus = '';
  }

  Future<void> _loadMembersData() async {
    _membersData = objectbox.getAllMembers();
    _displayedMembers =
        List.from(_membersData); // Initial display will show all members
    setState(() {});
  }

  void _applyFilters(List<String> selectedFilters, String? selectedStatus) {
    setState(() {
      _appliedFilters = selectedFilters;

      _displayedMembers = List.from(_membersData);

      // Apply membership type filter
      if (_appliedFilters.isNotEmpty) {
        _displayedMembers = _displayedMembers.where((member) {
          return _appliedFilters.contains(member.membershipType.target?.typeName);
        }).toList();
      }

      // Apply status filter
      if (selectedStatus != null && selectedStatus.isNotEmpty) {
        filterMembersByStatus(selectedStatus);
      }

      // Apply search query to the displayed members
      _displayedMembers = _displayedMembers.where((member) =>
          '${member.firstName} ${member.lastName}'
              .toLowerCase()
              .contains(_searchQuery)).toList();

      _displayedMembers = _sortMembers(_displayedMembers);
    });
  }

  void filterMembersByStatus(String selectedStatus) {
    setState(() {
      if (_appliedFilters.isNotEmpty) {
        _displayedMembers = _displayedMembers.where((member) {
          return _appliedFilters.contains(member.membershipType.target?.typeName);
        }).toList();
      } else {
        _displayedMembers = List.from(_membersData);
      }

      // Apply status filter to the currently displayed members
      if (selectedStatus == 'Active') {
        _displayedMembers = _displayedMembers
            .where((member) => member.getMembershipStatus() == MembershipStatus.active)
            .toList();
      } else if (selectedStatus == 'Inactive') {
        _displayedMembers = _displayedMembers
            .where((member) => member.getMembershipStatus() == MembershipStatus.inactive)
            .toList();
      } else if (selectedStatus == 'Expired') {
        _displayedMembers = _displayedMembers
            .where((member) => member.getMembershipStatus() == MembershipStatus.expired)
            .toList();
      }

      // Apply search query to the displayed members
      _displayedMembers = _displayedMembers.where((member) =>
          '${member.firstName} ${member.lastName}'
              .toLowerCase()
              .contains(_searchQuery)).toList();

      _displayedMembers = _sortMembers(_displayedMembers);
    });
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          onApplyFilters: _applyFilters,
          appliedFilters: _appliedFilters,
          appliedStatus: _selectedStatus, // Pass _selectedStatus to the dialog
          onStatusSelected: (status) {
            setState(() {
              _selectedStatus = status; // Update _selectedStatus
            });
          },
        );
      },
    );
  }
  void exportPDF() {
    final dataSource = MemberDataSource(_displayedMembers);
    PDFExporter.exportToPDF(dataSource);
  }

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
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: TextButton.icon(
                onPressed: () {
                  showFilterDialog();
                },
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
                label:
                    const Text('Filter', style: TextStyle(color: Colors.black)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: MemberSearchBar(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50),
              child: TextButton.icon(
                onPressed: () {
                exportPDF();
                },
                icon: const Icon(
                  Icons.file_download,
                  color: Colors.black,
                ),
                label: const Text(
                  'Export',
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Member>>(
        stream: objectbox.getAllMembersAsync().asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error handling...
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // No data available...
          } else {
            final List<Member> filteredData = _displayedMembers.isEmpty
                ? snapshot.data!
                : _displayedMembers.where((member) {
              final String fullName =
              '${member.firstName} ${member.lastName}'.toLowerCase();
              return fullName.contains(_searchQuery);
            }).toList();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: 1000,
                width: 2000,
                child: Theme(
                  data: ThemeData.light().copyWith(
                    cardColor: Theme.of(context).canvasColor,
                  ),
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
                            _sortByName(filteredData, ascending);

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
                            _sortByStatus(filteredData, ascending);

                          },
                        ),
                        const DataColumn(label: Text('Membership Duration')),
                        const DataColumn(label: Text('Address')),
                      ],
                      rowsPerPage: rowsPerPage,
                      source: MemberDataSource(_displayedMembers),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  void _sortByStatus(List<Member> members, bool ascending) {
    members.sort((a, b) {
      final statusA = _getMembershipStatus(a);
      final statusB = _getMembershipStatus(b);
      return ascending
          ? statusA.compareTo(statusB)
          : statusB.compareTo(statusA);
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
