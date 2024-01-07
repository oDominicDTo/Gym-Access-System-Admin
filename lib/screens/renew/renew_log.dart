import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/main.dart';
import 'package:gym_kiosk_admin/models/model.dart';

import '../../widgets/search_bar.dart';

class RenewalLogPage extends StatefulWidget {
  const RenewalLogPage({Key? key}) : super(key: key);

  @override
  State createState() => _RenewalLogPageState();
}

class _RenewalLogPageState extends State<RenewalLogPage> {
  late int selectedYear;
  List<Member> filteredMembers = [];
  String searchQuery = '';
  List<RenewalLog> renewalLogs = []; // Declare renewalLogs here

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year; // Set initial year to current year
    fetchMembersAndRenewalLogs();
  }

  Future<void> fetchMembersAndRenewalLogs() async {
    final List<dynamic> data = await Future.wait([
      fetchMembers(),
      fetchRenewalLogs(selectedYear),
    ]);

    List<Member> members = data[0];
    List<RenewalLog> fetchedRenewalLogs = data[1];

    setState(() {
      filteredMembers = members; // Set initial filtered members
      renewalLogs = fetchedRenewalLogs; // Assign fetched renewal logs
    });
  }

  Future<List<Member>> fetchMembers() async {
    // Implement logic to fetch members from ObjectBox
    // Example:
    return objectbox.getAllMembers();
  }

  Future<List<RenewalLog>> fetchRenewalLogs(int year) async {
    // Implement logic to fetch renewal logs for the selected year from ObjectBox
    // Example:
    return objectbox.getRenewalLogsForYear(year);
  }

  @override
  Widget build(BuildContext context) {
    List<String> months = [
      'Name', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
    ];

    // Define filteredMembers here
    List<Member> displayedMembers = _performSearch(searchQuery, filteredMembers);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            SizedBox(
              width: 300,
              child: Search_Bar(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Update searchQuery on input change
                    displayedMembers = _performSearch(searchQuery, filteredMembers); // Update displayedMembers
                  });
                },
              ),
            ),
            const SizedBox(width: 150),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: () {
                    setState(() {
                      selectedYear -= 1;
                      fetchMembersAndRenewalLogs(); // Fetch data for the updated year
                    });
                  },
                ),
                Text('$selectedYear', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: () {
                    setState(() {
                      selectedYear += 1;
                      fetchMembersAndRenewalLogs(); // Fetch data for the updated year
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: _buildDataTable(months, displayedMembers, context),
    );
  }

  List<Member> _performSearch(String query, List<Member> members) {
    // Implement the logic to filter members based on the query
    if (query.isEmpty) {
      return members; // If query is empty, return all members
    } else {
      // Filter members where either first name or last name contains the query (case insensitive)
      return members.where((member) =>
      member.firstName.toLowerCase().contains(query.toLowerCase()) ||
          member.lastName.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  Widget _buildDataTable(List<String> months, List<Member> displayedMembers, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 40,
          columns: _buildColumns(months),
          rows: _buildRows(months, displayedMembers, renewalLogs), // Pass renewalLogs here
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(List<String> months) {
    return months.map((month) => DataColumn(label: Text(month))).toList();
  }

  List<DataRow> _buildRows(List<String> months, List<Member> displayedMembers, List<RenewalLog> renewalLogs) {
    displayedMembers.sort((a, b) => ('${a.firstName} ${a.lastName}').compareTo('${b.firstName} ${b.lastName}'));

    List<DataRow> rows = [];

    for (var member in displayedMembers) {
      List<DataCell> cells = [
        DataCell(Text('${member.firstName} ${member.lastName}')),
        ...List.generate(12, (index) {
          // Assuming the logic for renewalLogs remains the same
          // (retrieving logs based on member and month)
          var renewalDate = renewalLogs.firstWhere(
                  (log) => log.member.target!.id == member.id && log.renewalDate.month == index + 1,
              orElse: () => RenewalLog(id: 0, renewalDate: DateTime(1900), addedDurationDays: 0)
          );

          if (renewalDate.id != 0) {
            return DataCell(Text(renewalDate.renewalDate.day.toString()));
          } else {
            return const DataCell(Text('-'));
          }
        }),
      ];

      DataRow row = DataRow(cells: cells);
      rows.add(row);
    }

    return rows;
  }
}
