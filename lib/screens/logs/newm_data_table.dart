import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import '../../main.dart';
import 'package:gym_kiosk_admin/utils/pdf_export_mLog.dart'; // Import the PDF exporter

class NewMemberLogPage extends StatefulWidget {
  const NewMemberLogPage({Key? key}) : super(key: key);

  @override
  State createState() => _NewMemberLogPageState();
}

class _NewMemberLogPageState extends State<NewMemberLogPage> {
  late int selectedYear;
  late int selectedMonth; // Initialize selectedMonth
  List<NewMemberLog> newMemberLogs = [];
  late GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  @override
  void initState() {
    super.initState();
    scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
    fetchNewMemberLogs();
    scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  }

  Future<void> fetchNewMemberLogs() async {
    final List<NewMemberLog> fetchedNewMemberLogs = await fetchNewMemberLogsForYearAndMonth(selectedYear, selectedMonth);

    setState(() {
      newMemberLogs = fetchedNewMemberLogs;
    });
  }

  Future<void> exportSelectedYear() async {
    String? filePath = await NewMemberPDFExporter.exportToPDFForYear(newMemberLogs, selectedYear);
    handleExportResult(filePath);
  }

  Future<void> exportSelectedMonthYear() async {
    String? filePath = await NewMemberPDFExporter.exportToPDF(newMemberLogs, selectedYear, selectedMonth);
    handleExportResult(filePath);
  }

  void handleExportResult(String? filePath) {
    if (filePath != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('PDF saved at $filePath'),
        ),
      );
    } else {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Failed to save PDF'),
        ),
      );
    }
  }

  Future<List<NewMemberLog>> fetchNewMemberLogsForYearAndMonth(int year, int month) async {
    // Implement logic to fetch new member logs for the selected year and month from ObjectBox
    // Example:
    return objectbox.getNewMemberLogsForYearAndMonth(year, month);
  }

  @override
  Widget build(BuildContext context) {
    List<String> columns = [
      'Admin Name',
      'Creation Date',
      'Member Name',
      'Membership Type',
      'Amount',
    ];

    return Scaffold(
      key: scaffoldMessengerKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                if (selectedMonth > 1) { // Check before decrementing selectedMonth
                  setState(() {
                    selectedMonth -= 1;
                  });
                } else {
                  setState(() {
                    selectedMonth = 12;
                    selectedYear -= 1;
                  });
                }
                await fetchNewMemberLogs();
              },
              icon: const Icon(Icons.arrow_left),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedYear-${selectedMonth.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                IconButton(
                  onPressed: () async {
                    if (selectedMonth < 12) { // Check before incrementing selectedMonth
                      setState(() {
                        selectedMonth += 1;
                      });
                    } else {
                      setState(() {
                        selectedMonth = 1;
                        selectedYear += 1;
                      });
                    }
                    await fetchNewMemberLogs();
                  },
                  icon: const Icon(Icons.arrow_right),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: const Text('This Year'),
                          onTap: () async {
                            await exportSelectedYear();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.date_range),
                          title: const Text('Selected Month and Year'),
                          onTap: () async {
                            await exportSelectedMonthYear();
                          },
                        ),
                      ],
                    );
                  },
                );
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
          ],
        ),
      ),
      body: _buildDataTable(columns),
    );
  }

  Widget _buildDataTable(List<String> columns) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 40,
          columns: _buildColumns(columns),
          rows: _buildRows(columns),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(List<String> columns) {
    return columns.map((column) => DataColumn(label: Text(column))).toList();
  }

  List<DataRow> _buildRows(List<String> columns) {
    List<DataRow> rows = [];

    for (var log in newMemberLogs) {
      List<DataCell> cells = [
        DataCell(Text(log.adminName)),
        DataCell(Text(log.getFormattedCreationDate())),
        DataCell(Text(log.memberName)),
        DataCell(Text(log.membershipType)),
        DataCell(Text(log.amount.toString())),
      ];

      if (cells.length == columns.length) {
        DataRow row = DataRow(cells: cells);
        rows.add(row);
      }
    }

    return rows;
  }
}