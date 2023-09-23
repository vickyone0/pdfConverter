import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_document/open_document.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
void main() {
  runApp( MainApp());
}

class MainApp extends StatelessWidget {

  final PdfInvoiceService service = PdfInvoiceService();
   MainApp({super.key});

   List<List> details = [
    [1, "4:30 pm", 'ram',],
    [2, "5:30 pm", 'gam',],
    [3, "4:30 pm", 'ham',],
    
    
  ];
  

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final data = await service.createInvoice(details);
                    service.savePdfFile('invoice', data);
                  },
                  child: const Text("Create Invoice"),
                ),
            ],
          ),
        ),
      ),
    );
  }


}

  

class PdfInvoiceService {

   Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getDownloadsDirectory();
     var filePath = "${output!.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
     await OpenDocument.openDocument(filePath: filePath);
  }
  Future<Uint8List> createInvoice(List<List> fullDetails) async {
    final pdf = pw.Document();

    final List<CustomRow> elements = [
      CustomRow("Appointments", "Booking time", "Patient Name",),
      for (var detail in fullDetails)
        CustomRow(
          detail[0].toString(),
          detail[1],
          detail[2],
          
        ),
      
      
      
    ];
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              itemColumn(elements),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  pw.Expanded itemColumn(List<CustomRow> elements) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          for (var element in elements)
            pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Text(element.appointments,
                        textAlign: pw.TextAlign.left)),
                pw.Expanded(
                    child: pw.Text(element.bookingTime,
                        textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child:
                        pw.Text(element.patientName, textAlign: pw.TextAlign.right)),
              ],
            )
        ],
      ),
    );
  }
}




  class CustomRow {
  final String appointments;
  final String bookingTime;
  final String patientName;

  CustomRow(this.appointments, this.bookingTime, this.patientName);
  

  
}