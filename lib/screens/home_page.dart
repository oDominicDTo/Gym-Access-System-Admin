import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/main.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:gym_kiosk_admin/services/nfc_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import '../dialog/attendance/check_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NFCService _nfcService;
  Member? _scannedMember;
  final List<Member> _checkedInMembers = [];
  bool _isMounted = false;
  List<Attendance> _attendanceLog = [];

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _nfcService = NFCService();
    _nfcService.onNFCEvent.listen((tagId) {
      if (_isMounted) {
        _handleNFCScan(tagId);
      }
    });
    _loadAttendanceForDay();
  }

  void _handleNFCScan(String tagId) async {
    Member? scannedMember = objectbox.getMemberByNfcTag(tagId);
    if (scannedMember != null) {
      setState(() {
        _scannedMember = scannedMember;
        _checkInMember(_scannedMember!);
      });
      // Reload attendance log after scanning
      _loadAttendanceForDay();
    }
  }

  void _showCheckDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CheckDialog(
          onCheckInConfirmed: () {
            _refreshHomePage();
          },
        );
      },
    );
  }

  void _refreshHomePage() {
    setState(() {
      // Call necessary methods to refresh the data on HomePage
      _loadAttendanceForDay();
      // Add other necessary refresh calls if needed
    });
  }

  void _loadAttendanceForDay() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    _attendanceLog =
        await objectbox.fetchAttendanceForDay(startOfDay, endOfDay);
    _attendanceLog.sort((a, b) => b.checkInTime
        .compareTo(a.checkInTime)); // Sort by checkInTime in descending order
    setState(() {}); // Refresh the UI after loading attendance
  }

  void _checkInMember(Member member) {
    if (!member.checkedIn) {
      DateTime checkInTime = DateTime.now();

      objectbox.logCheckIn(member.id, checkInTime: checkInTime);

      member.checkedIn = true;
      _checkedInMembers.add(member);
    } else {
      DateTime checkOutTime = DateTime.now();

      objectbox.logCheckOut(member.id, checkOutTime: checkOutTime);

      member.checkedIn = false;
      _checkedInMembers.removeWhere((m) => m.id == member.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: FutureBuilder<Widget>(
              future: _buildScannedMemberDetails(), // Display default details
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data ?? Container();
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 5,
            child: _buildCheckInOutTable(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCheckDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String> _getLocalImagePath(String imagePath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String localPath = '${appDocDir.path}/Kiosk/Photos/$imagePath';
    return localPath.replaceAll(r'\', '/');
  }

  Future<Widget> _buildScannedMemberDetails() async {
    if (_attendanceLog.isNotEmpty) {
      // Get the first entry (most recent) from the attendance log
      Attendance latestAttendance = _attendanceLog.first;
      Member member = objectbox.getMember(latestAttendance.memberId);

      String localImagePath = await _getLocalImagePath(member.photoPath);
      MembershipStatus status = member.getMembershipStatus();
      String statusText;
      Color statusColor;
      double statusSize = 20;

      switch (status) {
        case MembershipStatus.active:
          statusText = 'Active';
          statusColor = Colors.green;
          break;
        case MembershipStatus.expired:
          statusText = 'Expired';
          statusColor = Colors.red;
          break;
        case MembershipStatus.inactive:
          statusText = 'Inactive';
          statusColor = Colors.red;
          break;
        default:
          statusText = 'Unknown';
          statusColor = Colors.grey;
      }

      File imageFile = File(localImagePath);
      if (imageFile.existsSync()) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                imageFile,
                width: 400,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${member.firstName} ${member.lastName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              member.membershipType.target?.typeName ?? 'Unknown',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Membership Status: $statusText',
              style: TextStyle(fontSize: statusSize, color: statusColor),
            ),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 100), // Display default person icon
            const SizedBox(height: 10),
            Text(
              '${member.firstName} ${member.lastName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              member.membershipType.target?.typeName ?? 'Unknown',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Membership Status: $statusText',
              style: TextStyle(fontSize: statusSize, color: statusColor),
            ),
          ],
        );
      }
    } else {
      return const Center(
        child: Text('No attendance available'),
      );
    }
  }


  Widget _buildCheckInOutTable() {
    if (_attendanceLog.isEmpty) {
      return const Center(child: Text('No attendance available'));
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              dataRowMaxHeight: 60, // Adjust the row height as needed
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Check-In Time')),
                DataColumn(label: Text('Check-Out Time')),
                DataColumn(label: Text('Status')),
              ],
              rows: _attendanceLog.map((attendance) {
                Member member = objectbox.getMember(attendance.memberId);

                String formattedCheckInTime =
                DateFormat('h:mm a').format(attendance.checkInTime);

                String checkOutTime = attendance.checkOutTime != null &&
                    attendance.checkOutTime != DateTime(2000, 1, 1)
                    ? DateFormat('h:mm a').format(attendance.checkOutTime!)
                    : '---';

                MembershipStatus status = member.getMembershipStatus();
                String statusText;
                Color statusColor;
                double statusSize = 16; // Adjust font size here

                switch (status) {
                  case MembershipStatus.active:
                    statusText = 'Active';
                    statusColor = Colors.green;
                    break;
                  case MembershipStatus.expired:
                    statusText = 'Expired';
                    statusColor = Colors.red;
                    break;
                  case MembershipStatus.inactive:
                    statusText = 'Inactive';
                    statusColor = Colors.red;
                    break;
                  default:
                    statusText = 'Unknown';
                    statusColor = Colors.grey;
                }

                return DataRow(cells: [
                  DataCell(Text(
                    '${member.firstName} ${member.lastName}',
                    style: const TextStyle(fontSize: 14), // Adjust font size here
                  )),
                  DataCell(Text(
                    member.membershipType.target?.typeName ?? "Unknown",
                    style: const TextStyle(fontSize: 14), // Adjust font size here
                  )),
                  DataCell(Text(
                    formattedCheckInTime,
                    style: const TextStyle(fontSize: 14), // Adjust font size here
                  )),
                  DataCell(Text(
                    checkOutTime,
                    style: const TextStyle(fontSize: 14), // Adjust font size here
                  )),
                  DataCell(Text(
                    statusText,
                    style: TextStyle(fontSize: statusSize, color: statusColor),
                  )),
                ]);
              }).toList(),
            ),
          ),
        ],
      );
    }
  }


  @override
  void dispose() {
    _isMounted = false;
    _nfcService.dispose();
    super.dispose();
  }
}
