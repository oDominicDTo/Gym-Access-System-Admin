import 'package:flutter/material.dart'; // Import your ObjectBox class
import 'package:gym_kiosk_admin/models/model.dart'; // Import your models
import 'package:gym_kiosk_admin/services/nfc_service.dart';
import 'package:intl/intl.dart';
import '../main.dart'; // Import your NFCService

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NFCService _nfcService;
  final List<MemberAttendance> _memberAttendanceList = [];
  bool _mounted = false; // Track the state

  @override
  void initState() {
    super.initState();
    _mounted = true;
    _nfcService = NFCService();
    _startNFCListener();
  }

  @override
  void dispose() {
    _mounted = false;
    _nfcService.disposeNFCListener();
    super.dispose();
  }

  void _startNFCListener() {
    _nfcService.onNFCEvent.listen((tagId) {
      _handleNFCScan(tagId);
    });
  }

  void _handleNFCScan(String tagId) {
    Member? member = objectbox.getMemberByNfcTag(tagId);
    if (member != null && _mounted) {
      DateTime currentTime = DateTime.now();
      String formattedTime = DateFormat('h:mm a').format(currentTime);

      // Check if the member was already checked-in
      bool alreadyCheckedIn = _memberAttendanceList.any((attendance) => attendance.member.id == member.id);

      if (alreadyCheckedIn) {
        try {
          MemberAttendance existingAttendance = _memberAttendanceList.firstWhere((attendance) => attendance.member.id == member.id);
          existingAttendance.checkOutTime = formattedTime; // Assign String to checkOutTime

          // Log the attendance with check-out time
          objectbox.logAttendance(
            member,
            checkInTime: DateTime.parse(existingAttendance.checkInTime),
            checkOutTime: DateTime.parse(existingAttendance.checkOutTime ?? formattedTime),
          );

          // Update the UI
          setState(() {
            // Replace the existing record with the updated check-out time
            _memberAttendanceList.removeWhere((attendance) => attendance.member.id == member.id);
            _memberAttendanceList.add(existingAttendance);
          });
        } catch (e) {
          // Handle scenario when the attendance record is not found
          print('Attendance record not found for check-out: $e');
        }
      } else {
        // Member is checking in
        objectbox.logAttendance(member, checkInTime: currentTime);
        setState(() {
          _memberAttendanceList.insert(
            0,
            MemberAttendance(member: member, checkInTime: formattedTime, checkOutTime: null),
          );
        });
      }
    } else {
      // Handle the case where the widget is not mounted or member is not found
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Kiosk'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Member Attendance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Member Name')),
                  DataColumn(label: Text('Check-In Time')),
                  DataColumn(label: Text('Check-Out Time')),
                ],
                rows: _memberAttendanceList.map((attendance) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${attendance.member.firstName} ${attendance.member.lastName}')),
                      DataCell(Text(attendance.checkInTime.toString())),
                      DataCell(Text(attendance.checkOutTime ?? '---')),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For manual trigger (optional)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MemberAttendance {
  final Member member;
  final String checkInTime; // Changed to String from DateTime
  String? checkOutTime; // Changed to String from DateTime

  MemberAttendance({
    required this.member,
    required this.checkInTime,
    this.checkOutTime,
  });
}