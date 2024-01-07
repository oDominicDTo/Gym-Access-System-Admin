import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:gym_kiosk_admin/models/model.dart';
import 'package:intl/intl.dart';

class RenewalPDFExporter {
  static Future<String?> exportToPDF(List<Member> displayedMembers,
      List<RenewalLog> renewalLogs) async {
    final PdfDocument document = PdfDocument();
    const int rowsPerPage = 40; // Define the number of rows per page

    document.pageSettings.margins.left = 10;
    document.pageSettings.margins.top = 50;
    document.pageSettings.margins.right = 10;
    document.pageSettings.margins.bottom = 10;

    int rowIndex = 0;
    while (rowIndex < displayedMembers.length) {
      final PdfPage page = document.pages.add();
      final PdfGrid grid = _generatePDFContent(
          displayedMembers, renewalLogs, startRowIndex: rowIndex,
          rowsPerPage: rowsPerPage);
      grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, 0, page
            .getClientSize()
            .width, page
            .getClientSize()
            .height),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
      );
      rowIndex += rowsPerPage;
    }

    final List<int> bytes = await document.save();
    document.dispose();

    final String formattedDateTime = DateFormat('MM_dd_yyyy').format(
        DateTime.now());
    final String fileName = 'renewal_log_$formattedDateTime.pdf'; // Construct filename with current date and time

    String? filePath = await FilePicker.platform.saveFile(
      allowedExtensions: ['pdf'],
      fileName: fileName,
      dialogTitle: 'Save PDF',
    );

    if (filePath != null) {
      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
    }

    return filePath;
  }

  static PdfGrid _generatePDFContent(List<Member> displayedMembers,
      List<RenewalLog> renewalLogs,
      {int startRowIndex = 0, int rowsPerPage = 40}) {
    final PdfGrid grid = PdfGrid();

    // Headers for PDF grid
    grid.columns.add(count: 13);
    final List<String> months = [
      'Name',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    for (int i = 0; i < months.length; i++) {
      grid.headers.add(1);
      grid.headers[0].cells[i].value = months[i];

      // Center-align text in month columns, leave the 'Name' column left-aligned
      if (i != 0) {
        grid.headers[0].cells[i].stringFormat.alignment =
            PdfTextAlignment.center;
      }
    }

    // Adjust the width for the "Name" column
    grid.columns[0].width = 100; // Change this value according to your needs

    // Extract data from displayedMembers and renewalLogs within the range specified
    for (int i = startRowIndex; i < startRowIndex + rowsPerPage &&
        i < displayedMembers.length; i++) {
      final Member member = displayedMembers[i];
      final List<String> rowData = [
        '${member.firstName} ${member.lastName}',
        // Assuming the logic for renewalLogs remains the same
        // (retrieving logs based on member and month)
        for (int monthIndex = 1; monthIndex <=
            12; monthIndex++) // Month-wise data
          renewalLogs
              .firstWhere(
                (log) =>
            log.member.target!.id == member.id &&
                log.renewalDate.month == monthIndex,
            orElse: () => RenewalLog(
                id: 0, renewalDate: DateTime(1900), addedDurationDays: 0),
          )
              .id != 0
              ? renewalLogs
              .firstWhere(
                (log) =>
            log.member.target!.id == member.id &&
                log.renewalDate.month == monthIndex,
            orElse: () => RenewalLog(
                id: 0, renewalDate: DateTime(1900), addedDurationDays: 0),
          )
              .renewalDate
              .day
              .toString()
              : '-',
      ];
      final PdfGridRow pdfRow = grid.rows.add();
      for (int j = 0; j < rowData.length; j++) {
        pdfRow.cells[j].value = rowData[j];

        // Center-align text in month columns, leave the 'Name' column left-aligned
        if (j != 0) {
          pdfRow.cells[j].stringFormat.alignment = PdfTextAlignment.center;
        }
      }
    }

    return grid;
  }
}