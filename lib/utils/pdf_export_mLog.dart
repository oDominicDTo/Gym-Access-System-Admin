import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:intl/intl.dart';

import '../models/model.dart';

class NewMemberPDFExporter {
  static Future<String?> exportToPDF(
      List<NewMemberLog> newMemberLogs,
      int selectedYear,
      int? selectedMonth,
      ) async {
    final PdfDocument document = PdfDocument();
    final List<NewMemberLog> logsToExport = _filterLogsForExport(newMemberLogs, selectedYear, selectedMonth);
    final PdfGrid grid = _createPdfGrid(logsToExport);
    final PdfPage page = document.pages.add();

    final String headerText = selectedMonth != null
        ? 'New Member Log - ${DateFormat('MMM').format(DateTime(selectedYear, selectedMonth))}, $selectedYear'
        : 'New Member Log - $selectedYear';

    _drawHeaderText(page, headerText);


    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
        0,
        30.0, // Update this value based on your header height and spacing
        page.getClientSize().width,
        page.getClientSize().height - 50.0, // Adjusted for the header and footer
      ),
      format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
    );

    _drawTotalAmount(page, newMemberLogs);

    final List<int> bytes = await document.save();
    document.dispose();

   // final String formattedDateTime = DateFormat('MM_dd_yyyy').format(DateTime.now());
    final String fileName = selectedMonth != null
        ? 'NewMember_Data_${DateFormat('MMM_yyyy').format(DateTime(selectedYear, selectedMonth))}.pdf'
        : 'NewMember_Data_$selectedYear.pdf';

    String? filePath = await FilePicker.platform.saveFile(
      allowedExtensions: ['pdf'],
      fileName: fileName,
      dialogTitle: 'Save PDF',
    );

    if (filePath != null) {
      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
      return filePath;
    }
    return null;
  }

  static Future<String?> exportToPDFForYear(
      List<NewMemberLog> newMemberLogs,
      int selectedYear,
      ) async {
    return await exportToPDF(newMemberLogs, selectedYear, null);
  }
  // Function to filter logs based on selected month and year
  static List<NewMemberLog> _filterLogsForExport(
      List<NewMemberLog> logs,
      int selectedYear,
      int? selectedMonth,
      ) {
    if (selectedMonth != null) {
      // Filter logs for the selected month and year
      return logs.where((log) => log.creationDate.year == selectedYear && log.creationDate.month == selectedMonth).toList();
    } else {
      // Return logs for the entire selected year
      return logs.where((log) => log.creationDate.year == selectedYear).toList();
    }
  }

  static PdfGrid _createPdfGrid(List<NewMemberLog> newMemberLogs) {
    final PdfGrid grid = PdfGrid();

    grid.style.cellPadding = PdfPaddings(top: 2, bottom: 2, left: 4, right: 4);

    grid.columns.add(count: 5);
    grid.headers.add(1);
    grid.headers[0].cells[0].value = 'Admin Name';
    grid.headers[0].cells[1].value = 'Creation Date';
    grid.headers[0].cells[2].value = 'Member Name';
    grid.headers[0].cells[3].value = 'Membership Type';
    grid.headers[0].cells[4].value = 'Amount';


    for (final NewMemberLog log in newMemberLogs) {
      final PdfGridRow pdfRow = grid.rows.add();
      final formattedDate =
      DateFormat('MMM dd, yyyy').format(log.creationDate.toLocal());
      pdfRow.cells[0].value = log.adminName;
      pdfRow.cells[1].value = formattedDate; // Format it as needed
      pdfRow.cells[2].value = log.memberName;
      pdfRow.cells[3].value = log.membershipType;
      pdfRow.cells[4].value = log.amount.toString();

    }

    return grid;
  }

  static void _drawHeaderText(PdfPage page, String headerText) {
    final PdfStringFormat format = PdfStringFormat(
      alignment: PdfTextAlignment.center,
      lineAlignment: PdfVerticalAlignment.middle,
    );

    List<String> lines = headerText.split('\n');
    double lineHeight = 15.0; // Adjust this value based on your font size and spacing

    for (int i = 0; i < lines.length; i++) {
      page.graphics.drawString(
        lines[i],
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(
          0,
          i * lineHeight,
          page.getClientSize().width,
          30.0, // Adjust this value based on your header height
        ),
        format: format,
      );
    }
  }


  static void _drawTotalAmount(PdfPage page, List<NewMemberLog> newMemberLogs) {
    final PdfStringFormat totalFormat = PdfStringFormat(
      alignment: PdfTextAlignment.right,
    );

    double lineHeight = 15.0; // Adjust this value based on your font size and spacing
    final double totalAmount = newMemberLogs.fold<double>(
      0.0,
          (previousValue, log) => previousValue + log.amount,
    );

    final String totalAmountText = 'Total Amount: PHP ${totalAmount.toStringAsFixed(2)}';


    page.graphics.drawString(
      totalAmountText,
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: Rect.fromLTWH(
        0,
        page.getClientSize().height - lineHeight * 2,
        page.getClientSize().width,
        lineHeight * 2,
      ),
      format: totalFormat,
    );
  }
}
