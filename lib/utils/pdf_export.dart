import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'member_data_source.dart';
import 'package:intl/intl.dart';

class PDFExporter {

  static Future<String?> exportToPDF(MemberDataSource dataSource,
      BuildContext context) async {
    final PdfDocument document = PdfDocument();
    final PdfGrid grid = PdfGrid();

    // Headers for PDF grid
    grid.columns.add(count: 5);
    grid.headers.add(1);
    grid.headers[0].cells[0].value = 'Name';
    grid.headers[0].cells[1].value = 'Contact Number';
    grid.headers[0].cells[2].value = 'Type';
    grid.headers[0].cells[3].value = 'Status';
    grid.headers[0].cells[4].value = 'Membership Duration';

    // Extract data synchronously from MemberDataSource
    for (int i = 0; i < dataSource.rowCount; i++) {
      final DataRow row = dataSource.getRow(i);
      final List<String> rowData = List<String>.generate(
        row.cells.length,
            (index) =>
        row.cells[index].child is Text
            ? (row.cells[index].child as Text).data ?? ''
            : '',
      );

      final PdfGridRow pdfRow = grid.rows.add();
      pdfRow.cells[0].value = rowData[1];
      pdfRow.cells[1].value = rowData[2];
      pdfRow.cells[2].value = rowData[3];
      pdfRow.cells[3].value = rowData[4];
      pdfRow.cells[4].value = rowData[5];
    }

    final PdfPage page = document.pages.add();
    const double headerHeight = 20.0; // Adjust this value based on your header height

    // Draw the header text at the top
    const String headerText =
        'OFFICE OF THE CITY YOUTH AND SPORTS DEVELOPMENT\n'
        'Northgate, Alonte Sports Arena Compound, City of Biñan, Laguna\n'
        'binanysdo16@gmail.com | (049) 513-5254 | https://facebook.com/bcysdo/\n'
        'BIÑAN CITY FITNESS AND GYM CENTER LOGBOOK';

    final PdfStringFormat format = PdfStringFormat(
      alignment: PdfTextAlignment.center,
      lineAlignment: PdfVerticalAlignment.middle,
    );

    List<String> lines = headerText.split('\n');
    double lineHeight = 10; // Adjust this value based on your font size and spacing

    for (int i = 0; i < lines.length; i++) {
      page.graphics.drawString(
        lines[i],
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(
          0,
          i * lineHeight,
          page
              .getClientSize()
              .width,
          headerHeight,
        ),
        format: format,
      );
    }

    // Add a 2-line spacing
    page.graphics.drawString(
      ' ',
      PdfStandardFont(PdfFontFamily.helvetica, 10),
      bounds: Rect.fromLTWH(
        0,
        lines.length * lineHeight,
        page
            .getClientSize()
            .width,
        lineHeight * 1,
      ),
      format: format,
    );

    // Draw the grid below the header text
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, lines.length * lineHeight + headerHeight, page
          .getClientSize()
          .width,
          page
              .getClientSize()
              .height - headerHeight),
      format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
    );

    final List<int> bytes = await document.save();
    document.dispose();

    final String formattedDateTime = DateFormat('MM_dd_yyyy').format(
        DateTime.now());
    final String fileName = 'Member_Data_$formattedDateTime.pdf'; // Construct filename with current date and time

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
}