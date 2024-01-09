import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/main.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:gym_kiosk_admin/utils/member_data_source.dart';
import 'package:gym_kiosk_admin/utils/pdf_export.dart';
import '../dialog/member_profile_dialog.dart';
import '../widgets/search_bar.dart';
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
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadMembersData();
    _selectedStatus = '';
  }

  Future<void> _loadMembersData() async {
    _membersData = objectbox.getMembersSortedByStartDate();
    _displayedMembers = List.from(_membersData); // Initial display will show all members
    setState(() {});
  }

  void _deleteMemberAndRefresh(int memberId) {
    objectbox.deleteMember(memberId); // Delete member from ObjectBox
    _membersData.removeWhere((member) => member.id == memberId);
    _displayedMembers.removeWhere((member) => member.id == memberId);
    setState(() {});
  }

  void _applyFilters(List<String> selectedFilters, String? selectedStatus) {
    setState(() {
      _appliedFilters = selectedFilters;
      _selectedStatus = selectedStatus;

      _displayedMembers = List.from(_membersData);

      // Apply membership type filter
      if (_appliedFilters.isNotEmpty) {
        _displayedMembers = _displayedMembers.where((member) {
          return _appliedFilters.contains(member.membershipType.target?.typeName);
        }).toList();
      }

      // Apply status filter
      if (_selectedStatus != null && _selectedStatus!.isNotEmpty) {
        _displayedMembers = _displayedMembers.where((member) {
          switch (_selectedStatus) {
            case 'Active':
              return member.getMembershipStatus() == MembershipStatus.active;
            case 'Inactive':
              return member.getMembershipStatus() == MembershipStatus.inactive;
            case 'Expired':
              return member.getMembershipStatus() == MembershipStatus.expired;
            default:
              return true; // Return all members if no status filter is applied
          }
        }).toList();

        // Check if there are no members with the selected status
        final hasMembersWithStatus = _displayedMembers.any((member) {
          switch (_selectedStatus) {
            case 'Active':
              return member.getMembershipStatus() == MembershipStatus.active;
            case 'Inactive':
              return member.getMembershipStatus() == MembershipStatus.inactive;
            case 'Expired':
              return member.getMembershipStatus() == MembershipStatus.expired;
            default:
              return true; // Return true for other statuses
          }
        });

        // If no members with the selected status, show a Snackbar
        if (!hasMembersWithStatus) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No members found with $_selectedStatus status',
              ),
            ),
          );
        }
      }

      // Apply search query to the displayed members
      _displayedMembers = _displayedMembers.where((member) =>
          '${member.firstName} ${member.lastName}'
              .toLowerCase()
              .contains(_searchQuery)).toList();

      _displayedMembers = _sortMembers(_displayedMembers);
    });
  }

  void _openProfileDialog(Member member) {
    MemberProfileDialog().open(context, member, _deleteMemberAndRefresh);
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
  void exportPDF() async {
    final dataSource = MemberDataSource(_displayedMembers, openProfileDialog: (_) {}, deleteMemberAndRefresh: (int memberId) {  });

    String? filePath = await PDFExporter.exportToPDF(dataSource, context);

    if (filePath != null) {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text('PDF saved at $filePath'),
        ),
      );
    } else {
      _scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Failed to save PDF'),
        ),
      );
    }
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
                    const Text('Filter', style: TextStyle(color: Colors.black, fontFamily: 'Poppins')),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: SearchBarWidget(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                        // Apply search query to the displayed members whenever the text changes
                        _displayedMembers = _membersData.where((member) =>
                            '${member.firstName} ${member.lastName}'
                                .toLowerCase()
                                .contains(_searchQuery)).toList();
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
                  style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
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

            _displayedMembers = filteredData;
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
                      showCheckboxColumn: false,
                      columns: const [
                        DataColumn(label: Text('')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Contact Number')),
                        DataColumn(label: Text('Type')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Membership Duration')),
                        DataColumn(label: Text('Address')),
                      ],
                      rowsPerPage: rowsPerPage,
                      source: MemberDataSource(
                        _displayedMembers,
                        openProfileDialog: _openProfileDialog,
                        deleteMemberAndRefresh: _deleteMemberAndRefresh,
                      ),
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
