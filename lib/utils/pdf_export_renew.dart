import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:gym_kiosk_admin/models/model.dart';

class RenewalPDFExporter {
  static Future<String?> exportToPDF(List<Member> displayedMembers, List<RenewalLog> renewalLogs) async {
    final PdfDocument document = PdfDocument();
    final PdfGrid grid = PdfGrid();

    // Headers for PDF grid
    grid.columns.add(count: 13);
    final List<String> months = [
      'Name', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
    ];
    for (int i = 0; i < months.length; i++) {
      grid.headers.add(1);
      grid.headers[0].cells[i].value = months[i];
    }

    // Extract data from displayedMembers and renewalLogs
    for (int i = 0; i < displayedMembers.length; i++) {
      final Member member = displayedMembers[i];
      final List<String> rowData = [
        '${member.firstName} ${member.lastName}',
        for (int monthIndex = 1; monthIndex <= 12; monthIndex++)
          renewalLogs
              .firstWhere(
                (log) => log.member.target!.id == member.id && log.renewalDate.month == monthIndex,
            orElse: () => RenewalLog(id: 0, renewalDate: DateTime(1900), addedDurationDays: 0),
          )
              .id != 0
              ? renewalLogs
              .firstWhere(
                (log) => log.member.target!.id == member.id && log.renewalDate.month == monthIndex,
            orElse: () => RenewalLog(id: 0, renewalDate: DateTime(1900), addedDurationDays: 0),
          )
              .renewalDate.day
              .toString()
              : '-',
      ];
      final PdfGridRow pdfRow = grid.rows.add();
      for (int j = 0; j < rowData.length; j++) {
        pdfRow.cells[j].value = rowData[j];
      }
    }

    final PdfPage page = document.pages.add();
    const double headerHeight = 20.0; // Define the header height
    const double lineHeight = 10.0; // Define the line height for text
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

    for (int i = 0; i < lines.length; i++) {
      page.graphics.drawString(
        lines[i],
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(
          0,
          i * lineHeight,
          page.getClientSize().width,
          headerHeight,
        ),
        format: format,
      );
    }

    // Draw the grid below the header text
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
        0,
        lines.length * lineHeight + headerHeight,
        page.getClientSize().width,
        page.getClientSize().height - headerHeight,
      ),
      format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
    );

    final List<int> bytes = await document.save();
    document.dispose();

    // Save the generated PDF file using FilePicker
    String? filePath = await FilePicker.platform.saveFile(
      allowedExtensions: ['pdf'],
      fileName: 'renewal_log.pdf',
      dialogTitle: 'Save PDF',
    );

    if (filePath != null) {
      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
    }

    return filePath;
  }
}
