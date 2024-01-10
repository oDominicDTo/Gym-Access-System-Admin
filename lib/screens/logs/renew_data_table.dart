import 'package:flutter/material.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import '../../main.dart';
import '../../utils/pdf_export_aLog.dart';

class AdminRenewalLogPage extends StatefulWidget {
  const AdminRenewalLogPage({Key? key}) : super(key: key);

  @override
  State createState() => _AdminRenewalLogPageState();
}

class _AdminRenewalLogPageState extends State<AdminRenewalLogPage> {
  late int selectedYear;
  late int selectedMonth;
  List<AdminRenewalLog> adminRenewalLogs = [];
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
    fetchAdminRenewalLogs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  Future<void> fetchAdminRenewalLogs() async {
    final List<AdminRenewalLog> fetchedAdminRenewalLogs =
        await fetchAdminRenewalLogsForYearAndMonth(selectedYear, selectedMonth);

    setState(() {
      adminRenewalLogs = fetchedAdminRenewalLogs;
    });
  }

  Future<void> exportSelectedYear() async {
    String? filePath = await AdminRenewalLogPDFExporter.exportToPDFForYear(
        adminRenewalLogs, selectedYear);
    handleExportResult(filePath);
  }

  Future<void> exportSelectedMonthYear() async {
    String? filePath = await AdminRenewalLogPDFExporter.exportToPDF(
        adminRenewalLogs, selectedYear, selectedMonth);
    handleExportResult(filePath);
  }

  void handleExportResult(String? filePath) {
    if (filePath != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('PDF saved at $filePath'),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to save PDF'),
        ),
      );
    }
  }

  Future<List<AdminRenewalLog>> fetchAdminRenewalLogsForYearAndMonth(
      int year, int month) async {
    // Implement logic to fetch admin renewal logs for the selected year and month from ObjectBox
    // Example:
    return objectbox.getAdminRenewalLogsForYearAndMonth(year, month);
  }

  @override
  Widget build(BuildContext context) {
    List<String> columns = [
      'Admin Name',
      'Renewal Date',
      'Member Name',
      'Membership Type',
      'Added Days',
      'Amount',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                if (selectedMonth > 1) {
                  setState(() {
                    selectedMonth -= 1;
                  });
                } else {
                  setState(() {
                    selectedMonth = 12;
                    selectedYear -= 1;
                  });
                }
                await fetchAdminRenewalLogs();
              },
              icon: const Icon(Icons.arrow_left),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedYear-${selectedMonth.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                IconButton(
                  onPressed: () async {
                    if (selectedMonth < 12) {
                      setState(() {
                        selectedMonth += 1;
                      });
                    } else {
                      setState(() {
                        selectedMonth = 1;
                        selectedYear += 1;
                      });
                    }
                    await fetchAdminRenewalLogs();
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
                            exportSelectedYear();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.date_range),
                          title: const Text('Selected Month and Year'),
                          onTap: () async {
                            exportSelectedMonthYear();
                            Navigator.pop(context);
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

    for (var log in adminRenewalLogs) {
      List<DataCell> cells = [
        DataCell(Text(log.adminName)),
        DataCell(Text(log.getFormattedRenewalDate())),
        DataCell(Text(log.memberName)),
        DataCell(Text(log.membershipType)),
        DataCell(Text(log.addedDurationDays.toString())),
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
