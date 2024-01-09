import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import '../../main.dart';
import 'package:gym_kiosk_admin/utils/pdf_export_renew.dart'; // Import the PDF exporter

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
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    selectedYear = DateTime.now().year; // Set initial year to current year
    fetchMembersAndRenewalLogs();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
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
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Update searchQuery on input change
                    displayedMembers = _performSearch(searchQuery, filteredMembers); // Update displayedMembers
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                ),
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
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: TextButton.icon(
                    onPressed: () async {
                      String? filePath = await RenewalPDFExporter.exportToPDF(displayedMembers, renewalLogs);
                      if (filePath != null) {
                        // File saved successfully
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text('PDF saved at $filePath'),
                          ),
                        );
                      } else {
                        // Error while saving file
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text('Failed to save PDF'),
                          ),
                        );
                      }
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
          ],
        ),
      ),
      body: _buildDataTable(months, displayedMembers),
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

  Widget _buildDataTable(List<String> months, List<Member> displayedMembers) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 40,
          columns: _buildColumns(months),
          rows: _buildRows(months, displayedMembers), // Pass renewalLogs here
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(List<String> months) {
    return months.map((month) => DataColumn(label: Text(month))).toList();
  }

  List<DataRow> _buildRows(List<String> months, List<Member> displayedMembers) {
    displayedMembers.sort((a, b) => ('${a.firstName} ${a.lastName}').compareTo('${b.firstName} ${b.lastName}'));

    List<DataRow> rows = [];

    for (var member in displayedMembers) {
      List<DataCell> cells = [
        DataCell(Text('${member.firstName} ${member.lastName}', style: const TextStyle(fontFamily: 'Poppins'))),
        ...List.generate(12, (index) {
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
