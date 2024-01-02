import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../services/nfc_service.dart';

class Attendance {
  final Member member;
  final DateTime checkInTime;
  final DateTime? checkOutTime;

  Attendance({
    required this.member,
    required this.checkInTime,
    this.checkOutTime,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Attendance> _memberAttendanceList = [];
  late NFCService _nfcService;

  @override
  void initState() {
    super.initState();
    _nfcService = NFCService();
    _startNFCListener();
  }

  @override
  void dispose() {
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
    if (member != null) {
      DateTime currentTime = DateTime.now();

      // Find if the member has an existing check-in entry that hasn't checked out
      int index = 0;
      for (var attendance in _memberAttendanceList) {
        if (attendance.member.id == member.id && attendance.checkOutTime == null) {
          objectbox.logCheckOut(member, checkOutTime: currentTime);
          setState(() {
            _memberAttendanceList[index] = Attendance(
              member: member,
              checkInTime: attendance.checkInTime,
              checkOutTime: currentTime,
            );
          });
          break;
        }
        index++;
      }

      // If no existing check-in entry, create a new check-in entry
      bool alreadyCheckedIn = _memberAttendanceList.any((attendance) =>
      attendance.member.id == member.id && attendance.checkOutTime == null);

      if (!alreadyCheckedIn) {
        objectbox.logCheckIn(member, checkInTime: currentTime);
        setState(() {
          _memberAttendanceList.insert(
            0,
            Attendance(
              member: member,
              checkInTime: currentTime,
              checkOutTime: null,
            ),
          );
        });
      }
    } else {
      // Handle the case where the member is not found
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
                      DataCell(Text(DateFormat('h:mm a').format(attendance.checkInTime))),
                      DataCell(Text(attendance.checkOutTime != null ? DateFormat('h:mm a').format(attendance.checkOutTime!) : '---')),
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
