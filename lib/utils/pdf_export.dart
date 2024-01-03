import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart' as p;
import 'member_data_source.dart';

class PDFExporter {
  static Future<void> exportToPDF(MemberDataSource dataSource) async {
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
            (index) => row.cells[index].child is Text
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
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height),
      format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
    );

    final List<int> bytes = await document.save();
    document.dispose();

    final String dir = p.join((await getApplicationDocumentsDirectory()).path, "Kiosk");
    final Directory directory = Directory(dir);
    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }

    final DateTime now = DateTime.now();
    final String formattedDateTime = '${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';

    final File file = File(p.join(dir, "member_data_$formattedDateTime.pdf"));
    await file.writeAsBytes(bytes, flush: true);
  }
}
