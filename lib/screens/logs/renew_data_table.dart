import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/model.dart';

class AdminRenewalLogPage extends StatefulWidget {
  const AdminRenewalLogPage({Key? key}) : super(key: key);

  @override
  State createState() => _AdminRenewalLogPageState();
}

class _AdminRenewalLogPageState extends State<AdminRenewalLogPage> {
  late List<AdminRenewalLog> adminRenewalLogs; // Declare adminRenewalLogs here
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    fetchAdminRenewalLogs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  Future<void> fetchAdminRenewalLogs() async {
    final logs = await objectbox.getAllAdminRenewalLogsAsync(); // Fetch admin renewal logs
    setState(() {
      adminRenewalLogs = logs; // Assign fetched admin renewal logs
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Renewal Logs'),
      ),
      body: _buildDataTable(),
    );
  }

  Widget _buildDataTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Member Name')),
        DataColumn(label: Text('Renewal Date')),
        DataColumn(label: Text('Admin Name')),
        DataColumn(label: Text('Membership Type')),
        DataColumn(label: Text('Amount Paid')),
        // Add more columns for log details
      ],
      rows: adminRenewalLogs.map((log) {
        return DataRow(cells: [
          DataCell(Text(log.memberName)),
          DataCell(Text(log.renewalDate.toString())),
          DataCell(Text(log.adminName)),
          DataCell(Text(log.membershipType)),
          DataCell(Text(log.amount.toString())),
          // Add more cells for log details
        ]);
      }).toList(),
    );
  }
}
